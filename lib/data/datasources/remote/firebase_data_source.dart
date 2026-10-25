import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/app_constants.dart';

/// Wrapper around Firestore for remote CRUD operations.
/// Provides clean abstraction so the backend can be swapped.
class FirebaseDataSource {
  final FirebaseFirestore _firestore;

  FirebaseDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // ─── Doctors ──────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> get _doctors =>
      _firestore.collection(AppConstants.firestoreDoctors);

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getDoctors({
    DateTime? since,
    int? limit,
  }) async {
    Query<Map<String, dynamic>> query = _doctors;
    if (since != null) {
      query = query.where('updatedAt', isGreaterThan: Timestamp.fromDate(since));
    }
    if (limit != null) query = query.limit(limit);
    final snap = await query.get();
    return snap.docs;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDoctor(String id) =>
      _doctors.doc(id).get();

  Future<void> setDoctor(String id, Map<String, dynamic> data) =>
      _doctors.doc(id).set(data, SetOptions(merge: true));

  // ─── DCRs ──────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> get _dcrs =>
      _firestore.collection(AppConstants.firestoreDcrs);

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getDcrs({
    String? mrId,
    DateTime? since,
  }) async {
    Query<Map<String, dynamic>> query = _dcrs;
    if (mrId != null) query = query.where('mrId', isEqualTo: mrId);
    if (since != null) {
      query = query.where('updatedAt', isGreaterThan: Timestamp.fromDate(since));
    }
    final snap = await query.get();
    return snap.docs;
  }

  Future<void> setDcr(String id, Map<String, dynamic> data) =>
      _dcrs.doc(id).set(data, SetOptions(merge: true));

  Future<void> updateDcr(String id, Map<String, dynamic> data) =>
      _dcrs.doc(id).update(data);

  Future<void> deleteDcr(String id) => _dcrs.doc(id).delete();

  // ─── Expenses ──────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> get _expenses =>
      _firestore.collection(AppConstants.firestoreExpenses);

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getExpenses({
    String? mrId,
    DateTime? since,
  }) async {
    Query<Map<String, dynamic>> query = _expenses;
    if (mrId != null) query = query.where('mrId', isEqualTo: mrId);
    if (since != null) {
      query = query.where('updatedAt', isGreaterThan: Timestamp.fromDate(since));
    }
    final snap = await query.get();
    return snap.docs;
  }

  Future<void> setExpense(String id, Map<String, dynamic> data) =>
      _expenses.doc(id).set(data, SetOptions(merge: true));

  Future<void> updateExpense(String id, Map<String, dynamic> data) =>
      _expenses.doc(id).update(data);

  Future<void> deleteExpense(String id) => _expenses.doc(id).delete();

  // ─── Visits ──────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> get _visits =>
      _firestore.collection(AppConstants.firestoreVisits);

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getVisits({
    String? mrId,
    DateTime? since,
  }) async {
    Query<Map<String, dynamic>> query = _visits;
    if (mrId != null) query = query.where('mrId', isEqualTo: mrId);
    if (since != null) {
      query = query.where('updatedAt', isGreaterThan: Timestamp.fromDate(since));
    }
    final snap = await query.get();
    return snap.docs;
  }

  Future<void> setVisit(String id, Map<String, dynamic> data) =>
      _visits.doc(id).set(data, SetOptions(merge: true));

  Future<void> updateVisit(String id, Map<String, dynamic> data) =>
      _visits.doc(id).update(data);

  Future<void> deleteVisit(String id) => _visits.doc(id).delete();

  // ─── Generic Push ──────────────────────────────────────────

  Future<void> pushDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) =>
      _firestore
          .collection(collection)
          .doc(docId)
          .set(data, SetOptions(merge: true));

  Future<void> deleteDocument({
    required String collection,
    required String docId,
  }) =>
      _firestore.collection(collection).doc(docId).delete();
}
