import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../converters/firestore_converters.dart';
import '../models/database.dart';
import 'base_repository.dart';

class CampaignRepository extends BaseRepository {
  CampaignRepository(super.db);

  Stream<List<Campaign>> watchAll() {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('campaigns')
          .orderBy('startDate', descending: true)
          .snapshots()
          .map((s) => s.docs.map(campaignFromFirestore).toList());
    }
    return (db.select(db.campaigns)
          ..orderBy([(t) => OrderingTerm.desc(t.startDate)]))
        .watch();
  }

  Stream<List<Campaign>> watchActive() {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('campaigns')
          .where('status', isEqualTo: 'active')
          .orderBy('startDate', descending: true)
          .snapshots()
          .map((s) => s.docs.map(campaignFromFirestore).toList());
    }
    return (db.select(db.campaigns)
          ..where((t) => t.status.equals('active'))
          ..orderBy([(t) => OrderingTerm.desc(t.startDate)]))
        .watch();
  }

  Future<Campaign?> getById(String id) async {
    if (kIsWeb) {
      final doc = await FirebaseFirestore.instance.collection('campaigns').doc(id).get();
      if (!doc.exists) return null;
      return campaignFromFirestore(doc);
    }
    return (db.select(db.campaigns)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> upsert(CampaignsCompanion c) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance.collection('campaigns').doc(c.id.value).set({
        'id': c.id.value,
        'name': c.name.value,
        'startDate': Timestamp.fromDate(c.startDate.value),
        'endDate': Timestamp.fromDate(c.endDate.value),
        'description': c.description.value,
        'targetDoctors': c.targetDoctors.value,
        'status': c.status.value,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return;
    }
    await db.into(db.campaigns).insertOnConflictUpdate(c);
    await enqueueSync(
      collectionName: 'campaigns',
      documentId: c.id.value,
      opType: OperationType.update,
      payload: jsonEncode({
        'id': c.id.value,
        'name': c.name.value,
        'startDate': c.startDate.value.toIso8601String(),
        'endDate': c.endDate.value.toIso8601String(),
        'description': c.description.value,
        'targetDoctors': c.targetDoctors.value,
        'status': c.status.value,
      }),
    );
  }
}
