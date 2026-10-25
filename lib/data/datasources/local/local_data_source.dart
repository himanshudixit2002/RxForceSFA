import 'package:drift/drift.dart';

import '../../models/database.dart';

/// Typed wrapper around the local Drift database.
/// All local DB operations go through this abstraction.
class LocalDataSource {
  final AppDatabase _db;

  const LocalDataSource(this._db);

  AppDatabase get database => _db;

  // ─── Doctors ──────────────────────────────────────────────

  Stream<List<Doctor>> watchDoctors() => _db.select(_db.doctors).watch();

  Future<List<Doctor>> getAllDoctors() => _db.select(_db.doctors).get();

  Future<Doctor?> getDoctorById(String id) =>
      (_db.select(_db.doctors)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsertDoctor(DoctorsCompanion companion) =>
      _db.into(_db.doctors).insertOnConflictUpdate(companion);

  // ─── DCRs ──────────────────────────────────────────────

  Stream<List<Dcr>> watchDcrs() => _db.select(_db.dcrs).watch();

  Future<List<Dcr>> getAllDcrs() => _db.select(_db.dcrs).get();

  Future<Dcr?> getDcrById(String id) =>
      (_db.select(_db.dcrs)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> upsertDcr(DcrsCompanion companion) =>
      _db.into(_db.dcrs).insertOnConflictUpdate(companion);

  // ─── Expenses ──────────────────────────────────────────

  Stream<List<Expense>> watchExpenses() => _db.select(_db.expenses).watch();

  Future<List<Expense>> getAllExpenses() => _db.select(_db.expenses).get();

  Future<Expense?> getExpenseById(String id) =>
      (_db.select(_db.expenses)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsertExpense(ExpensesCompanion companion) =>
      _db.into(_db.expenses).insertOnConflictUpdate(companion);

  // ─── Visits ──────────────────────────────────────────

  Stream<List<Visit>> watchVisits() => _db.select(_db.visits).watch();

  Future<List<Visit>> getAllVisits() => _db.select(_db.visits).get();

  Future<Visit?> getVisitById(String id) =>
      (_db.select(_db.visits)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsertVisit(VisitsCompanion companion) =>
      _db.into(_db.visits).insertOnConflictUpdate(companion);

  // ─── Sync Queue ──────────────────────────────────────────

  Future<List<SyncQueueItem>> getPendingSyncItems() =>
      (_db.select(_db.syncQueueItems)
            ..where((t) => t.isSynced.equals(false))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  Future<void> markSynced(int id) =>
      (_db.update(_db.syncQueueItems)..where((t) => t.id.equals(id)))
          .write(const SyncQueueItemsCompanion(isSynced: Value(true)));
}
