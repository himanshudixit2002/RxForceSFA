import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../converters/firestore_converters.dart';
import '../models/database.dart';
import 'base_repository.dart';

class EDetailRepository extends BaseRepository {
  EDetailRepository(super.db);

  Stream<List<EDetailContent>> watchAll() {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('eDetailContents')
          .where('isActive', isEqualTo: true)
          .snapshots()
          .map((s) => s.docs.map(eDetailContentFromFirestore).toList());
    }
    return (db.select(db.eDetailContents)
          ..where((t) => t.isActive.equals(true)))
        .watch();
  }

  Future<EDetailContent?> getById(String id) async {
    if (kIsWeb) {
      final doc = await FirebaseFirestore.instance
          .collection('eDetailContents')
          .doc(id)
          .get();
      return doc.exists ? eDetailContentFromFirestore(doc) : null;
    }
    return (db.select(db.eDetailContents)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<EDetailContent>> getForProduct(String productId) async {
    if (kIsWeb) {
      final snap = await FirebaseFirestore.instance
          .collection('eDetailContents')
          .where('productId', isEqualTo: productId)
          .where('isActive', isEqualTo: true)
          .get();
      return snap.docs.map(eDetailContentFromFirestore).toList();
    }
    return (db.select(db.eDetailContents)
          ..where((t) => t.productId.equals(productId) & t.isActive.equals(true)))
        .get();
  }

  Future<void> upsert(EDetailContentsCompanion c) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance.collection('eDetailContents').doc(c.id.value).set({
        'id': c.id.value,
        'productId': c.productId.value,
        'title': c.title.value,
        'type': c.type.value,
        'url': c.url.value,
        'version': c.version.value,
        'isActive': c.isActive.value,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return;
    }
    await db.into(db.eDetailContents).insertOnConflictUpdate(c);
  }
}
