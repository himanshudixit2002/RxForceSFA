import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/database.dart';
import '../../data/repositories/attendance_repository.dart';
import '../../data/repositories/campaign_repository.dart';
import '../../data/repositories/dcr_repository.dart';
import '../../data/repositories/doctor_repository.dart';
import '../../data/repositories/edetail_repository.dart';
import '../../data/repositories/expense_repository.dart';
import '../../data/repositories/leave_repository.dart';
import '../../data/repositories/order_repository.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/repositories/sample_repository.dart';
import '../../data/repositories/target_repository.dart';
import '../../data/repositories/tour_plan_repository.dart';
import '../../data/repositories/visit_repository.dart';
import '../services/storage_service.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  ref.keepAlive();
  return AppDatabase();
});

final firebaseAuthProvider = Provider<fb.FirebaseAuth>((ref) {
  ref.keepAlive();
  return fb.FirebaseAuth.instance;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  ref.keepAlive();
  return FirebaseFirestore.instance;
});

final authStateProvider = StreamProvider<fb.User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final connectivityProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  ref.keepAlive();
  return Connectivity().onConnectivityChanged;
});

final pendingSyncCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchPendingSyncCount();
});

final dcrRepositoryProvider = Provider<DcrRepository>((ref) {
  ref.keepAlive();
  return DcrRepository(ref.watch(databaseProvider));
});

final doctorRepositoryProvider = Provider<DoctorRepository>((ref) {
  ref.keepAlive();
  return DoctorRepository(ref.watch(databaseProvider));
});

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  ref.keepAlive();
  return ExpenseRepository(ref.watch(databaseProvider));
});

final visitRepositoryProvider = Provider<VisitRepository>((ref) {
  ref.keepAlive();
  return VisitRepository(ref.watch(databaseProvider));
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  ref.keepAlive();
  return OrderRepository(ref.watch(databaseProvider));
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  ref.keepAlive();
  return ProductRepository(ref.watch(databaseProvider));
});

final sampleRepositoryProvider = Provider<SampleRepository>((ref) {
  ref.keepAlive();
  return SampleRepository(ref.watch(databaseProvider));
});

final tourPlanRepositoryProvider = Provider<TourPlanRepository>((ref) {
  ref.keepAlive();
  return TourPlanRepository(ref.watch(databaseProvider));
});

final campaignRepositoryProvider = Provider<CampaignRepository>((ref) {
  ref.keepAlive();
  return CampaignRepository(ref.watch(databaseProvider));
});

final edetailRepositoryProvider = Provider<EDetailRepository>((ref) {
  ref.keepAlive();
  return EDetailRepository(ref.watch(databaseProvider));
});

final targetRepositoryProvider = Provider<TargetRepository>((ref) {
  ref.keepAlive();
  return TargetRepository(ref.watch(databaseProvider));
});

final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  ref.keepAlive();
  return AttendanceRepository(ref.watch(databaseProvider));
});

final leaveRepositoryProvider = Provider<LeaveRepository>((ref) {
  ref.keepAlive();
  return LeaveRepository(ref.watch(databaseProvider));
});

final storageServiceProvider = Provider<StorageService>((ref) {
  ref.keepAlive();
  return StorageService();
});
