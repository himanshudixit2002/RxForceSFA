import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../converters/firestore_converters.dart';
import '../models/database.dart';
import 'base_repository.dart';

class ProductRepository extends BaseRepository {
  ProductRepository(super.db);

  Stream<List<Product>> watchAll() {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('products')
          .snapshots()
          .map((s) => s.docs.map(productFromFirestore).toList());
    }
    return db.select(db.products).watch();
  }

  Future<List<Product>> getAll() {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('products')
          .get()
          .then((s) => s.docs.map(productFromFirestore).toList());
    }
    return db.select(db.products).get();
  }

  Future<Product?> getById(String id) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('products')
          .doc(id)
          .get()
          .then((d) => d.exists ? productFromFirestore(d) : null);
    }
    return (db.select(db.products)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Stream<List<Product>> watchByCategory(String category) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('products')
          .where('category', isEqualTo: category)
          .where('isActive', isEqualTo: true)
          .snapshots()
          .map((s) => s.docs.map(productFromFirestore).toList());
    }
    return (db.select(db.products)
          ..where((t) => t.category.equals(category) & t.isActive.equals(true)))
        .watch();
  }

  Future<void> upsert(ProductsCompanion p) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance.collection('products').doc(p.id.value).set({
        'name': p.name.value,
        'sku': p.sku.value,
        'category': p.category.value,
        'division': p.division.value,
        'price': p.price.value,
        'description': p.description.value,
        'imageUrl': p.imageUrl.value,
        'isActive': p.isActive.value,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return;
    }

    final existing = await getById(p.id.value);
    final opType = existing == null ? OperationType.create : OperationType.update;

    await db.into(db.products).insertOnConflictUpdate(p);

    await enqueueSync(
      collectionName: 'products',
      documentId: p.id.value,
      opType: opType,
      payload: jsonEncode({
        'name': p.name.value,
        'sku': p.sku.value,
        'category': p.category.value,
        'division': p.division.value,
        'price': p.price.value,
        'description': p.description.value,
        'imageUrl': p.imageUrl.value,
        'isActive': p.isActive.value,
      }),
    );
  }

  Future<void> deleteProduct(String id) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance.collection('products').doc(id).delete();
      return;
    }
    await (db.delete(db.products)..where((t) => t.id.equals(id))).go();
    await enqueueSync(
      collectionName: 'products',
      documentId: id,
      opType: OperationType.delete,
      payload: '{}',
    );
  }
}
