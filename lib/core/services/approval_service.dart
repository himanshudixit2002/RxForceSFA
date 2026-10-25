import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/database.dart';
import '../../data/repositories/activity_log_repository.dart';
import '../../data/repositories/approval_repository.dart';
import '../../data/repositories/notification_repository.dart';

class ApprovalService {
  final ApprovalRepository _approvalRepo;
  final NotificationRepository _notifRepo;
  final ActivityLogRepository? _activityLogRepo;

  ApprovalService(this._approvalRepo, this._notifRepo, [this._activityLogRepo]);

  Future<void> submitForApproval({
    required ApprovalEntityType type,
    required String referenceId,
    required String requesterId,
    required String approverId,
  }) async {
    final id = const Uuid().v4();
    await _approvalRepo.createApproval(
      ApprovalsCompanion(
        id: Value(id),
        type: Value(type),
        referenceId: Value(referenceId),
        requesterId: Value(requesterId),
        approverId: Value(approverId),
        status: const Value(ApprovalStatus.pending),
      ),
    );

    await _notifRepo.insert(
      NotificationsCompanion(
        id: Value(const Uuid().v4()),
        userId: Value(approverId),
        title: const Value('New Approval Request'),
        body: Value('${type.name} approval pending your review'),
        type: const Value(NotificationType.approvalRequest),
        referenceId: Value(id),
      ),
    );

    await _activityLogRepo?.log(
      userId: requesterId,
      action: 'submit_for_approval',
      entityType: type.name,
      entityId: referenceId,
      details: 'Submitted ${type.name} for approval',
    );
  }

  Future<void> processApproval({
    required String approvalId,
    required ApprovalStatus newStatus,
    required String comments,
    required String requesterId,
  }) async {
    await _approvalRepo.updateStatus(approvalId, newStatus, comments);

    final statusLabel = newStatus == ApprovalStatus.approved ? 'approved' : 'rejected';
    await _notifRepo.insert(
      NotificationsCompanion(
        id: Value(const Uuid().v4()),
        userId: Value(requesterId),
        title: Value('Request $statusLabel'),
        body: Value('Your request has been $statusLabel'),
        type: const Value(NotificationType.approvalResult),
        referenceId: Value(approvalId),
      ),
    );

    await _activityLogRepo?.log(
      userId: requesterId,
      action: statusLabel,
      entityType: 'approval',
      entityId: approvalId,
      details: 'Approval $statusLabel. $comments',
    );
  }
}
