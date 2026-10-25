import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


import '../../core/providers/user_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart';
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/error_retry_card.dart';
import '../../presentation/widgets/shimmer_loading.dart';

class ManagerDashboardScreen extends ConsumerWidget {
  const ManagerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profile = ref.watch(currentUserProfileProvider).value;
    final teamMembers = ref.watch(teamMembersProvider);
    final pendingApprovals = ref.watch(pendingApprovalsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Manager Dashboard',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            if (profile != null)
              Text('Welcome, ${profile.name}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/notifications'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
        padding: adaptivePadding(context),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: adaptiveMaxWidth(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildKpiRow(context, ref, teamMembers),
                const SizedBox(height: 24),
                Text('Pending Approvals',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                _buildApprovalsList(context, ref, pendingApprovals),
                const SizedBox(height: 24),
                Text('Quick Actions',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                _buildQuickActions(context),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildKpiRow(BuildContext context, WidgetRef ref,
      AsyncValue<List<User>> teamMembers) {
    final theme = Theme.of(context);
    final memberCount = teamMembers.value?.length ?? 0;
    final pendingCount =
        ref.watch(pendingApprovalsProvider).value?.length ?? 0;

    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.people, color: theme.colorScheme.primary),
                  const SizedBox(height: 8),
                  Text('$memberCount',
                      style: theme.textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  Text('Team Members',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.pending_actions,
                      color: theme.colorScheme.tertiary),
                  const SizedBox(height: 8),
                  Text('$pendingCount',
                      style: theme.textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  Text('Pending Approvals',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildApprovalsList(
      BuildContext context, WidgetRef ref, AsyncValue<List<Approval>> approvals) {
    return approvals.when(
      data: (items) {
        if (items.isEmpty) {
          return const EmptyState(
            icon: Icons.approval,
            title: 'No pending approvals',
            subtitle: 'All caught up!',
          );
        }
        return Column(
          children: items.take(5).map((a) {
            return Card(
              child: ListTile(
                leading: Icon(_iconForType(a.type.name),
                    color: Theme.of(context).colorScheme.primary),
                title: Text(a.type.name),
                subtitle: Text('Status: ${a.status.name}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/manager/approvals/${a.id}'),
              ),
            );
          }).toList(),
        );
      },
      loading: () => const ShimmerLoading(itemCount: 3),
      error: (e, _) => ErrorRetryCard(
        message: 'Failed to load approvals',
        onRetry: () => ref.invalidate(pendingApprovalsProvider),
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'leave':
        return Icons.event_busy;
      case 'expense':
        return Icons.receipt_long;
      case 'order':
        return Icons.shopping_cart;
      case 'tour_plan':
        return Icons.map;
      default:
        return Icons.approval;
    }
  }

  Widget _buildQuickActions(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ActionChip(
          avatar: const Icon(Icons.people, size: 18),
          label: const Text('View Team'),
          onPressed: () => context.go('/manager/team'),
        ),
        ActionChip(
          avatar: const Icon(Icons.approval, size: 18),
          label: const Text('Approvals'),
          onPressed: () => context.go('/manager/approvals'),
        ),
        ActionChip(
          avatar: const Icon(Icons.bar_chart, size: 18),
          label: const Text('Reports'),
          onPressed: () => context.go('/manager/reports'),
        ),
        ActionChip(
          avatar: const Icon(Icons.track_changes, size: 18),
          label: const Text('Assign Targets'),
          onPressed: () => context.push('/admin/targets/assign'),
        ),
        ActionChip(
          avatar: const Icon(Icons.science, size: 18),
          label: const Text('Allocate Samples'),
          onPressed: () => context.push('/admin/samples/allocate'),
        ),
      ],
    );
  }
}
