import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/user_providers.dart';
import '../../core/utils/responsive.dart';
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/error_retry_card.dart';
import '../../presentation/widgets/shimmer_loading.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final usersAsync = ref.watch(allUsersProvider);
    final pendingApprovals = ref.watch(pendingApprovalsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 32),
            const SizedBox(width: 12),
            const Text('Admin Dashboard'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.go('/notifications'),
          ),
        ],
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: adaptiveMaxWidth(context),
          padding: adaptivePadding(context),
          child: ListView(
            children: [
              _buildKpiRow(
                context,
                usersAsync.value?.length ?? 0,
                pendingApprovals.value?.length ?? 0,
                ref,
              ),
              const SizedBox(height: 24),
              Text('Quick Actions',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildQuickActions(context),
              const SizedBox(height: 24),
              Text('Pending Approvals',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildPendingApprovalsList(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKpiRow(BuildContext context, int userCount, int pendingCount, WidgetRef ref) {
    final activeMrs = ref.watch(allUsersProvider).value
        ?.where((u) => u.role == 'mr' && u.isActive)
        .length ?? 0;
    return Row(
      children: [
        Expanded(child: _KpiCard(label: 'Total Users', value: '$userCount', icon: Icons.people, color: Colors.blue)),
        const SizedBox(width: 12),
        Expanded(child: _KpiCard(label: 'Pending Approvals', value: '$pendingCount', icon: Icons.pending_actions, color: Colors.orange)),
        const SizedBox(width: 12),
        Expanded(child: _KpiCard(label: 'Active MRs', value: '$activeMrs', icon: Icons.badge, color: Colors.green)),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _QuickActionChip(
            icon: Icons.person_add,
            label: 'Add User',
            onTap: () => context.push('/admin/users/new')),
        _QuickActionChip(
            icon: Icons.map,
            label: 'Territories',
            onTap: () => context.push('/admin/territories')),
        _QuickActionChip(
            icon: Icons.inventory_2,
            label: 'Products',
            onTap: () => context.push('/admin/products')),
        _QuickActionChip(
            icon: Icons.track_changes,
            label: 'Targets',
            onTap: () => context.push('/admin/targets')),
        _QuickActionChip(
            icon: Icons.campaign,
            label: 'Campaigns',
            onTap: () => context.push('/admin/campaigns')),
        _QuickActionChip(
            icon: Icons.add_box,
            label: 'New Product',
            onTap: () => context.push('/admin/products/create')),
        _QuickActionChip(
            icon: Icons.campaign_outlined,
            label: 'New Campaign',
            onTap: () => context.push('/admin/campaigns/create')),
        _QuickActionChip(
            icon: Icons.track_changes,
            label: 'Assign Target',
            onTap: () => context.push('/admin/targets/assign')),
        _QuickActionChip(
            icon: Icons.science,
            label: 'Allocate Samples',
            onTap: () => context.push('/admin/samples/allocate')),
      ],
    );
  }

  Widget _buildPendingApprovalsList(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(pendingApprovalsProvider);
    return pending.when(
      data: (items) {
        if (items.isEmpty) {
          return const EmptyState(
            icon: Icons.approval,
            title: 'No pending approvals',
            subtitle: 'All caught up!',
          );
        }
        return Column(
          children: items.take(5).map((a) => Card(
                child: ListTile(
                  leading: const Icon(Icons.approval),
                  title: Text('${a.type.name} approval'),
                  subtitle: Text('From: ${a.requesterId}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/admin/approvals/${a.id}'),
                ),
              )).toList(),
        );
      },
      loading: () => const ShimmerLoading(itemCount: 3),
      error: (e, _) => ErrorRetryCard(
        message: e.toString(),
        onRetry: () => ref.invalidate(pendingApprovalsProvider),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
    );
  }
}
