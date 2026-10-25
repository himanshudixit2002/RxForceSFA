import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../converters/firestore_converters.dart';
import '../models/database.dart';
import 'base_repository.dart';

class TerritoryRepository extends BaseRepository {
  TerritoryRepository(super.db);

  Future<List<Territory>> getAllTerritories() {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('territories')
          .get()
          .then((s) => s.docs.map(territoryFromFirestore).toList());
    }
    return db.select(db.territories).get();
  }

  Stream<List<Territory>> watchAllTerritories() {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('territories')
          .snapshots()
          .map((s) => s.docs.map(territoryFromFirestore).toList());
    }
    return db.select(db.territories).watch();
  }

  Future<Territory?> getTerritoryById(String id) async {
    if (kIsWeb) {
      final doc = await FirebaseFirestore.instance
          .collection('territories')
          .doc(id)
          .get();
      if (!doc.exists) return null;
      return territoryFromFirestore(doc);
    }
    return (db.select(db.territories)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<Territory>> getChildTerritories(String parentId) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('territories')
          .where('parentId', isEqualTo: parentId)
          .get()
          .then((s) => s.docs.map(territoryFromFirestore).toList());
    }
    return (db.select(db.territories)
          ..where((t) => t.parentId.equals(parentId)))
        .get();
  }

  Future<void> upsertTerritory(TerritoriesCompanion t) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance
          .collection('territories')
          .doc(t.id.value)
          .set({
        'id': t.id.value,
        'name': t.name.value,
        'parentId': t.parentId.value,
        'level': t.level.value,
        'boundaries': t.boundaries.value,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return;
    }
    await db.into(db.territories).insertOnConflictUpdate(t);
    await enqueueSync(
      collectionName: 'territories',
      documentId: t.id.value,
      opType: OperationType.update,
      payload: jsonEncode({
        'id': t.id.value,
        'name': t.name.value,
        'parentId': t.parentId.value,
        'level': t.level.value,
        'boundaries': t.boundaries.value,
      }),
    );
  }

  Future<void> deleteTerritory(String id) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance
          .collection('territories')
          .doc(id)
          .delete();
      return;
    }
    await (db.delete(db.territories)..where((t) => t.id.equals(id))).go();
    await enqueueSync(
      collectionName: 'territories',
      documentId: id,
      opType: OperationType.delete,
      payload: jsonEncode({'id': id}),
    );
  }

  Future<void> insertLocalOnly(TerritoriesCompanion t) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance
          .collection('territories')
          .doc(t.id.value)
          .set({
        'id': t.id.value,
        'name': t.name.value,
        'parentId': t.parentId.value,
        'level': t.level.value,
        'boundaries': t.boundaries.value,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return;
    }
    await db.into(db.territories).insertOnConflictUpdate(t);
  }
}
