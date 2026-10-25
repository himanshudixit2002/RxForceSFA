import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../converters/firestore_converters.dart';
import '../models/database.dart';
import 'base_repository.dart';

class SampleRepository extends BaseRepository {
  SampleRepository(super.db);

  Stream<List<Sample>> watchForMr(String mrId) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('samples')
          .where('mrId', isEqualTo: mrId)
          .orderBy('date', descending: true)
          .snapshots()
          .map((s) => s.docs.map(sampleFromFirestore).toList());
    }
    return (db.select(db.samples)
          ..where((t) => t.mrId.equals(mrId))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  Stream<List<Sample>> watchForDoctor(String doctorId) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('samples')
          .where('doctorId', isEqualTo: doctorId)
          .orderBy('date', descending: true)
          .snapshots()
          .map((s) => s.docs.map(sampleFromFirestore).toList());
    }
    return (db.select(db.samples)
          ..where((t) => t.doctorId.equals(doctorId))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  Future<void> distribute(SamplesCompanion s) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance
          .collection('samples')
          .doc(s.id.value)
          .set({
        'id': s.id.value,
        'productId': s.productId.value,
        'mrId': s.mrId.value,
        'doctorId': s.doctorId.value,
        'quantity': s.quantity.value,
        'date': Timestamp.fromDate(s.date.value),
        'batchNo': s.batchNo.value,
        'type': s.type.value,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return;
    }
    await db.into(db.samples).insertOnConflictUpdate(s);
    await enqueueSync(
      collectionName: 'samples',
      documentId: s.id.value,
      opType: OperationType.create,
      payload: jsonEncode({
        'id': s.id.value,
        'productId': s.productId.value,
        'mrId': s.mrId.value,
        'doctorId': s.doctorId.value,
        'quantity': s.quantity.value,
        'date': s.date.value.toIso8601String(),
        'batchNo': s.batchNo.value,
        'type': s.type.value,
      }),
    );
  }

  Stream<List<StockLedger>> watchStock(String mrId) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('stockLedgers')
          .where('mrId', isEqualTo: mrId)
          .orderBy('date', descending: true)
          .snapshots()
          .map((s) => s.docs.map(stockLedgerFromFirestore).toList());
    }
    return (db.select(db.stockLedgers)
          ..where((t) => t.mrId.equals(mrId))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  Future<void> updateStock(StockLedgersCompanion s) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance
          .collection('stockLedgers')
          .doc(s.id.value)
          .set({
        'id': s.id.value,
        'productId': s.productId.value,
        'mrId': s.mrId.value,
        'openingStock': s.openingStock.value,
        'received': s.received.value,
        'distributed': s.distributed.value,
        'closingStock': s.closingStock.value,
        'date': Timestamp.fromDate(s.date.value),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return;
    }
    await db.into(db.stockLedgers).insertOnConflictUpdate(s);
  }
}
