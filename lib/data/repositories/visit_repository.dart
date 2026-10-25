import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../core/constants/app_constants.dart';
import '../converters/firestore_converters.dart';
import '../models/database.dart';
import 'base_repository.dart';

class VisitRepository extends BaseRepository {
  VisitRepository(super.db);

  Stream<List<Visit>> watchAll() {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('visits')
          .snapshots()
          .map((s) => s.docs.map(visitFromFirestore).toList());
    }
    return db.select(db.visits).watch();
  }

  Future<List<Visit>> getAll() {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('visits')
          .get()
          .then((s) => s.docs.map(visitFromFirestore).toList());
    }
    return db.select(db.visits).get();
  }

  Future<Visit?> getById(String id) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('visits')
          .doc(id)
          .get()
          .then((d) => d.exists ? visitFromFirestore(d) : null);
    }
    return (db.select(
      db.visits,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Stream<List<Visit>> watchTodayVisits(String mrId) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('visits')
          .where('mrId', isEqualTo: mrId)
          .where('visitDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .orderBy('visitDate')
          .snapshots()
          .map((s) => s.docs.map(visitFromFirestore).toList());
    }

    final endOfDay = startOfDay.add(const Duration(days: 1));
    return (db.select(db.visits)
          ..where(
            (t) =>
                t.mrId.equals(mrId) &
                t.visitDate.isBiggerOrEqualValue(startOfDay) &
                t.visitDate.isSmallerThanValue(endOfDay),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.visitDate)]))
        .watch();
  }

  Future<List<Visit>> getTodayVisits(String mrId) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('visits')
          .where('mrId', isEqualTo: mrId)
          .where('visitDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .orderBy('visitDate')
          .get()
          .then((s) => s.docs.map(visitFromFirestore).toList());
    }

    final endOfDay = startOfDay.add(const Duration(days: 1));
    return (db.select(db.visits)
          ..where(
            (t) =>
                t.mrId.equals(mrId) &
                t.visitDate.isBiggerOrEqualValue(startOfDay) &
                t.visitDate.isSmallerThanValue(endOfDay),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.visitDate)]))
        .get();
  }

  Future<void> save(Visit visit) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance
          .collection('visits')
          .doc(visit.id)
          .set(visitToFirestore(visit), SetOptions(merge: true));
      return;
    }

    final existing = await getById(visit.id);
    final opType =
        existing == null ? OperationType.create : OperationType.update;

    final companion = VisitsCompanion.insert(
      id: visit.id,
      doctorId: visit.doctorId,
      mrId: visit.mrId,
      visitDate: visit.visitDate,
      notes: Value(visit.notes),
      outcome: Value(visit.outcome),
      isCompleted: Value(visit.isCompleted),
    );

    await db.into(db.visits).insertOnConflictUpdate(companion);

    await enqueueSync(
      collectionName: AppConstants.firestoreVisits,
      documentId: visit.id,
      opType: opType,
      payload: jsonEncode({
        'id': visit.id,
        'doctorId': visit.doctorId,
        'mrId': visit.mrId,
        'visitDate': visit.visitDate.toIso8601String(),
        'notes': visit.notes,
        'outcome': visit.outcome,
        'isCompleted': visit.isCompleted,
      }),
    );
  }

  Future<void> markCompleted(String id, String outcome) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance.collection('visits').doc(id).update({
        'isCompleted': true,
        'outcome': outcome,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return;
    }

    await (db.update(db.visits)..where((t) => t.id.equals(id))).write(
      VisitsCompanion(isCompleted: const Value(true), outcome: Value(outcome)),
    );

    await enqueueSync(
      collectionName: AppConstants.firestoreVisits,
      documentId: id,
      opType: OperationType.update,
      payload: jsonEncode({'isCompleted': true, 'outcome': outcome}),
    );
  }

  Future<void> remove(String id) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance.collection('visits').doc(id).delete();
      return;
    }

    await (db.delete(db.visits)..where((t) => t.id.equals(id))).go();
    await enqueueSync(
      collectionName: AppConstants.firestoreVisits,
      documentId: id,
      opType: OperationType.delete,
      payload: '{}',
    );
  }
}
