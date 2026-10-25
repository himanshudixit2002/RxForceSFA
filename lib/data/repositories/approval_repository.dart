import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../converters/firestore_converters.dart';
import '../models/database.dart';
import 'base_repository.dart';

class ApprovalRepository extends BaseRepository {
  ApprovalRepository(super.db);

  Stream<List<Approval>> watchPendingForApprover(String approverId) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('approvals')
          .where('approverId', isEqualTo: approverId)
          .where('status', isEqualTo: ApprovalStatus.pending.index)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((s) => s.docs.map(approvalFromFirestore).toList());
    }
    return (db.select(db.approvals)
          ..where((t) =>
              t.approverId.equals(approverId) &
              t.status.equals(ApprovalStatus.pending.index))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Stream<List<Approval>> watchForRequester(String requesterId) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('approvals')
          .where('requesterId', isEqualTo: requesterId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((s) => s.docs.map(approvalFromFirestore).toList());
    }
    return (db.select(db.approvals)
          ..where((t) => t.requesterId.equals(requesterId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<Approval?> getById(String id) async {
    if (kIsWeb) {
      final doc = await FirebaseFirestore.instance
          .collection('approvals')
          .doc(id)
          .get();
      return doc.exists ? approvalFromFirestore(doc) : null;
    }
    return (db.select(db.approvals)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> createApproval(ApprovalsCompanion a) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance.collection('approvals').doc(a.id.value).set({
        'id': a.id.value,
        'type': a.type.value.index,
        'referenceId': a.referenceId.value,
        'requesterId': a.requesterId.value,
        'approverId': a.approverId.value,
        'status': a.status.value.index,
        'comments': a.comments.value,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return;
    }
    await db.into(db.approvals).insertOnConflictUpdate(a);
    await enqueueSync(
      collectionName: 'approvals',
      documentId: a.id.value,
      opType: OperationType.create,
      payload: jsonEncode({
        'id': a.id.value,
        'type': a.type.value.index,
        'referenceId': a.referenceId.value,
        'requesterId': a.requesterId.value,
        'approverId': a.approverId.value,
        'status': a.status.value.index,
        'comments': a.comments.value,
      }),
    );
  }

  Future<void> updateStatus(
      String id, ApprovalStatus status, String comments) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance.collection('approvals').doc(id).update({
        'status': status.index,
        'comments': comments,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return;
    }
    await (db.update(db.approvals)..where((t) => t.id.equals(id))).write(
      ApprovalsCompanion(
        status: Value(status),
        comments: Value(comments),
      ),
    );
    await enqueueSync(
      collectionName: 'approvals',
      documentId: id,
      opType: OperationType.update,
      payload: jsonEncode({
        'id': id,
        'status': status.index,
        'comments': comments,
      }),
    );
  }

  Future<void> insertLocalOnly(ApprovalsCompanion a) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance.collection('approvals').doc(a.id.value).set({
        'id': a.id.value,
        'type': a.type.value.index,
        'referenceId': a.referenceId.value,
        'requesterId': a.requesterId.value,
        'approverId': a.approverId.value,
        'status': a.status.value.index,
        'comments': a.comments.value,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return;
    }
    await db.into(db.approvals).insertOnConflictUpdate(a);
  }
}
