import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../core/constants/app_constants.dart';
import '../converters/firestore_converters.dart';
import '../models/database.dart';
import 'base_repository.dart';

class DoctorRepository extends BaseRepository {
  DoctorRepository(super.db);

  Stream<List<Doctor>> watchAll() {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('doctors')
          .snapshots()
          .map((s) => s.docs.map(doctorFromFirestore).toList());
    }
    return db.select(db.doctors).watch();
  }

  Future<List<Doctor>> getAll() {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('doctors')
          .get()
          .then((s) => s.docs.map(doctorFromFirestore).toList());
    }
    return db.select(db.doctors).get();
  }

  Future<List<Doctor>> getAllDoctors() => getAll();

  Future<Doctor?> getById(String id) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('doctors')
          .doc(id)
          .get()
          .then((d) => d.exists ? doctorFromFirestore(d) : null);
    }
    return (db.select(
      db.doctors,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Stream<List<Doctor>> watchByTerritory(String territory) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('doctors')
          .where('territory', isEqualTo: territory)
          .snapshots()
          .map((s) => s.docs.map(doctorFromFirestore).toList());
    }
    return (db.select(db.doctors)
          ..where((t) => t.territory.equals(territory))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<void> upsert(Doctor doctor) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(doctor.id)
          .set(doctorToFirestore(doctor), SetOptions(merge: true));
      return;
    }

    final existing = await getById(doctor.id);
    final opType =
        existing == null ? OperationType.create : OperationType.update;

    await db
        .into(db.doctors)
        .insertOnConflictUpdate(
          DoctorsCompanion.insert(
            id: doctor.id,
            name: doctor.name,
            specialization: Value(doctor.specialization),
            clinicAddress: Value(doctor.clinicAddress),
            phone: Value(doctor.phone),
            territory: Value(doctor.territory),
            lastVisitDate: Value(doctor.lastVisitDate),
            visitFrequency: Value(doctor.visitFrequency),
            conversionProbability: Value(doctor.conversionProbability),
            latitude: Value(doctor.latitude),
            longitude: Value(doctor.longitude),
          ),
        );

    await enqueueSync(
      collectionName: AppConstants.firestoreDoctors,
      documentId: doctor.id,
      opType: opType,
      payload: jsonEncode({
        'name': doctor.name,
        'specialization': doctor.specialization,
        'clinicAddress': doctor.clinicAddress,
        'phone': doctor.phone,
        'territory': doctor.territory,
        'lastVisitDate': doctor.lastVisitDate?.toIso8601String(),
        'visitFrequency': doctor.visitFrequency,
        'conversionProbability': doctor.conversionProbability,
        'latitude': doctor.latitude,
        'longitude': doctor.longitude,
      }),
    );
  }
}
