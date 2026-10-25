import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/database.dart';
import '../../data/repositories/approval_repository.dart';
import '../../data/repositories/activity_log_repository.dart';
import '../../data/repositories/notification_repository.dart';
import '../../data/repositories/territory_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../models/user_role.dart';
import 'core_providers.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  ref.keepAlive();
  return UserRepository(ref.watch(databaseProvider));
});

final territoryRepositoryProvider = Provider<TerritoryRepository>((ref) {
  ref.keepAlive();
  return TerritoryRepository(ref.watch(databaseProvider));
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  ref.keepAlive();
  return NotificationRepository(ref.watch(databaseProvider));
});

final approvalRepositoryProvider = Provider<ApprovalRepository>((ref) {
  ref.keepAlive();
  return ApprovalRepository(ref.watch(databaseProvider));
});

final activityLogRepositoryProvider = Provider<ActivityLogRepository>((ref) {
  ref.keepAlive();
  return ActivityLogRepository(ref.watch(databaseProvider));
});

final currentUserProfileProvider = StreamProvider<User?>((ref) {
  final authUser = ref.watch(authStateProvider).value;
  if (authUser == null) return Stream.value(null);
  return ref.watch(userRepositoryProvider).watchUserById(authUser.uid);
});

final currentUserRoleProvider = Provider<UserRole>((ref) {
  final profile = ref.watch(currentUserProfileProvider).value;
  if (profile == null) return UserRole.mr;
  return UserRole.fromString(profile.role);
});

final allUsersProvider = StreamProvider<List<User>>((ref) {
  return ref.watch(userRepositoryProvider).watchAllUsers();
});

final allTerritoriesProvider = StreamProvider<List<Territory>>((ref) {
  return ref.watch(territoryRepositoryProvider).watchAllTerritories();
});

final unreadNotificationCountProvider = StreamProvider<int>((ref) {
  final authUser = ref.watch(authStateProvider).value;
  if (authUser == null) return Stream.value(0);
  return ref.watch(notificationRepositoryProvider).watchUnreadCount(authUser.uid);
});

final teamMembersProvider = StreamProvider<List<User>>((ref) {
  final authUser = ref.watch(authStateProvider).value;
  if (authUser == null) return Stream.value([]);
  return ref.watch(userRepositoryProvider).watchTeamMembers(authUser.uid);
});

final pendingApprovalsProvider = StreamProvider<List<Approval>>((ref) {
  final authUser = ref.watch(authStateProvider).value;
  if (authUser == null) return Stream.value([]);
  return ref.watch(approvalRepositoryProvider).watchPendingForApprover(authUser.uid);
});
