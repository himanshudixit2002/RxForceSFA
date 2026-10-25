import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../converters/firestore_converters.dart';
import '../models/database.dart';
import 'base_repository.dart';

class TargetRepository extends BaseRepository {
  TargetRepository(super.db);

  Stream<List<Target>> watchForMr(String mrId) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('targets')
          .where('mrId', isEqualTo: mrId)
          .snapshots()
          .map((s) => s.docs.map(targetFromFirestore).toList());
    }
    return (db.select(db.targets)
          ..where((t) => t.mrId.equals(mrId)))
        .watch();
  }

  Stream<List<Target>> watchAll() {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('targets')
          .snapshots()
          .map((s) => s.docs.map(targetFromFirestore).toList());
    }
    return db.select(db.targets).watch();
  }

  Future<void> upsert(TargetsCompanion t) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance.collection('targets').doc(t.id.value).set({
        'id': t.id.value,
        'mrId': t.mrId.value,
        'productId': t.productId.value,
        'targetType': t.targetType.value.index,
        'targetValue': t.targetValue.value,
        'achievedValue': t.achievedValue.value,
        'period': t.period.value,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return;
    }
    await db.into(db.targets).insertOnConflictUpdate(t);
  }

  Future<void> updateAchievement(String id, double achieved) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance.collection('targets').doc(id).update({
        'achievedValue': achieved,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return;
    }
    await (db.update(db.targets)..where((t) => t.id.equals(id))).write(
      TargetsCompanion(achievedValue: Value(achieved)),
    );
  }
}
