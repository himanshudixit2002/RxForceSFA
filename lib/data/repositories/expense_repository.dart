import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../core/constants/app_constants.dart';
import '../converters/firestore_converters.dart';
import '../models/database.dart';
import 'base_repository.dart';

class ExpenseRepository extends BaseRepository {
  ExpenseRepository(super.db);

  Stream<List<Expense>> watchAll() {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('expenses')
          .snapshots()
          .map((s) => s.docs.map(expenseFromFirestore).toList());
    }
    return db.select(db.expenses).watch();
  }

  Future<List<Expense>> getAll() {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('expenses')
          .get()
          .then((s) => s.docs.map(expenseFromFirestore).toList());
    }
    return db.select(db.expenses).get();
  }

  Future<Expense?> getById(String id) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('expenses')
          .doc(id)
          .get()
          .then((d) => d.exists ? expenseFromFirestore(d) : null);
    }
    return (db.select(
      db.expenses,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Stream<List<Expense>> watchByMr(String mrId) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('expenses')
          .where('mrId', isEqualTo: mrId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((s) => s.docs.map(expenseFromFirestore).toList());
    }
    return (db.select(db.expenses)
          ..where((t) => t.mrId.equals(mrId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<void> save(Expense expense) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance
          .collection('expenses')
          .doc(expense.id)
          .set(expenseToFirestore(expense), SetOptions(merge: true));
      return;
    }

    final existing = await getById(expense.id);
    final opType =
        existing == null ? OperationType.create : OperationType.update;

    final companion = ExpensesCompanion.insert(
      id: expense.id,
      amount: expense.amount,
      date: expense.date,
      category: expense.category,
      receiptImagePath: Value(expense.receiptImagePath),
      isApproved: Value(expense.isApproved),
      warningFlag: Value(expense.warningFlag),
      mrId: expense.mrId,
    );

    await db.into(db.expenses).insertOnConflictUpdate(companion);

    await enqueueSync(
      collectionName: AppConstants.firestoreExpenses,
      documentId: expense.id,
      opType: opType,
      payload: jsonEncode({
        'id': expense.id,
        'amount': expense.amount,
        'date': expense.date.toIso8601String(),
        'category': expense.category.index,
        'receiptImagePath': expense.receiptImagePath,
        'isApproved': expense.isApproved,
        'warningFlag': expense.warningFlag,
        'createdAt': expense.createdAt.toIso8601String(),
        'mrId': expense.mrId,
      }),
    );
  }

  Future<void> remove(String id) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance.collection('expenses').doc(id).delete();
      return;
    }

    await (db.delete(db.expenses)..where((t) => t.id.equals(id))).go();
    await enqueueSync(
      collectionName: AppConstants.firestoreExpenses,
      documentId: id,
      opType: OperationType.delete,
      payload: '{}',
    );
  }
}
