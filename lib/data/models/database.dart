import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

enum OperationType { create, update, delete }

enum ExpenseCategory { meal, travel, accommodation, other }

enum ApprovalStatus { pending, approved, rejected, escalated }

enum OrderStatus { draft, submitted, confirmed, dispatched, delivered, cancelled }

enum LeaveType { casual, sick, earned, compOff }

enum AttendanceStatus { present, absent, halfDay, leave, holiday }

enum ApprovalEntityType { expense, tourPlan, leave, order, sample }

enum NotificationType { approvalRequest, approvalResult, reminder, alert, system }

enum TargetType { monthly, quarterly }

// ─── Existing tables ────────────────────────────────────

class SyncQueueItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get collectionName => text()();
  TextColumn get documentId => text()();
  IntColumn get operationType => intEnum<OperationType>()();
  TextColumn get payload => text()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
}

class Doctors extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get specialization => text().withDefault(const Constant(''))();
  TextColumn get clinicAddress => text().withDefault(const Constant(''))();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get territory => text().withDefault(const Constant(''))();
  TextColumn get classification => text().withDefault(const Constant('C'))();
  DateTimeColumn get lastVisitDate => dateTime().nullable()();
  IntColumn get visitFrequency => integer().withDefault(const Constant(0))();
  RealColumn get conversionProbability =>
      real().withDefault(const Constant(0.0))();
  RealColumn get latitude => real().withDefault(const Constant(0.0))();
  RealColumn get longitude => real().withDefault(const Constant(0.0))();

  @override
  Set<Column> get primaryKey => {id};
}

class Dcrs extends Table {
  TextColumn get id => text()();
  TextColumn get doctorName => text()();
  TextColumn get doctorId => text().withDefault(const Constant(''))();
  TextColumn get productsDiscussed => text().withDefault(const Constant(''))();
  TextColumn get productsDetailed => text().withDefault(const Constant(''))();
  TextColumn get samplesGiven => text().withDefault(const Constant(''))();
  TextColumn get giftsGiven => text().withDefault(const Constant(''))();
  DateTimeColumn get followUpDate => dateTime().nullable()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  IntColumn get callDuration => integer().withDefault(const Constant(0))();
  RealColumn get geoLat => real().withDefault(const Constant(0.0))();
  RealColumn get geoLng => real().withDefault(const Constant(0.0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get mrId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Expenses extends Table {
  TextColumn get id => text()();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  IntColumn get category => intEnum<ExpenseCategory>()();
  TextColumn get receiptImagePath => text().nullable()();
  BoolColumn get isApproved => boolean().withDefault(const Constant(false))();
  BoolColumn get warningFlag => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get mrId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Visits extends Table {
  TextColumn get id => text()();
  TextColumn get doctorId => text().references(Doctors, #id)();
  TextColumn get mrId => text()();
  DateTimeColumn get visitDate => dateTime()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get outcome => text().withDefault(const Constant(''))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Recommendations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get doctorName => text()();
  TextColumn get specialization => text().withDefault(const Constant(''))();
  TextColumn get address => text().withDefault(const Constant(''))();
  RealColumn get score => real().withDefault(const Constant(0.0))();
  TextColumn get reason => text().withDefault(const Constant(''))();
  DateTimeColumn get fetchedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get mrId => text()();
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

// ─── New tables ─────────────────────────────────────────

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get email => text()();
  TextColumn get name => text()();
  TextColumn get role => text().withDefault(const Constant('mr'))();
  TextColumn get parentId => text().withDefault(const Constant(''))();
  TextColumn get territoryId => text().withDefault(const Constant(''))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get profileImageUrl => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Products extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get sku => text().withDefault(const Constant(''))();
  TextColumn get category => text().withDefault(const Constant(''))();
  TextColumn get division => text().withDefault(const Constant(''))();
  RealColumn get price => real().withDefault(const Constant(0.0))();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get imageUrl => text().withDefault(const Constant(''))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

class Samples extends Table {
  TextColumn get id => text()();
  TextColumn get productId => text()();
  TextColumn get mrId => text()();
  TextColumn get doctorId => text()();
  IntColumn get quantity => integer()();
  DateTimeColumn get date => dateTime()();
  TextColumn get batchNo => text().withDefault(const Constant(''))();
  DateTimeColumn get expiryDate => dateTime().nullable()();
  TextColumn get type => text().withDefault(const Constant('sample'))();

  @override
  Set<Column> get primaryKey => {id};
}

class Orders extends Table {
  TextColumn get id => text()();
  TextColumn get mrId => text()();
  TextColumn get doctorId => text()();
  IntColumn get status => intEnum<OrderStatus>()();
  RealColumn get totalAmount => real().withDefault(const Constant(0.0))();
  DateTimeColumn get orderDate => dateTime()();
  DateTimeColumn get deliveryDate => dateTime().nullable()();
  TextColumn get notes => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

class OrderItems extends Table {
  TextColumn get id => text()();
  TextColumn get orderId => text()();
  TextColumn get productId => text()();
  IntColumn get quantity => integer()();
  RealColumn get price => real()();
  RealColumn get discount => real().withDefault(const Constant(0.0))();

  @override
  Set<Column> get primaryKey => {id};
}

class TourPlans extends Table {
  TextColumn get id => text()();
  TextColumn get mrId => text()();
  IntColumn get month => integer()();
  IntColumn get year => integer()();
  TextColumn get status => text().withDefault(const Constant('draft'))();
  TextColumn get approvedBy => text().withDefault(const Constant(''))();
  DateTimeColumn get submittedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class TourPlanDays extends Table {
  TextColumn get id => text()();
  TextColumn get tourPlanId => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get doctorIds => text().withDefault(const Constant('[]'))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Attendances extends Table {
  TextColumn get id => text()();
  TextColumn get mrId => text()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get punchInTime => dateTime().nullable()();
  RealColumn get punchInLat => real().withDefault(const Constant(0.0))();
  RealColumn get punchInLng => real().withDefault(const Constant(0.0))();
  TextColumn get punchInSelfie => text().withDefault(const Constant(''))();
  DateTimeColumn get punchOutTime => dateTime().nullable()();
  RealColumn get punchOutLat => real().withDefault(const Constant(0.0))();
  RealColumn get punchOutLng => real().withDefault(const Constant(0.0))();
  IntColumn get status => intEnum<AttendanceStatus>()();

  @override
  Set<Column> get primaryKey => {id};
}

class LeaveRequests extends Table {
  TextColumn get id => text()();
  TextColumn get mrId => text()();
  IntColumn get leaveType => intEnum<LeaveType>()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  TextColumn get reason => text().withDefault(const Constant(''))();
  IntColumn get status => intEnum<ApprovalStatus>().withDefault(const Constant(0))();
  TextColumn get approvedBy => text().withDefault(const Constant(''))();
  TextColumn get comments => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

class LeaveBalances extends Table {
  TextColumn get id => text()();
  TextColumn get mrId => text()();
  IntColumn get leaveType => intEnum<LeaveType>()();
  IntColumn get total => integer().withDefault(const Constant(0))();
  IntColumn get used => integer().withDefault(const Constant(0))();
  IntColumn get remaining => integer().withDefault(const Constant(0))();
  IntColumn get year => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class Approvals extends Table {
  TextColumn get id => text()();
  IntColumn get type => intEnum<ApprovalEntityType>()();
  TextColumn get referenceId => text()();
  TextColumn get requesterId => text()();
  TextColumn get approverId => text().withDefault(const Constant(''))();
  IntColumn get status => intEnum<ApprovalStatus>().withDefault(const Constant(0))();
  TextColumn get comments => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Notifications extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  IntColumn get type => intEnum<NotificationType>()();
  TextColumn get referenceId => text().withDefault(const Constant(''))();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Campaigns extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get targetDoctors => text().withDefault(const Constant('[]'))();
  TextColumn get status => text().withDefault(const Constant('active'))();

  @override
  Set<Column> get primaryKey => {id};
}

class EDetailContents extends Table {
  TextColumn get id => text()();
  TextColumn get productId => text()();
  TextColumn get title => text()();
  TextColumn get type => text().withDefault(const Constant('pdf'))();
  TextColumn get url => text().withDefault(const Constant(''))();
  TextColumn get version => text().withDefault(const Constant('1.0'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

class Targets extends Table {
  TextColumn get id => text()();
  TextColumn get mrId => text()();
  TextColumn get productId => text().withDefault(const Constant(''))();
  IntColumn get targetType => intEnum<TargetType>()();
  RealColumn get targetValue => real().withDefault(const Constant(0.0))();
  RealColumn get achievedValue => real().withDefault(const Constant(0.0))();
  TextColumn get period => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class ActivityLogs extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get action => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text().withDefault(const Constant(''))();
  TextColumn get details => text().withDefault(const Constant(''))();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Territories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get parentId => text().withDefault(const Constant(''))();
  IntColumn get level => integer().withDefault(const Constant(0))();
  TextColumn get boundaries => text().withDefault(const Constant('{}'))();

  @override
  Set<Column> get primaryKey => {id};
}

class StockLedgers extends Table {
  TextColumn get id => text()();
  TextColumn get productId => text()();
  TextColumn get mrId => text()();
  IntColumn get openingStock => integer().withDefault(const Constant(0))();
  IntColumn get received => integer().withDefault(const Constant(0))();
  IntColumn get distributed => integer().withDefault(const Constant(0))();
  IntColumn get closingStock => integer().withDefault(const Constant(0))();
  DateTimeColumn get date => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    SyncQueueItems,
    Doctors,
    Dcrs,
    Expenses,
    Visits,
    Recommendations,
    AppSettings,
    Users,
    Products,
    Samples,
    Orders,
    OrderItems,
    TourPlans,
    TourPlanDays,
    Attendances,
    LeaveRequests,
    LeaveBalances,
    Approvals,
    Notifications,
    Campaigns,
    EDetailContents,
    Targets,
    ActivityLogs,
    Territories,
    StockLedgers,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase._()
      : super(driftDatabase(
          name: 'rx_force_sfa',
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ));

  static AppDatabase? _instance;

  factory AppDatabase() {
    _instance ??= AppDatabase._();
    return _instance!;
  }

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(users);
            await m.createTable(products);
            await m.createTable(samples);
            await m.createTable(orders);
            await m.createTable(orderItems);
            await m.createTable(tourPlans);
            await m.createTable(tourPlanDays);
            await m.createTable(attendances);
            await m.createTable(leaveRequests);
            await m.createTable(leaveBalances);
            await m.createTable(approvals);
            await m.createTable(notifications);
            await m.createTable(campaigns);
            await m.createTable(eDetailContents);
            await m.createTable(targets);
            await m.createTable(activityLogs);
            await m.createTable(territories);
            await m.createTable(stockLedgers);
          }
        },
      );

  // --- SyncQueue operations ---

  Future<List<SyncQueueItem>> getPendingSyncItems() {
    return (select(syncQueueItems)
          ..where((t) => t.isSynced.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  Future<int> getPendingSyncCount() async {
    final count = countAll();
    final query = selectOnly(syncQueueItems)
      ..addColumns([count])
      ..where(syncQueueItems.isSynced.equals(false));
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  Stream<int> watchPendingSyncCount() {
    final count = countAll();
    final query = selectOnly(syncQueueItems)
      ..addColumns([count])
      ..where(syncQueueItems.isSynced.equals(false));
    return query.watchSingle().map((row) => row.read(count) ?? 0);
  }

  Future<void> enqueue({
    required String collectionName,
    required String documentId,
    required OperationType opType,
    required String payload,
  }) {
    return into(syncQueueItems).insert(
      SyncQueueItemsCompanion.insert(
        collectionName: collectionName,
        documentId: documentId,
        operationType: opType,
        payload: payload,
      ),
    );
  }

  Future<void> markSynced(int id) {
    return (update(syncQueueItems)..where((t) => t.id.equals(id))).write(
      const SyncQueueItemsCompanion(isSynced: Value(true)),
    );
  }

  Future<void> markSyncFailed(int id, String error, int newRetryCount) {
    return (update(syncQueueItems)..where((t) => t.id.equals(id))).write(
      SyncQueueItemsCompanion(
        lastError: Value(error),
        retryCount: Value(newRetryCount),
      ),
    );
  }

  // --- Settings ---

  Future<String?> getSetting(String key) async {
    final row = await (select(appSettings)
          ..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> setSetting(String key, String value) {
    return into(appSettings).insertOnConflictUpdate(
      AppSettingsCompanion.insert(key: key, value: value),
    );
  }
}
