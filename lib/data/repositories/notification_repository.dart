import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../converters/firestore_converters.dart';
import '../models/database.dart';
import 'base_repository.dart';

class NotificationRepository extends BaseRepository {
  NotificationRepository(super.db);

  Stream<List<Notification>> watchForUser(String userId) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((s) => s.docs.map(notificationFromFirestore).toList());
    }
    return (db.select(db.notifications)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Stream<int> watchUnreadCount(String userId) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .snapshots()
          .map((s) => s.docs.length);
    }
    final count = countAll();
    final query = db.selectOnly(db.notifications)
      ..addColumns([count])
      ..where(db.notifications.userId.equals(userId) &
          db.notifications.isRead.equals(false));
    return query.watchSingle().map((row) => row.read(count) ?? 0);
  }

  Future<void> markRead(String id) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance.collection('notifications').doc(id).update({
        'isRead': true,
      });
      return;
    }
    await (db.update(db.notifications)..where((t) => t.id.equals(id)))
        .write(const NotificationsCompanion(isRead: Value(true)));
  }

  Future<void> markAllRead(String userId) async {
    if (kIsWeb) {
      final snap = await FirebaseFirestore.instance
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();
      final batch = FirebaseFirestore.instance.batch();
      for (final doc in snap.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
      return;
    }
    await (db.update(db.notifications)
          ..where(
              (t) => t.userId.equals(userId) & t.isRead.equals(false)))
        .write(const NotificationsCompanion(isRead: Value(true)));
  }

  Future<void> insert(NotificationsCompanion n) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance.collection('notifications').doc(n.id.value).set({
        'id': n.id.value,
        'userId': n.userId.value,
        'title': n.title.value,
        'body': n.body.value,
        'type': n.type.value.index,
        'referenceId': n.referenceId.value,
        'isRead': n.isRead.value,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return;
    }
    await db.into(db.notifications).insertOnConflictUpdate(n);
  }
}
