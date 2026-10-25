"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.parseDcrTranscript = exports.getRecommendedVisits = void 0;
const admin = __importStar(require("firebase-admin"));
const https_1 = require("firebase-functions/v2/https");
const params_1 = require("firebase-functions/params");
const generative_ai_1 = require("@google/generative-ai");
admin.initializeApp();
const db = admin.firestore();
const geminiApiKey = (0, params_1.defineSecret)("GEMINI_API_KEY");
function haversineDistance(lat1, lon1, lat2, lon2) {
    const R = 6371;
    const dLat = ((lat2 - lat1) * Math.PI) / 180;
    const dLon = ((lon2 - lon1) * Math.PI) / 180;
    const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos((lat1 * Math.PI) / 180) *
            Math.cos((lat2 * Math.PI) / 180) *
            Math.sin(dLon / 2) *
            Math.sin(dLon / 2);
    return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
}
exports.getRecommendedVisits = (0, https_1.onCall)(async (request) => {
    if (!request.auth) {
        throw new https_1.HttpsError("unauthenticated", "You must be authenticated to call this function");
    }
    const { mrId, latitude, longitude } = request.data;
    if (!mrId || typeof mrId !== "string") {
        throw new https_1.HttpsError("invalid-argument", "mrId must be a non-empty string");
    }
    if (mrId !== request.auth.uid) {
        throw new https_1.HttpsError("permission-denied", "mrId must match the authenticated user");
    }
    if (latitude == null ||
        longitude == null ||
        typeof latitude !== "number" ||
        typeof longitude !== "number") {
        throw new https_1.HttpsError("invalid-argument", "latitude and longitude must be numbers");
    }
    const snapshot = await db.collection("doctors").get();
    const now = Date.now();
    const scored = [];
    for (const docSnap of snapshot.docs) {
        const doc = docSnap.data();
        // Recency score: higher score for doctors not visited recently
        let recencyScore = 0;
        if (doc.lastVisitDate) {
            const daysSinceVisit = (now - doc.lastVisitDate.toMillis()) / (1000 * 60 * 60 * 24);
            recencyScore = Math.min(daysSinceVisit / 30, 1.0); // Cap at 1.0
        }
        else {
            recencyScore = 1.0; // Never visited = highest priority
        }
        // Conversion score
        const conversionScore = doc.conversionProbability || 0;
        // Proximity score: closer is better (inverse of distance, capped)
        const distance = haversineDistance(latitude, longitude, doc.latitude || 0, doc.longitude || 0);
        const proximityScore = Math.max(0, 1 - distance / 50); // 50km radius
        const totalScore = recencyScore * 0.4 + conversionScore * 0.4 + proximityScore * 0.2;
        const reasons = [];
        if (recencyScore > 0.7)
            reasons.push("Not visited recently");
        if (conversionScore > 0.6)
            reasons.push("High conversion potential");
        if (proximityScore > 0.5)
            reasons.push("Nearby");
        scored.push({
            doc,
            score: totalScore,
            reason: reasons.join(", ") || "Recommended",
        });
    }
    scored.sort((a, b) => b.score - a.score);
    const top3 = scored.slice(0, 3).map((s) => ({
        doctorName: s.doc.name,
        specialization: s.doc.specialization,
        address: s.doc.clinicAddress,
        score: Math.round(s.score * 100) / 100,
        reason: s.reason,
    }));
    return { recommendations: top3 };
});
exports.parseDcrTranscript = (0, https_1.onCall)({ secrets: [geminiApiKey] }, async (request) => {
    if (!request.auth) {
        throw new https_1.HttpsError("unauthenticated", "You must be authenticated to call this function");
    }
    const { transcript } = request.data;
    if (!transcript || typeof transcript !== "string" || !transcript.trim()) {
        throw new https_1.HttpsError("invalid-argument", "transcript must be a non-empty string");
    }
    const genAI = new generative_ai_1.GoogleGenerativeAI(geminiApiKey.value());
    const model = genAI.getGenerativeModel({
        model: "gemini-1.5-flash",
        systemInstruction: "You are a medical sales call report parser. " +
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
            throw new https_1.HttpsError("internal", "Empty response from Gemini");
        }
        let cleaned = text.trim();
        if (cleaned.startsWith("```")) {
            const firstNewline = cleaned.indexOf("\n");
            if (firstNewline !== -1)
                cleaned = cleaned.substring(firstNewline + 1);
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
    }
    catch (e) {
        if (e instanceof https_1.HttpsError)
            throw e;
        const message = e instanceof Error ? e.message : "Unknown error";
        throw new https_1.HttpsError("internal", `Failed to parse transcript: ${message}`);
    }
});
//# sourceMappingURL=index.js.map