import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../core/constants/app_constants.dart';
import '../converters/firestore_converters.dart';
import '../models/database.dart';
import 'base_repository.dart';

class DcrRepository extends BaseRepository {
  DcrRepository(super.db);

  Stream<List<Dcr>> watchAll() {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('dcrs')
          .snapshots()
          .map((s) => s.docs.map(dcrFromFirestore).toList());
    }
    return db.select(db.dcrs).watch();
  }

  Future<List<Dcr>> getAll() {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('dcrs')
          .get()
          .then((s) => s.docs.map(dcrFromFirestore).toList());
    }
    return db.select(db.dcrs).get();
  }

  Future<Dcr?> getById(String id) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('dcrs')
          .doc(id)
          .get()
          .then((d) => d.exists ? dcrFromFirestore(d) : null);
    }
    return (db.select(
      db.dcrs,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Stream<List<Dcr>> watchByMr(String mrId) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('dcrs')
          .where('mrId', isEqualTo: mrId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((s) => s.docs.map(dcrFromFirestore).toList());
    }
    return (db.select(db.dcrs)
          ..where((t) => t.mrId.equals(mrId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<void> save(Dcr dcr) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance
          .collection('dcrs')
          .doc(dcr.id)
          .set(dcrToFirestore(dcr), SetOptions(merge: true));
      return;
    }

    final existing = await getById(dcr.id);
    final opType =
        existing == null ? OperationType.create : OperationType.update;

    final companion = DcrsCompanion.insert(
      id: dcr.id,
      doctorName: dcr.doctorName,
      doctorId: Value(dcr.doctorId),
      productsDiscussed: Value(dcr.productsDiscussed),
      productsDetailed: Value(dcr.productsDetailed),
      samplesGiven: Value(dcr.samplesGiven),
      giftsGiven: Value(dcr.giftsGiven),
      followUpDate: Value(dcr.followUpDate),
      notes: Value(dcr.notes),
      callDuration: Value(dcr.callDuration),
      geoLat: Value(dcr.geoLat),
      geoLng: Value(dcr.geoLng),
      mrId: dcr.mrId,
    );

    await db.into(db.dcrs).insertOnConflictUpdate(companion);

    await enqueueSync(
      collectionName: AppConstants.firestoreDcrs,
      documentId: dcr.id,
      opType: opType,
      payload: jsonEncode(dcrToFirestore(dcr)),
    );
  }

  Future<void> remove(String id) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance.collection('dcrs').doc(id).delete();
      return;
    }

    await (db.delete(db.dcrs)..where((t) => t.id.equals(id))).go();
    await enqueueSync(
      collectionName: AppConstants.firestoreDcrs,
      documentId: id,
      opType: OperationType.delete,
      payload: '{}',
    );
  }
}
