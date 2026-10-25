import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:uuid/uuid.dart';

import '../converters/firestore_converters.dart';
import '../models/database.dart';
import 'base_repository.dart';

class ActivityLogRepository extends BaseRepository {
  ActivityLogRepository(super.db);

  Future<void> log({
    required String userId,
    required String action,
    required String entityType,
    String entityId = '',
    String details = '',
  }) async {
    if (kIsWeb) {
      final id = const Uuid().v4();
      await FirebaseFirestore.instance.collection('activityLogs').doc(id).set({
        'id': id,
        'userId': userId,
        'action': action,
        'entityType': entityType,
        'entityId': entityId,
        'details': details,
        'timestamp': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return;
    }
    await db.into(db.activityLogs).insert(
          ActivityLogsCompanion.insert(
            id: const Uuid().v4(),
            userId: userId,
            action: action,
            entityType: entityType,
            entityId: Value(entityId),
            details: Value(details),
          ),
        );
  }

  Stream<List<ActivityLog>> watchRecent({int limit = 50}) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('activityLogs')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .snapshots()
          .map((s) => s.docs.map(activityLogFromFirestore).toList());
    }
    return (db.select(db.activityLogs)
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
          ..limit(limit))
        .watch();
  }

  Future<List<ActivityLog>> getForEntity(String entityType, String entityId) async {
    if (kIsWeb) {
      final snap = await FirebaseFirestore.instance
          .collection('activityLogs')
          .where('entityType', isEqualTo: entityType)
          .where('entityId', isEqualTo: entityId)
          .orderBy('timestamp', descending: true)
          .get();
      return snap.docs.map(activityLogFromFirestore).toList();
    }
    return (db.select(db.activityLogs)
          ..where((t) =>
              t.entityType.equals(entityType) &
              t.entityId.equals(entityId))
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .get();
  }
}
