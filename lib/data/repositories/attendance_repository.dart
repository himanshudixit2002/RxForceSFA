import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../converters/firestore_converters.dart';
import '../models/database.dart';
import 'base_repository.dart';

class AttendanceRepository extends BaseRepository {
  AttendanceRepository(super.db);

  Stream<List<Attendance>> watchForMr(String mrId) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('attendances')
          .where('mrId', isEqualTo: mrId)
          .orderBy('date', descending: true)
          .snapshots()
          .map((s) => s.docs.map(attendanceFromFirestore).toList());
    }
    return (db.select(db.attendances)
          ..where((t) => t.mrId.equals(mrId))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  Future<Attendance?> getTodayAttendance(String mrId) async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    if (kIsWeb) {
      final snap = await FirebaseFirestore.instance
          .collection('attendances')
          .where('mrId', isEqualTo: mrId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('date', isLessThan: Timestamp.fromDate(end))
          .get();
      if (snap.docs.isEmpty) return null;
      return attendanceFromFirestore(snap.docs.first);
    }
    return (db.select(db.attendances)
          ..where((t) =>
              t.mrId.equals(mrId) &
              t.date.isBiggerOrEqualValue(start) &
              t.date.isSmallerThanValue(end)))
        .getSingleOrNull();
  }

  Future<void> punchIn({
    required String id,
    required String mrId,
    required double lat,
    required double lng,
    required String selfie,
  }) async {
    if (kIsWeb) {
      final now = DateTime.now();
      await FirebaseFirestore.instance
          .collection('attendances')
          .doc(id)
          .set({
        'id': id,
        'mrId': mrId,
        'date': Timestamp.fromDate(DateTime(now.year, now.month, now.day)),
        'punchInTime': Timestamp.fromDate(now),
        'punchInLat': lat,
        'punchInLng': lng,
        'punchInSelfie': selfie,
        'status': AttendanceStatus.present.index,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return;
    }
    final now = DateTime.now();
    final companion = AttendancesCompanion(
      id: Value(id),
      mrId: Value(mrId),
      date: Value(DateTime(now.year, now.month, now.day)),
      punchInTime: Value(now),
      punchInLat: Value(lat),
      punchInLng: Value(lng),
      punchInSelfie: Value(selfie),
      status: const Value(AttendanceStatus.present),
    );
    await db.into(db.attendances).insertOnConflictUpdate(companion);
    await enqueueSync(
      collectionName: 'attendances',
      documentId: id,
      opType: OperationType.create,
      payload: jsonEncode({
        'id': id,
        'mrId': mrId,
        'date': now.toIso8601String(),
        'punchInTime': now.toIso8601String(),
        'punchInLat': lat,
        'punchInLng': lng,
        'punchInSelfie': selfie,
        'status': AttendanceStatus.present.index,
      }),
    );
  }

  Future<void> punchOut({
    required String id,
    required double lat,
    required double lng,
  }) async {
    if (kIsWeb) {
      final now = DateTime.now();
      await FirebaseFirestore.instance
          .collection('attendances')
          .doc(id)
          .update({
        'punchOutTime': Timestamp.fromDate(now),
        'punchOutLat': lat,
        'punchOutLng': lng,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return;
    }
    final now = DateTime.now();
    await (db.update(db.attendances)..where((t) => t.id.equals(id))).write(
      AttendancesCompanion(
        punchOutTime: Value(now),
        punchOutLat: Value(lat),
        punchOutLng: Value(lng),
      ),
    );
    await enqueueSync(
      collectionName: 'attendances',
      documentId: id,
      opType: OperationType.update,
      payload: jsonEncode({
        'id': id,
        'punchOutTime': now.toIso8601String(),
        'punchOutLat': lat,
        'punchOutLng': lng,
      }),
    );
  }

  Stream<List<Attendance>> watchTeamAttendance(List<String> mrIds) {
    if (kIsWeb) {
      if (mrIds.isEmpty) return Stream.value([]);
      return FirebaseFirestore.instance
          .collection('attendances')
          .where('mrId', whereIn: mrIds.take(30).toList())
          .orderBy('date', descending: true)
          .snapshots()
          .map((s) => s.docs.map(attendanceFromFirestore).toList());
    }
    return (db.select(db.attendances)
          ..where((t) => t.mrId.isIn(mrIds))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }
}
