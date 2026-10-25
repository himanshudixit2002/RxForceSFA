import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show debugPrint;

import '../../data/models/database.dart';
import 'storage_service.dart';
import 'sync_service_workmanager.dart'
    if (dart.library.html) 'sync_service_workmanager_web.dart'
    as workmanager_init;

class SyncService {
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> initialize() async {
    try {
      await workmanager_init.initializeWorkmanager();
    } catch (e) {
      debugPrint('WorkManager init skipped: $e');
    }
  }

  static Future<bool> performSync() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        return true;
      }

      final db = AppDatabase();
      await _pushChanges(db);
      await _pullChanges(db);
      return true;
    } catch (_) {
      return false;
    }
  }

  static const _maxRetryCount = 10;
  static const _maxRetryDelayMinutes = 32;

  static Future<void> _pushChanges(AppDatabase db) async {
    final pending = await db.getPendingSyncItems();

    for (final item in pending) {
      if (item.retryCount >= _maxRetryCount) continue;

      final delayMinutes =
          min(pow(2, item.retryCount).toInt(), _maxRetryDelayMinutes);
      final maxRetryDelay = Duration(minutes: delayMinutes);
      if (item.retryCount > 0 &&
          DateTime.now().difference(item.createdAt) < maxRetryDelay) {
        continue;
      }

      try {
        final Map<String, dynamic> data;
        try {
          data = jsonDecode(item.payload) as Map<String, dynamic>;
        } on FormatException {
          await db.markSyncFailed(
              item.id, 'Corrupt payload', _maxRetryCount);
          continue;
        }

        final docRef =
            _firestore.collection(item.collectionName).doc(item.documentId);

        if (item.collectionName == 'expenses' &&
            item.operationType != OperationType.delete) {
          await _uploadReceiptIfLocal(data);
        }

        switch (item.operationType) {
          case OperationType.create:
            data['updatedAt'] = FieldValue.serverTimestamp();
            await docRef.set(data, SetOptions(merge: true));
            break;
          case OperationType.update:
            data['updatedAt'] = FieldValue.serverTimestamp();
            await docRef.update(data);
            break;
          case OperationType.delete:
            await docRef.delete();
            break;
        }

        await db.markSynced(item.id);
      } catch (e) {
        await db.markSyncFailed(item.id, e.toString(), item.retryCount + 1);
      }
    }
  }

  static Future<void> _pullChanges(AppDatabase db) async {
    final lastSync = await db.getSetting('lastSyncTimestamp');
    final since = lastSync != null
        ? (DateTime.tryParse(lastSync) ?? DateTime.fromMillisecondsSinceEpoch(0))
        : DateTime.fromMillisecondsSinceEpoch(0);

    await _pullUsers(db, since);
    await _pullProducts(db, since);
    await _pullTerritories(db, since);
    await _pullDoctors(db, since);
    await _pullDcrs(db, since);
    await _pullExpenses(db, since);
    await _pullVisits(db, since);
    await _pullTourPlans(db, since);
    await _pullTourPlanDays(db, since);
    await _pullAttendances(db, since);
    await _pullLeaveRequests(db, since);
    await _pullLeaveBalances(db, since);
    await _pullSamples(db, since);
    await _pullOrders(db, since);
    await _pullOrderItems(db, since);
    await _pullTargets(db, since);
    await _pullStockLedgers(db, since);
    await _pullApprovals(db, since);
    await _pullNotifications(db, since);
    await _pullCampaigns(db, since);
    await _pullEDetailContents(db, since);
    await _pullActivityLogs(db, since);

    await db.setSetting('lastSyncTimestamp', DateTime.now().toIso8601String());
  }

  static Future<void> _pullDoctors(AppDatabase db, DateTime since) async {
    await _pullCollection<Doctor>(
      db: db,
      collectionName: 'doctors',
      since: since,
      fromFirestore: (doc) {
        final d = doc.data()!;
        return Doctor(
          id: doc.id,
          name: d['name'] as String? ?? '',
          specialization: d['specialization'] as String? ?? '',
          clinicAddress: d['clinicAddress'] as String? ?? '',
          phone: d['phone'] as String? ?? '',
          territory: d['territory'] as String? ?? '',
          classification: d['classification'] as String? ?? 'C',
          lastVisitDate: (d['lastVisitDate'] as Timestamp?)?.toDate(),
          visitFrequency: d['visitFrequency'] as int? ?? 0,
          conversionProbability:
              (d['conversionProbability'] as num?)?.toDouble() ?? 0.0,
          latitude: (d['latitude'] as num?)?.toDouble() ?? 0.0,
          longitude: (d['longitude'] as num?)?.toDouble() ?? 0.0,
        );
      },
      upsert: (doctor) => db.into(db.doctors).insertOnConflictUpdate(
            DoctorsCompanion.insert(
              id: doctor.id,
              name: doctor.name,
              specialization: Value(doctor.specialization),
              clinicAddress: Value(doctor.clinicAddress),
              phone: Value(doctor.phone),
              territory: Value(doctor.territory),
              classification: Value(doctor.classification),
              lastVisitDate: Value(doctor.lastVisitDate),
              visitFrequency: Value(doctor.visitFrequency),
              conversionProbability: Value(doctor.conversionProbability),
              latitude: Value(doctor.latitude),
              longitude: Value(doctor.longitude),
            ),
          ),
    );
  }

  static Future<void> _pullDcrs(AppDatabase db, DateTime since) async {
    await _pullCollection<Dcr>(
      db: db,
      collectionName: 'dcrs',
      since: since,
      fromFirestore: (doc) {
        final d = doc.data()!;
        return Dcr(
          id: doc.id,
          doctorName: d['doctorName'] as String? ?? '',
          doctorId: d['doctorId'] as String? ?? '',
          productsDiscussed: d['productsDiscussed'] as String? ?? '',
          productsDetailed: d['productsDetailed'] as String? ?? '',
          samplesGiven: d['samplesGiven'] as String? ?? '',
          giftsGiven: d['giftsGiven'] as String? ?? '',
          followUpDate: d['followUpDate'] != null
              ? (d['followUpDate'] is Timestamp
                  ? (d['followUpDate'] as Timestamp).toDate()
                  : DateTime.tryParse(d['followUpDate'] as String))
              : null,
          notes: d['notes'] as String? ?? '',
          callDuration: d['callDuration'] as int? ?? 0,
          geoLat: (d['geoLat'] as num?)?.toDouble() ?? 0.0,
          geoLng: (d['geoLng'] as num?)?.toDouble() ?? 0.0,
          createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          mrId: d['mrId'] as String? ?? '',
        );
      },
      upsert: (dcr) => db.into(db.dcrs).insertOnConflictUpdate(
            DcrsCompanion.insert(
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
            ),
          ),
    );
  }

  static Future<void> _pullExpenses(AppDatabase db, DateTime since) async {
    await _pullCollection<Expense>(
      db: db,
      collectionName: 'expenses',
      since: since,
      fromFirestore: (doc) {
        final d = doc.data()!;
        return Expense(
          id: doc.id,
          amount: (d['amount'] as num?)?.toDouble() ?? 0.0,
          date: (d['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
          category: ExpenseCategory.values[
              (d['category'] as int? ?? 0)
                  .clamp(0, ExpenseCategory.values.length - 1)],
          receiptImagePath: d['receiptImagePath'] as String?,
          isApproved: d['isApproved'] as bool? ?? false,
          warningFlag: d['warningFlag'] as bool? ?? false,
          createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          mrId: d['mrId'] as String? ?? '',
        );
      },
      upsert: (expense) => db.into(db.expenses).insertOnConflictUpdate(
            ExpensesCompanion.insert(
              id: expense.id,
              amount: expense.amount,
              date: expense.date,
              category: expense.category,
              receiptImagePath: Value(expense.receiptImagePath),
              isApproved: Value(expense.isApproved),
              warningFlag: Value(expense.warningFlag),
              mrId: expense.mrId,
            ),
          ),
    );
  }

  static Future<void> _pullVisits(AppDatabase db, DateTime since) async {
    await _pullCollection<Visit>(
      db: db,
      collectionName: 'visits',
      since: since,
      fromFirestore: (doc) {
        final d = doc.data()!;
        return Visit(
          id: doc.id,
          doctorId: d['doctorId'] as String? ?? '',
          mrId: d['mrId'] as String? ?? '',
          visitDate: (d['visitDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
          notes: d['notes'] as String? ?? '',
          outcome: d['outcome'] as String? ?? '',
          isCompleted: d['isCompleted'] as bool? ?? false,
        );
      },
      upsert: (visit) => db.into(db.visits).insertOnConflictUpdate(
            VisitsCompanion.insert(
              id: visit.id,
              doctorId: visit.doctorId,
              mrId: visit.mrId,
              visitDate: visit.visitDate,
              notes: Value(visit.notes),
              outcome: Value(visit.outcome),
              isCompleted: Value(visit.isCompleted),
            ),
          ),
    );
  }

  static Future<void> _pullUsers(AppDatabase db, DateTime since) async {
    await _pullCollection<User>(
      db: db,
      collectionName: 'users',
      since: since,
      fromFirestore: (doc) {
        final d = doc.data()!;
        return User(
          id: doc.id,
          email: d['email'] as String? ?? '',
          name: d['name'] as String? ?? '',
          role: d['role'] as String? ?? 'mr',
          parentId: d['parentId'] as String? ?? '',
          territoryId: d['territoryId'] as String? ?? '',
          isActive: d['isActive'] as bool? ?? true,
          phone: d['phone'] as String? ?? '',
          profileImageUrl: d['profileImageUrl'] as String? ?? '',
          createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      },
      upsert: (u) => db.into(db.users).insertOnConflictUpdate(
            UsersCompanion.insert(
              id: u.id, email: u.email, name: u.name,
              role: Value(u.role), parentId: Value(u.parentId),
              territoryId: Value(u.territoryId), isActive: Value(u.isActive),
              phone: Value(u.phone), profileImageUrl: Value(u.profileImageUrl),
            ),
          ),
    );
  }

  static Future<void> _pullProducts(AppDatabase db, DateTime since) async {
    await _pullCollection<Product>(
      db: db,
      collectionName: 'products',
      since: since,
      fromFirestore: (doc) {
        final d = doc.data()!;
        return Product(
          id: doc.id,
          name: d['name'] as String? ?? '',
          sku: d['sku'] as String? ?? '',
          category: d['category'] as String? ?? '',
          division: d['division'] as String? ?? '',
          price: (d['price'] as num?)?.toDouble() ?? 0.0,
          description: d['description'] as String? ?? '',
          imageUrl: d['imageUrl'] as String? ?? '',
          isActive: d['isActive'] as bool? ?? true,
        );
      },
      upsert: (p) => db.into(db.products).insertOnConflictUpdate(
            ProductsCompanion.insert(
              id: p.id, name: p.name,
              sku: Value(p.sku), category: Value(p.category),
              division: Value(p.division), price: Value(p.price),
              description: Value(p.description), imageUrl: Value(p.imageUrl),
              isActive: Value(p.isActive),
            ),
          ),
    );
  }

  static Future<void> _pullTerritories(AppDatabase db, DateTime since) async {
    await _pullCollection<Territory>(
      db: db,
      collectionName: 'territories',
      since: since,
      fromFirestore: (doc) {
        final d = doc.data()!;
        return Territory(
          id: doc.id,
          name: d['name'] as String? ?? '',
          parentId: d['parentId'] as String? ?? '',
          level: d['level'] as int? ?? 0,
          boundaries: d['boundaries'] as String? ?? '{}',
        );
      },
      upsert: (t) => db.into(db.territories).insertOnConflictUpdate(
            TerritoriesCompanion.insert(
              id: t.id, name: t.name,
              parentId: Value(t.parentId), level: Value(t.level),
              boundaries: Value(t.boundaries),
            ),
          ),
    );
  }

  static Future<void> _pullTourPlans(AppDatabase db, DateTime since) async {
    await _pullCollection<TourPlan>(
      db: db,
      collectionName: 'tourPlans',
      since: since,
      fromFirestore: (doc) {
        final d = doc.data()!;
        return TourPlan(
          id: doc.id,
          mrId: d['mrId'] as String? ?? '',
          month: d['month'] as int? ?? 1,
          year: d['year'] as int? ?? DateTime.now().year,
          status: d['status'] as String? ?? 'draft',
          approvedBy: d['approvedBy'] as String? ?? '',
          submittedAt: (d['submittedAt'] as Timestamp?)?.toDate(),
          createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      },
      upsert: (tp) => db.into(db.tourPlans).insertOnConflictUpdate(
            TourPlansCompanion.insert(
              id: tp.id, mrId: tp.mrId, month: tp.month, year: tp.year,
              status: Value(tp.status), approvedBy: Value(tp.approvedBy),
              submittedAt: Value(tp.submittedAt),
            ),
          ),
    );
  }

  static Future<void> _pullTourPlanDays(AppDatabase db, DateTime since) async {
    await _pullCollection<TourPlanDay>(
      db: db,
      collectionName: 'tourPlanDays',
      since: since,
      fromFirestore: (doc) {
        final d = doc.data()!;
        return TourPlanDay(
          id: doc.id,
          tourPlanId: d['tourPlanId'] as String? ?? '',
          date: (d['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
          doctorIds: d['doctorIds'] as String? ?? '[]',
          notes: d['notes'] as String? ?? '',
          isCompleted: d['isCompleted'] as bool? ?? false,
        );
      },
      upsert: (td) => db.into(db.tourPlanDays).insertOnConflictUpdate(
            TourPlanDaysCompanion.insert(
              id: td.id, tourPlanId: td.tourPlanId, date: td.date,
              doctorIds: Value(td.doctorIds), notes: Value(td.notes),
              isCompleted: Value(td.isCompleted),
            ),
          ),
    );
  }

  static Future<void> _pullAttendances(AppDatabase db, DateTime since) async {
    await _pullCollection<Attendance>(
      db: db,
      collectionName: 'attendances',
      since: since,
      fromFirestore: (doc) {
        final d = doc.data()!;
        return Attendance(
          id: doc.id,
          mrId: d['mrId'] as String? ?? '',
          date: (d['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
          punchInTime: (d['punchInTime'] as Timestamp?)?.toDate(),
          punchInLat: (d['punchInLat'] as num?)?.toDouble() ?? 0.0,
          punchInLng: (d['punchInLng'] as num?)?.toDouble() ?? 0.0,
          punchInSelfie: d['punchInSelfie'] as String? ?? '',
          punchOutTime: (d['punchOutTime'] as Timestamp?)?.toDate(),
          punchOutLat: (d['punchOutLat'] as num?)?.toDouble() ?? 0.0,
          punchOutLng: (d['punchOutLng'] as num?)?.toDouble() ?? 0.0,
          status: AttendanceStatus.values[(d['status'] as int? ?? 0).clamp(0, AttendanceStatus.values.length - 1)],
        );
      },
      upsert: (a) => db.into(db.attendances).insertOnConflictUpdate(
            AttendancesCompanion.insert(
              id: a.id, mrId: a.mrId, date: a.date,
              punchInTime: Value(a.punchInTime), punchInLat: Value(a.punchInLat),
              punchInLng: Value(a.punchInLng), punchInSelfie: Value(a.punchInSelfie),
              punchOutTime: Value(a.punchOutTime), punchOutLat: Value(a.punchOutLat),
              punchOutLng: Value(a.punchOutLng), status: a.status,
            ),
          ),
    );
  }

  static Future<void> _pullLeaveRequests(AppDatabase db, DateTime since) async {
    await _pullCollection<LeaveRequest>(
      db: db,
      collectionName: 'leaveRequests',
      since: since,
      fromFirestore: (doc) {
        final d = doc.data()!;
        return LeaveRequest(
          id: doc.id,
          mrId: d['mrId'] as String? ?? '',
          leaveType: LeaveType.values[(d['leaveType'] as int? ?? 0).clamp(0, LeaveType.values.length - 1)],
          startDate: (d['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
          endDate: (d['endDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
          reason: d['reason'] as String? ?? '',
          status: ApprovalStatus.values[(d['status'] as int? ?? 0).clamp(0, ApprovalStatus.values.length - 1)],
          approvedBy: d['approvedBy'] as String? ?? '',
          comments: d['comments'] as String? ?? '',
        );
      },
      upsert: (lr) => db.into(db.leaveRequests).insertOnConflictUpdate(
            LeaveRequestsCompanion.insert(
              id: lr.id, mrId: lr.mrId, leaveType: lr.leaveType,
              startDate: lr.startDate, endDate: lr.endDate,
              reason: Value(lr.reason), status: Value(lr.status),
              approvedBy: Value(lr.approvedBy), comments: Value(lr.comments),
            ),
          ),
    );
  }

  static Future<void> _pullLeaveBalances(AppDatabase db, DateTime since) async {
    await _pullCollection<LeaveBalance>(
      db: db,
      collectionName: 'leaveBalances',
      since: since,
      fromFirestore: (doc) {
        final d = doc.data()!;
        return LeaveBalance(
          id: doc.id,
          mrId: d['mrId'] as String? ?? '',
          leaveType: LeaveType.values[(d['leaveType'] as int? ?? 0).clamp(0, LeaveType.values.length - 1)],
          total: d['total'] as int? ?? 0,
          used: d['used'] as int? ?? 0,
          remaining: d['remaining'] as int? ?? 0,
          year: d['year'] as int? ?? DateTime.now().year,
        );
      },
      upsert: (lb) => db.into(db.leaveBalances).insertOnConflictUpdate(
            LeaveBalancesCompanion.insert(
              id: lb.id, mrId: lb.mrId, leaveType: lb.leaveType,
              total: Value(lb.total), used: Value(lb.used),
              remaining: Value(lb.remaining), year: lb.year,
            ),
          ),
    );
  }

  static Future<void> _pullSamples(AppDatabase db, DateTime since) async {
    await _pullCollection<Sample>(
      db: db,
      collectionName: 'samples',
      since: since,
      fromFirestore: (doc) {
        final d = doc.data()!;
        return Sample(
          id: doc.id,
          productId: d['productId'] as String? ?? '',
          mrId: d['mrId'] as String? ?? '',
          doctorId: d['doctorId'] as String? ?? '',
          quantity: d['quantity'] as int? ?? 0,
          date: (d['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
          batchNo: d['batchNo'] as String? ?? '',
          expiryDate: (d['expiryDate'] as Timestamp?)?.toDate(),
          type: d['type'] as String? ?? 'sample',
        );
      },
      upsert: (s) => db.into(db.samples).insertOnConflictUpdate(
            SamplesCompanion.insert(
              id: s.id, productId: s.productId, mrId: s.mrId,
              doctorId: s.doctorId, quantity: s.quantity, date: s.date,
              batchNo: Value(s.batchNo), expiryDate: Value(s.expiryDate),
              type: Value(s.type),
            ),
          ),
    );
  }

  static Future<void> _pullOrders(AppDatabase db, DateTime since) async {
    await _pullCollection<Order>(
      db: db,
      collectionName: 'orders',
      since: since,
      fromFirestore: (doc) {
        final d = doc.data()!;
        return Order(
          id: doc.id,
          mrId: d['mrId'] as String? ?? '',
          doctorId: d['doctorId'] as String? ?? '',
          status: OrderStatus.values[(d['status'] as int? ?? 0).clamp(0, OrderStatus.values.length - 1)],
          totalAmount: (d['totalAmount'] as num?)?.toDouble() ?? 0.0,
          orderDate: (d['orderDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
          deliveryDate: (d['deliveryDate'] as Timestamp?)?.toDate(),
          notes: d['notes'] as String? ?? '',
        );
      },
      upsert: (o) => db.into(db.orders).insertOnConflictUpdate(
            OrdersCompanion.insert(
              id: o.id, mrId: o.mrId, doctorId: o.doctorId,
              status: o.status, orderDate: o.orderDate,
              totalAmount: Value(o.totalAmount), deliveryDate: Value(o.deliveryDate),
              notes: Value(o.notes),
            ),
          ),
    );
  }

  static Future<void> _pullOrderItems(AppDatabase db, DateTime since) async {
    await _pullCollection<OrderItem>(
      db: db,
      collectionName: 'orderItems',
      since: since,
      fromFirestore: (doc) {
        final d = doc.data()!;
        return OrderItem(
          id: doc.id,
          orderId: d['orderId'] as String? ?? '',
          productId: d['productId'] as String? ?? '',
          quantity: d['quantity'] as int? ?? 0,
          price: (d['price'] as num?)?.toDouble() ?? 0.0,
          discount: (d['discount'] as num?)?.toDouble() ?? 0.0,
        );
      },
      upsert: (oi) => db.into(db.orderItems).insertOnConflictUpdate(
            OrderItemsCompanion.insert(
              id: oi.id, orderId: oi.orderId, productId: oi.productId,
              quantity: oi.quantity, price: oi.price, discount: Value(oi.discount),
            ),
          ),
    );
  }

  static Future<void> _pullTargets(AppDatabase db, DateTime since) async {
    await _pullCollection<Target>(
      db: db,
      collectionName: 'targets',
      since: since,
      fromFirestore: (doc) {
        final d = doc.data()!;
        return Target(
          id: doc.id,
          mrId: d['mrId'] as String? ?? '',
          productId: d['productId'] as String? ?? '',
          targetType: TargetType.values[(d['targetType'] as int? ?? 0).clamp(0, TargetType.values.length - 1)],
          targetValue: (d['targetValue'] as num?)?.toDouble() ?? 0.0,
          achievedValue: (d['achievedValue'] as num?)?.toDouble() ?? 0.0,
          period: d['period'] as String? ?? '',
        );
      },
      upsert: (t) => db.into(db.targets).insertOnConflictUpdate(
            TargetsCompanion.insert(
              id: t.id, mrId: t.mrId, productId: Value(t.productId),
              targetType: t.targetType, targetValue: Value(t.targetValue),
              achievedValue: Value(t.achievedValue), period: t.period,
            ),
          ),
    );
  }

  static Future<void> _pullStockLedgers(AppDatabase db, DateTime since) async {
    await _pullCollection<StockLedger>(
      db: db,
      collectionName: 'stockLedgers',
      since: since,
      fromFirestore: (doc) {
        final d = doc.data()!;
        return StockLedger(
          id: doc.id,
          productId: d['productId'] as String? ?? '',
          mrId: d['mrId'] as String? ?? '',
          openingStock: d['openingStock'] as int? ?? 0,
          received: d['received'] as int? ?? 0,
          distributed: d['distributed'] as int? ?? 0,
          closingStock: d['closingStock'] as int? ?? 0,
          date: (d['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      },
      upsert: (sl) => db.into(db.stockLedgers).insertOnConflictUpdate(
            StockLedgersCompanion.insert(
              id: sl.id, productId: sl.productId, mrId: sl.mrId,
              date: sl.date, openingStock: Value(sl.openingStock),
              received: Value(sl.received), distributed: Value(sl.distributed),
              closingStock: Value(sl.closingStock),
            ),
          ),
    );
  }

  static Future<void> _pullApprovals(AppDatabase db, DateTime since) async {
    await _pullCollection<Approval>(
      db: db,
      collectionName: 'approvals',
      since: since,
      fromFirestore: (doc) {
        final d = doc.data()!;
        return Approval(
          id: doc.id,
          type: ApprovalEntityType.values[(d['type'] as int? ?? 0).clamp(0, ApprovalEntityType.values.length - 1)],
          referenceId: d['referenceId'] as String? ?? '',
          requesterId: d['requesterId'] as String? ?? '',
          approverId: d['approverId'] as String? ?? '',
          status: ApprovalStatus.values[(d['status'] as int? ?? 0).clamp(0, ApprovalStatus.values.length - 1)],
          comments: d['comments'] as String? ?? '',
          createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      },
      upsert: (a) => db.into(db.approvals).insertOnConflictUpdate(
            ApprovalsCompanion.insert(
              id: a.id, type: a.type, referenceId: a.referenceId,
              requesterId: a.requesterId, approverId: Value(a.approverId),
              status: Value(a.status), comments: Value(a.comments),
            ),
          ),
    );
  }

  static Future<void> _pullNotifications(AppDatabase db, DateTime since) async {
    await _pullCollection<Notification>(
      db: db,
      collectionName: 'notifications',
      since: since,
      fromFirestore: (doc) {
        final d = doc.data()!;
        return Notification(
          id: doc.id,
          userId: d['userId'] as String? ?? '',
          title: d['title'] as String? ?? '',
          body: d['body'] as String? ?? '',
          type: NotificationType.values[(d['type'] as int? ?? 4).clamp(0, NotificationType.values.length - 1)],
          referenceId: d['referenceId'] as String? ?? '',
          isRead: d['isRead'] as bool? ?? false,
          createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      },
      upsert: (n) => db.into(db.notifications).insertOnConflictUpdate(
            NotificationsCompanion.insert(
              id: n.id, userId: n.userId, title: n.title, body: n.body,
              type: n.type, referenceId: Value(n.referenceId),
              isRead: Value(n.isRead),
            ),
          ),
    );
  }

  static Future<void> _pullCampaigns(AppDatabase db, DateTime since) async {
    await _pullCollection<Campaign>(
      db: db,
      collectionName: 'campaigns',
      since: since,
      fromFirestore: (doc) {
        final d = doc.data()!;
        return Campaign(
          id: doc.id,
          name: d['name'] as String? ?? '',
          startDate: (d['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
          endDate: (d['endDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
          description: d['description'] as String? ?? '',
          targetDoctors: d['targetDoctors'] as String? ?? '[]',
          status: d['status'] as String? ?? 'active',
        );
      },
      upsert: (c) => db.into(db.campaigns).insertOnConflictUpdate(
            CampaignsCompanion.insert(
              id: c.id, name: c.name, startDate: c.startDate,
              endDate: c.endDate, description: Value(c.description),
              targetDoctors: Value(c.targetDoctors), status: Value(c.status),
            ),
          ),
    );
  }

  static Future<void> _pullEDetailContents(AppDatabase db, DateTime since) async {
    await _pullCollection<EDetailContent>(
      db: db,
      collectionName: 'eDetailContents',
      since: since,
      fromFirestore: (doc) {
        final d = doc.data()!;
        return EDetailContent(
          id: doc.id,
          productId: d['productId'] as String? ?? '',
          title: d['title'] as String? ?? '',
          type: d['type'] as String? ?? 'pdf',
          url: d['url'] as String? ?? '',
          version: d['version'] as String? ?? '1.0',
          isActive: d['isActive'] as bool? ?? true,
        );
      },
      upsert: (e) => db.into(db.eDetailContents).insertOnConflictUpdate(
            EDetailContentsCompanion.insert(
              id: e.id, productId: e.productId, title: e.title,
              type: Value(e.type), url: Value(e.url),
              version: Value(e.version), isActive: Value(e.isActive),
            ),
          ),
    );
  }

  static Future<void> _pullActivityLogs(AppDatabase db, DateTime since) async {
    await _pullCollection<ActivityLog>(
      db: db,
      collectionName: 'activityLogs',
      since: since,
      fromFirestore: (doc) {
        final d = doc.data()!;
        return ActivityLog(
          id: doc.id,
          userId: d['userId'] as String? ?? '',
          action: d['action'] as String? ?? '',
          entityType: d['entityType'] as String? ?? '',
          entityId: d['entityId'] as String? ?? '',
          details: d['details'] as String? ?? '',
          timestamp: (d['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      },
      upsert: (a) => db.into(db.activityLogs).insertOnConflictUpdate(
            ActivityLogsCompanion.insert(
              id: a.id, userId: a.userId, action: a.action,
              entityType: a.entityType, entityId: Value(a.entityId),
              details: Value(a.details),
            ),
          ),
    );
  }

  static Future<void> _pullCollection<T>({
    required AppDatabase db,
    required String collectionName,
    required DateTime since,
    required T Function(DocumentSnapshot<Map<String, dynamic>>) fromFirestore,
    required Future<void> Function(T) upsert,
  }) async {
    try {
      final snapshot = await _firestore
          .collection(collectionName)
          .where('updatedAt', isGreaterThan: Timestamp.fromDate(since))
          .get();

      for (final doc in snapshot.docs) {
        final item = fromFirestore(doc);
        await upsert(item);
      }
    } catch (_) {
      // Collection may not exist yet or may not have updatedAt field
    }
  }

  static Future<void> _uploadReceiptIfLocal(
      Map<String, dynamic> data) async {
    final receiptPath = data['receiptImagePath'] as String?;
    if (receiptPath == null || receiptPath.isEmpty) return;
    if (StorageService.isDownloadUrl(receiptPath)) return;

    try {
      final storageService = StorageService();
      final userId = data['mrId'] as String? ?? '';
      final expenseId = data['id'] as String? ?? '';
      if (userId.isEmpty || expenseId.isEmpty) return;

      final downloadUrl = await storageService.uploadReceiptImage(
        userId: userId,
        expenseId: expenseId,
        localPath: receiptPath,
      );
      data['receiptImagePath'] = downloadUrl;
    } catch (_) {
      // Keep local path; will retry on next sync
    }
  }

  static Future<void> syncNow() => performSync();
}
