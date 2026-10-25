import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../core/providers/core_providers.dart';
import '../../core/providers/user_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart' as db;
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/error_retry_card.dart';
import '../../presentation/widgets/shimmer_loading.dart';

final _leaveRequestsProvider = StreamProvider<List<db.LeaveRequest>>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return Stream.value([]);
  return ref.watch(leaveRepositoryProvider).watchForMr(uid);
});

final _leaveBalancesProvider = StreamProvider<List<db.LeaveBalance>>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return Stream.value([]);
  return ref.watch(leaveRepositoryProvider).watchBalances(uid);
});

class LeaveRequestScreen extends ConsumerStatefulWidget {
  const LeaveRequestScreen({super.key});

  @override
  ConsumerState<LeaveRequestScreen> createState() =>
      _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends ConsumerState<LeaveRequestScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final balancesAsync = ref.watch(_leaveBalancesProvider);
    final requestsAsync = ref.watch(_leaveRequestsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Leave Management')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showApplyDialog,
        icon: const Icon(Icons.add),
        label: const Text('Apply Leave'),
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: adaptiveMaxWidth(context),
          padding: adaptivePadding(context),
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(_leaveBalancesProvider);
              ref.invalidate(_leaveRequestsProvider);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
              Text('Leave Balance',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              balancesAsync.when(
                data: (balances) => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: balances
                      .map((b) => _BalanceChip(
                            type: db.LeaveType.values[b.leaveType.index].name,
                            remaining: b.remaining,
                            total: b.total,
                          ))
                      .toList(),
                ),
                loading: () => const ShimmerLoading(itemCount: 3),
                error: (e, _) => ErrorRetryCard(
                  message: 'Failed to load leave balances',
                  onRetry: () => ref.invalidate(_leaveBalancesProvider),
                ),
              ),
              const SizedBox(height: 24),
              Text('Leave History',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              requestsAsync.when(
                data: (requests) {
                  if (requests.isEmpty) {
                    return const EmptyState(
                      icon: Icons.event_busy,
                      title: 'No leave requests',
                      subtitle: 'Your leave requests will appear here',
                    );
                  }
                  return Column(
                    children: requests
                        .map((r) => Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: Icon(
                                  Icons.event_busy,
                                  color: _statusColor(r.status),
                                ),
                                title: Text(
                                    '${db.LeaveType.values[r.leaveType.index].name} leave'),
                                subtitle: Text(
                                    '${DateFormat.MMMd().format(r.startDate)} - ${DateFormat.MMMd().format(r.endDate)}'),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _statusColor(r.status)
                                        .withValues(alpha: 0.12),
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    db.ApprovalStatus.values[r.status.index].name
                                        .toUpperCase(),
                                    style: TextStyle(
                                      color: _statusColor(r.status),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  );
                },
                loading: () => const ShimmerLoading(itemCount: 3),
                error: (e, _) => ErrorRetryCard(
                  message: 'Failed to load leave requests',
                  onRetry: () => ref.invalidate(_leaveRequestsProvider),
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _statusColor(db.ApprovalStatus status) {
    switch (status) {
      case db.ApprovalStatus.approved:
        return Colors.green;
      case db.ApprovalStatus.rejected:
        return Colors.red;
      case db.ApprovalStatus.pending:
        return Colors.orange;
      case db.ApprovalStatus.escalated:
        return Colors.blue;
    }
  }

  Future<void> _showApplyDialog() async {
    db.LeaveType selectedType = db.LeaveType.casual;
    DateTimeRange? range;
    final reasonCtrl = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Apply for Leave'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<db.LeaveType>(
                  value: selectedType,
                  decoration:
                      const InputDecoration(labelText: 'Leave Type'),
                  items: db.LeaveType.values
                      .map((t) => DropdownMenuItem(
                          value: t, child: Text(t.name)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      setDialogState(() => selectedType = v);
                    }
                  },
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(range == null
                      ? 'Select dates'
                      : '${DateFormat.MMMd().format(range!.start)} - ${DateFormat.MMMd().format(range!.end)}'),
                  trailing: const Icon(Icons.date_range),
                  onTap: () async {
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now()
                          .add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setDialogState(() => range = picked);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: reasonCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Reason'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );

    if (result == true && range != null) {
      try {
        final uid = ref.read(authStateProvider).value?.uid ?? '';
        final leaveId = const Uuid().v4();
        await ref.read(leaveRepositoryProvider).createRequest(
              db.LeaveRequestsCompanion(
                id: Value(leaveId),
                mrId: Value(uid),
                leaveType: Value(selectedType),
                startDate: Value(range!.start),
                endDate: Value(range!.end),
                reason: Value(reasonCtrl.text),
              ),
            );
        await ref.read(activityLogRepositoryProvider).log(
              userId: uid,
              action: 'submit_leave',
              entityType: 'leave',
              entityId: leaveId,
              details: 'Leave request: ${selectedType.name}',
            );
        ref.invalidate(_leaveRequestsProvider);
        ref.invalidate(_leaveBalancesProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Leave request submitted')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to submit leave request. Please try again.')),
          );
        }
      }
    }
    reasonCtrl.dispose();
  }
}

class _BalanceChip extends StatelessWidget {
  final String type;
  final int remaining;
  final int total;

  const _BalanceChip({
    required this.type,
    required this.remaining,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Text(type.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 4),
            Text('$remaining/$total',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
