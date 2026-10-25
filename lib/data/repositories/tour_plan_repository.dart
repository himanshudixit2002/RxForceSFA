import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../converters/firestore_converters.dart';
import '../models/database.dart';
import 'base_repository.dart';

class TourPlanRepository extends BaseRepository {
  TourPlanRepository(super.db);

  Stream<List<TourPlan>> watchPlansForMr(String mrId) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('tourPlans')
          .where('mrId', isEqualTo: mrId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((s) => s.docs.map(tourPlanFromFirestore).toList());
    }
    return (db.select(db.tourPlans)
          ..where((t) => t.mrId.equals(mrId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Stream<List<TourPlan>> watchPendingPlans() {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('tourPlans')
          .where('status', isEqualTo: 'submitted')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((s) => s.docs.map(tourPlanFromFirestore).toList());
    }
    return (db.select(db.tourPlans)
          ..where((t) => t.status.equals('submitted'))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<TourPlan?> getPlanById(String id) async {
    if (kIsWeb) {
      final doc = await FirebaseFirestore.instance
          .collection('tourPlans')
          .doc(id)
          .get();
      if (!doc.exists) return null;
      return tourPlanFromFirestore(doc);
    }
    return (db.select(db.tourPlans)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<TourPlanDay>> getDaysForPlan(String planId) async {
    if (kIsWeb) {
      final snap = await FirebaseFirestore.instance
          .collection('tourPlanDays')
          .where('tourPlanId', isEqualTo: planId)
          .orderBy('date')
          .get();
      return snap.docs.map(tourPlanDayFromFirestore).toList();
    }
    return (db.select(db.tourPlanDays)
          ..where((t) => t.tourPlanId.equals(planId))
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();
  }

  Stream<List<TourPlanDay>> watchDaysForPlan(String planId) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('tourPlanDays')
          .where('tourPlanId', isEqualTo: planId)
          .orderBy('date')
          .snapshots()
          .map((s) => s.docs.map(tourPlanDayFromFirestore).toList());
    }
    return (db.select(db.tourPlanDays)
          ..where((t) => t.tourPlanId.equals(planId))
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .watch();
  }

  Future<void> upsertPlan(TourPlansCompanion plan) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance
          .collection('tourPlans')
          .doc(plan.id.value)
          .set({
        'id': plan.id.value,
        'mrId': plan.mrId.value,
        'month': plan.month.value,
        'year': plan.year.value,
        'status': plan.status.value,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return;
    }
    await db.into(db.tourPlans).insertOnConflictUpdate(plan);
    await enqueueSync(
      collectionName: 'tourPlans',
      documentId: plan.id.value,
      opType: OperationType.update,
      payload: jsonEncode({
        'id': plan.id.value,
        'mrId': plan.mrId.value,
        'month': plan.month.value,
        'year': plan.year.value,
        'status': plan.status.value,
      }),
    );
  }

  Future<void> upsertPlanDay(TourPlanDaysCompanion day) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance
          .collection('tourPlanDays')
          .doc(day.id.value)
          .set({
        'id': day.id.value,
        'tourPlanId': day.tourPlanId.value,
        'date': Timestamp.fromDate(day.date.value),
        'doctorIds': day.doctorIds.value,
        'notes': day.notes.value,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return;
    }
    await db.into(db.tourPlanDays).insertOnConflictUpdate(day);
    await enqueueSync(
      collectionName: 'tourPlanDays',
      documentId: day.id.value,
      opType: OperationType.update,
      payload: jsonEncode({
        'id': day.id.value,
        'tourPlanId': day.tourPlanId.value,
        'date': day.date.value.toIso8601String(),
        'doctorIds': day.doctorIds.value,
        'notes': day.notes.value,
      }),
    );
  }

  Future<void> submitPlan(String planId) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance
          .collection('tourPlans')
          .doc(planId)
          .update({
        'status': 'submitted',
        'submittedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return;
    }
    await (db.update(db.tourPlans)..where((t) => t.id.equals(planId))).write(
      TourPlansCompanion(
        status: const Value('submitted'),
        submittedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> approvePlan(String planId, String approverId) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance
          .collection('tourPlans')
          .doc(planId)
          .update({
        'status': 'approved',
        'approvedBy': approverId,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return;
    }
    await (db.update(db.tourPlans)..where((t) => t.id.equals(planId))).write(
      TourPlansCompanion(
        status: const Value('approved'),
        approvedBy: Value(approverId),
      ),
    );
  }

  Future<void> rejectPlan(String planId) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance
          .collection('tourPlans')
          .doc(planId)
          .update({
        'status': 'rejected',
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return;
    }
    await (db.update(db.tourPlans)..where((t) => t.id.equals(planId))).write(
      const TourPlansCompanion(status: Value('rejected')),
    );
  }

  Future<void> deletePlan(String planId) async {
    if (kIsWeb) {
      final daySnap = await FirebaseFirestore.instance
          .collection('tourPlanDays')
          .where('tourPlanId', isEqualTo: planId)
          .get();
      for (final doc in daySnap.docs) {
        await doc.reference.delete();
      }
      await FirebaseFirestore.instance
          .collection('tourPlans')
          .doc(planId)
          .delete();
      return;
    }
    await (db.delete(db.tourPlanDays)
          ..where((t) => t.tourPlanId.equals(planId)))
        .go();
    await (db.delete(db.tourPlans)..where((t) => t.id.equals(planId))).go();
  }
}
