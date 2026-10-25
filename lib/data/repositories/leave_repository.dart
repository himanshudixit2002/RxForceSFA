import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../converters/firestore_converters.dart';
import '../models/database.dart';
import 'base_repository.dart';

class LeaveRepository extends BaseRepository {
  LeaveRepository(super.db);

  Stream<List<LeaveRequest>> watchForMr(String mrId) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('leaveRequests')
          .where('mrId', isEqualTo: mrId)
          .orderBy('startDate', descending: true)
          .snapshots()
          .map((s) => s.docs.map(leaveRequestFromFirestore).toList());
    }
    return (db.select(db.leaveRequests)
          ..where((t) => t.mrId.equals(mrId))
          ..orderBy([(t) => OrderingTerm.desc(t.startDate)]))
        .watch();
  }

  Stream<List<LeaveBalance>> watchBalances(String mrId) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('leaveBalances')
          .where('mrId', isEqualTo: mrId)
          .snapshots()
          .map((s) => s.docs.map(leaveBalanceFromFirestore).toList());
    }
    return (db.select(db.leaveBalances)
          ..where((t) => t.mrId.equals(mrId)))
        .watch();
  }

  Future<void> createRequest(LeaveRequestsCompanion req) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance
          .collection('leaveRequests')
          .doc(req.id.value)
          .set({
        'id': req.id.value,
        'mrId': req.mrId.value,
        'leaveType': req.leaveType.value.index,
        'startDate': Timestamp.fromDate(req.startDate.value),
        'endDate': Timestamp.fromDate(req.endDate.value),
        'reason': req.reason.value,
        'status': ApprovalStatus.pending.index,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return;
    }
    await db.into(db.leaveRequests).insertOnConflictUpdate(req);
    await enqueueSync(
      collectionName: 'leaveRequests',
      documentId: req.id.value,
      opType: OperationType.create,
      payload: jsonEncode({
        'id': req.id.value,
        'mrId': req.mrId.value,
        'leaveType': req.leaveType.value.index,
        'startDate': req.startDate.value.toIso8601String(),
        'endDate': req.endDate.value.toIso8601String(),
        'reason': req.reason.value,
        'status': ApprovalStatus.pending.index,
      }),
    );
  }

  Future<void> updateRequestStatus(
      String id, ApprovalStatus status, String approvedBy, String comments) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance
          .collection('leaveRequests')
          .doc(id)
          .update({
        'status': status.index,
        'approvedBy': approvedBy,
        'comments': comments,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return;
    }
    await (db.update(db.leaveRequests)..where((t) => t.id.equals(id))).write(
      LeaveRequestsCompanion(
        status: Value(status),
        approvedBy: Value(approvedBy),
        comments: Value(comments),
      ),
    );
  }

  Future<void> initBalances(String mrId, int year) async {
    if (kIsWeb) {
      for (final type in LeaveType.values) {
        final docId = '${mrId}_${type.name}_$year';
        final doc = await FirebaseFirestore.instance
            .collection('leaveBalances')
            .doc(docId)
            .get();
        if (!doc.exists) {
          final total = _defaultBalance(type);
          await FirebaseFirestore.instance
              .collection('leaveBalances')
              .doc(docId)
              .set({
            'id': docId,
            'mrId': mrId,
            'leaveType': type.index,
            'year': year,
            'total': total,
            'used': 0,
            'remaining': total,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      }
      return;
    }
    for (final type in LeaveType.values) {
      final existing = await (db.select(db.leaveBalances)
            ..where((t) =>
                t.mrId.equals(mrId) &
                t.leaveType.equals(type.index) &
                t.year.equals(year)))
          .getSingleOrNull();
      if (existing == null) {
        final total = _defaultBalance(type);
        await db.into(db.leaveBalances).insert(
              LeaveBalancesCompanion.insert(
                id: '${mrId}_${type.name}_$year',
                mrId: mrId,
                leaveType: type,
                year: year,
                total: Value(total),
                remaining: Value(total),
              ),
            );
      }
    }
  }

  int _defaultBalance(LeaveType type) {
    switch (type) {
      case LeaveType.casual:
        return 12;
      case LeaveType.sick:
        return 10;
      case LeaveType.earned:
        return 15;
      case LeaveType.compOff:
        return 5;
    }
  }
}
