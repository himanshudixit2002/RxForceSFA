import * as admin from "firebase-admin";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { onSchedule } from "firebase-functions/v2/scheduler";
import { defineSecret } from "firebase-functions/params";
import { GoogleGenerativeAI } from "@google/generative-ai";

admin.initializeApp();
const db = admin.firestore();

const geminiApiKey = defineSecret("GEMINI_API_KEY");

interface DoctorDoc {
  name: string;
  specialization: string;
  clinicAddress: string;
  territory: string;
  lastVisitDate?: admin.firestore.Timestamp;
  visitFrequency: number;
  conversionProbability: number;
  latitude: number;
  longitude: number;
}

interface RecommendedVisit {
  doctorName: string;
  specialization: string;
  address: string;
  score: number;
  reason: string;
}

function haversineDistance(
  lat1: number,
  lon1: number,
  lat2: number,
  lon2: number
): number {
  const R = 6371;
  const dLat = ((lat2 - lat1) * Math.PI) / 180;
  const dLon = ((lon2 - lon1) * Math.PI) / 180;
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos((lat1 * Math.PI) / 180) *
      Math.cos((lat2 * Math.PI) / 180) *
      Math.sin(dLon / 2) *
      Math.sin(dLon / 2);
  return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
}

export const getRecommendedVisits = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "You must be authenticated to call this function"
    );
  }

  const { mrId, latitude, longitude } = request.data;

  if (!mrId || typeof mrId !== "string") {
    throw new HttpsError("invalid-argument", "mrId must be a non-empty string");
  }

  if (mrId !== request.auth.uid) {
    throw new HttpsError(
      "permission-denied",
      "mrId must match the authenticated user"
    );
  }

  if (
    latitude == null ||
    longitude == null ||
    typeof latitude !== "number" ||
    typeof longitude !== "number"
  ) {
    throw new HttpsError(
      "invalid-argument",
      "latitude and longitude must be numbers"
    );
  }

  const snapshot = await db.collection("doctors").get();
  const now = Date.now();

  const scored: { doc: DoctorDoc; score: number; reason: string }[] = [];

  for (const docSnap of snapshot.docs) {
    const doc = docSnap.data() as DoctorDoc;

    let recencyScore = 0;
    if (doc.lastVisitDate) {
      const daysSinceVisit =
        (now - doc.lastVisitDate.toMillis()) / (1000 * 60 * 60 * 24);
      recencyScore = Math.min(daysSinceVisit / 30, 1.0);
    } else {
      recencyScore = 1.0;
    }

    const conversionScore = doc.conversionProbability || 0;

    const distance = haversineDistance(
      latitude,
      longitude,
      doc.latitude || 0,
      doc.longitude || 0
    );
    const proximityScore = Math.max(0, 1 - distance / 50);

    const totalScore =
      recencyScore * 0.4 + conversionScore * 0.4 + proximityScore * 0.2;

    const reasons: string[] = [];
    if (recencyScore > 0.7) reasons.push("Not visited recently");
    if (conversionScore > 0.6) reasons.push("High conversion potential");
    if (proximityScore > 0.5) reasons.push("Nearby");

    scored.push({
      doc,
      score: totalScore,
      reason: reasons.join(", ") || "Recommended",
    });
  }

  scored.sort((a, b) => b.score - a.score);

  const top3: RecommendedVisit[] = scored.slice(0, 3).map((s) => ({
    doctorName: s.doc.name,
    specialization: s.doc.specialization,
    address: s.doc.clinicAddress,
    score: Math.round(s.score * 100) / 100,
    reason: s.reason,
  }));

  return { recommendations: top3 };
});

export const parseDcrTranscript = onCall(
  { secrets: [geminiApiKey] },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError(
        "unauthenticated",
        "You must be authenticated to call this function"
      );
    }

    const { transcript } = request.data;
    if (!transcript || typeof transcript !== "string" || !transcript.trim()) {
      throw new HttpsError(
        "invalid-argument",
        "transcript must be a non-empty string"
      );
    }

    const genAI = new GoogleGenerativeAI(geminiApiKey.value());
    const model = genAI.getGenerativeModel({
      model: "gemini-1.5-flash",
      systemInstruction:
        "You are a medical sales call report parser. " +
        "Extract Doctor Name, Products Discussed, and Follow-up Date " +
        "from a medical representative's spoken report. " +
        'Return ONLY a valid JSON object with these exact keys: ' +
        '"doctorName" (string), ' +
        '"productsDiscussed" (array of strings), ' +
        '"followUpDate" (ISO 8601 date string or null). ' +
        "Do not include any other text, explanation, or markdown.",
    });

    try {
      const result = await model.generateContent(transcript);
      const text = result.response.text();
      if (!text) {
        throw new HttpsError("internal", "Empty response from Gemini");
      }

      let cleaned = text.trim();
      if (cleaned.startsWith("```")) {
        const firstNewline = cleaned.indexOf("\n");
        if (firstNewline !== -1) cleaned = cleaned.substring(firstNewline + 1);
        if (cleaned.endsWith("```"))
          cleaned = cleaned.substring(0, cleaned.length - 3);
        cleaned = cleaned.trim();
      }

      const parsed = JSON.parse(cleaned);
      return {
        doctorName: parsed.doctorName || "",
        productsDiscussed: parsed.productsDiscussed || [],
        followUpDate: parsed.followUpDate || null,
      };
    } catch (e: unknown) {
      if (e instanceof HttpsError) throw e;
      const message = e instanceof Error ? e.message : "Unknown error";
      throw new HttpsError("internal", `Failed to parse transcript: ${message}`);
    }
  }
);

// ─── Approval Processing ───

export const processApproval = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Authentication required");
  }

  const { approvalId, action, comments } = request.data;
  if (!approvalId || !action) {
    throw new HttpsError("invalid-argument", "approvalId and action required");
  }

  const approvalRef = db.collection("approvals").doc(approvalId);
  const approvalSnap = await approvalRef.get();
  if (!approvalSnap.exists) {
    throw new HttpsError("not-found", "Approval not found");
  }

  const approval = approvalSnap.data()!;

  if (approval.approverId !== request.auth.uid) {
    throw new HttpsError("permission-denied", "Not authorized to process");
  }

  const newStatus = action === "approve" ? 1 : 2; // 1=approved, 2=rejected

  await approvalRef.update({
    status: newStatus,
    comments: comments || "",
    processedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  // Notify the requester
  await db.collection("notifications").add({
    userId: approval.requesterId,
    title: `Request ${action === "approve" ? "Approved" : "Rejected"}`,
    body: `Your ${approval.type} request has been ${action === "approve" ? "approved" : "rejected"}`,
    type: 1, // approvalResult
    referenceId: approvalId,
    isRead: false,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  // If approved and type references another entity, update that entity's status
  if (action === "approve") {
    const entityType = _getCollectionForType(approval.type);
    if (entityType && approval.referenceId) {
      const entityRef = db.collection(entityType).doc(approval.referenceId);
      const entitySnap = await entityRef.get();
      if (entitySnap.exists) {
        await entityRef.update({ status: "approved", approvedBy: request.auth.uid });
      }
    }
  }

  return { success: true, status: action };
});

function _getCollectionForType(type: number): string | null {
  switch (type) {
    case 0: return "expenses";
    case 1: return "tourPlans";
    case 2: return "leaveRequests";
    case 3: return "orders";
    case 4: return "samples";
    default: return null;
  }
}

// ─── Push Notification Sender ───

export const sendNotification = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Authentication required");
  }

  const { userId, title, body, data } = request.data;
  if (!userId || !title) {
    throw new HttpsError("invalid-argument", "userId and title required");
  }

  // Get user's FCM token
  const userSnap = await db.collection("users").doc(userId).get();
  if (!userSnap.exists) {
    throw new HttpsError("not-found", "User not found");
  }

  const fcmToken = userSnap.data()?.fcmToken;
  if (fcmToken) {
    try {
      await admin.messaging().send({
        token: fcmToken,
        notification: { title, body: body || "" },
        data: data || {},
      });
    } catch (e) {
      console.error("Failed to send FCM:", e);
    }
  }

  // Always store in-app notification
  await db.collection("notifications").add({
    userId,
    title,
    body: body || "",
    type: 4, // system
    referenceId: data?.referenceId || "",
    isRead: false,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  return { success: true };
});

// ─── Daily Reminders (scheduled) ───

export const dailyReminders = onSchedule("every day 17:00", async () => {
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const tomorrow = new Date(today);
  tomorrow.setDate(tomorrow.getDate() + 1);

  // Find MRs who haven't submitted a DCR today
  const usersSnap = await db
    .collection("users")
    .where("role", "==", "mr")
    .where("isActive", "==", true)
    .get();

  for (const userDoc of usersSnap.docs) {
    const uid = userDoc.id;

    // Check if DCR exists for today
    const dcrSnap = await db
      .collection("dcrs")
      .where("mrId", "==", uid)
      .where("createdAt", ">=", admin.firestore.Timestamp.fromDate(today))
      .where("createdAt", "<", admin.firestore.Timestamp.fromDate(tomorrow))
      .limit(1)
      .get();

    if (dcrSnap.empty) {
      await db.collection("notifications").add({
        userId: uid,
        title: "DCR Reminder",
        body: "You have not submitted your Daily Call Report for today.",
        type: 2, // reminder
        referenceId: "",
        isRead: false,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }

    // Check attendance
    const attSnap = await db
      .collection("attendances")
      .where("mrId", "==", uid)
      .where("date", ">=", admin.firestore.Timestamp.fromDate(today))
      .where("date", "<", admin.firestore.Timestamp.fromDate(tomorrow))
      .limit(1)
      .get();

    if (attSnap.empty) {
      await db.collection("notifications").add({
        userId: uid,
        title: "Attendance Alert",
        body: "No attendance record found for today. Please punch in.",
        type: 3, // alert
        referenceId: "",
        isRead: false,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }
  }
});

// ─── Target Calculation (monthly) ───

export const calculateTargets = onSchedule("1 of month 01:00", async () => {
  const now = new Date();
  const lastMonth = now.getMonth(); // 0-indexed, so this is actually last month since we run on 1st
  const year = lastMonth === 0 ? now.getFullYear() - 1 : now.getFullYear();
  const month = lastMonth === 0 ? 12 : lastMonth;

  const targetsSnap = await db.collection("targets").get();

  for (const targetDoc of targetsSnap.docs) {
    const target = targetDoc.data();
    const period = `${year}-${month.toString().padStart(2, "0")}`;

    if (target.period !== period) continue;

    // Sum confirmed orders for this MR and product in the period
    const ordersSnap = await db
      .collection("orders")
      .where("mrId", "==", target.mrId)
      .where("status", ">=", 2) // confirmed or beyond
      .get();

    let achieved = 0;
    for (const orderDoc of ordersSnap.docs) {
      const itemsSnap = await db
        .collection("orderItems")
        .where("orderId", "==", orderDoc.id)
        .where("productId", "==", target.productId)
        .get();

      for (const item of itemsSnap.docs) {
        const itemData = item.data();
        achieved += (itemData.price || 0) * (itemData.quantity || 0);
      }
    }

    await targetDoc.ref.update({ achievedValue: achieved });
  }
});
