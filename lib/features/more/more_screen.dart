import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/user_role.dart';
import '../../core/providers/core_providers.dart';
import '../../core/providers/user_providers.dart';
import '../../core/services/sync_service.dart';
import '../../core/utils/responsive.dart';
import '../../presentation/widgets/shimmer_loading.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profileAsync = ref.watch(currentUserProfileProvider);
    final role = ref.watch(currentUserRoleProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: adaptiveMaxWidth(context)),
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: profileAsync.when(
              loading: () => const ShimmerLoading(height: 80),
              error: (_, __) => const SizedBox.shrink(),
              data: (profile) {
                if (profile == null) return const SizedBox.shrink();
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => context.push('/profile'),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: theme.colorScheme.primaryContainer,
                            child: Text(
                              profile.name.isNotEmpty
                                  ? profile.name[0].toUpperCase()
                                  : '?',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                  color: theme.colorScheme.onPrimaryContainer),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(profile.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold)),
                                Text('${profile.email} \u2022 ${role.label}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodySmall),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right,
                              color: theme.colorScheme.onSurfaceVariant),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (role.isAdmin)
            _buildSection(context, 'Dashboard', [
              _MenuItem(Icons.admin_panel_settings, 'Admin Dashboard', () => context.push('/admin/dashboard')),
            ]),
          if (role.isManager && !role.isAdmin)
            _buildSection(context, 'Dashboard', [
              _MenuItem(Icons.supervisor_account, 'Manager Dashboard', () => context.push('/manager/dashboard')),
            ]),
          _buildSection(context, 'Field Operations', [
            _MenuItem(Icons.check_circle_outline, 'Attendance', () => context.push('/attendance')),
            _MenuItem(Icons.history, 'Attendance History', () => context.push('/attendance/history')),
            _MenuItem(Icons.receipt_long, 'Expenses', () => context.push('/expenses')),
            _MenuItem(Icons.route, 'Route Optimizer', () => context.push('/route')),
            _MenuItem(Icons.event_busy, 'Leave', () => context.push('/leave')),
            _MenuItem(Icons.person_add, 'Add Doctor', () => context.push('/doctors/new')),
          ]),
          _buildSection(context, 'Products & Samples', [
            _MenuItem(Icons.inventory_2, 'Products', () => context.push('/products')),
            _MenuItem(Icons.science, 'Samples', () => context.push('/samples')),
            _MenuItem(Icons.shopping_cart, 'Orders', () => context.push('/orders')),
          ]),
          if (role.canManageUsers)
            _buildSection(context, 'Administration', [
              _MenuItem(Icons.people, 'Users', () => context.push('/admin/users')),
              _MenuItem(Icons.map, 'Territories', () => context.push('/admin/territories')),
            ]),
          _buildSection(context, 'Targets & Assignments', [
            _MenuItem(Icons.track_changes, 'Targets', () => context.push('/targets')),
            if (role.canAssignTargets)
              _MenuItem(Icons.track_changes, 'Assign Targets', () => context.push('/admin/targets/assign')),
            if (role.canAllocateSamples)
              _MenuItem(Icons.science, 'Allocate Samples', () => context.push('/admin/samples/allocate')),
          ]),
          _buildSection(context, 'Content & Campaigns', [
            _MenuItem(Icons.slideshow, 'E-Detailing', () => context.push('/edetail')),
            _MenuItem(Icons.campaign, 'Campaigns', () => context.push('/campaigns')),
          ]),
          _buildSection(context, 'Analytics', [
            if (role.canViewAllReports)
              _MenuItem(Icons.bar_chart, 'Reports', () => context.push('/reports')),
            if (role.canApprove)
              _MenuItem(Icons.approval, 'Approvals', () => context.push(
                  role.isAdmin ? '/admin/approvals' : '/manager/approvals')),
          ]),
          _buildSection(context, 'Account', [
            _MenuItem(Icons.person, 'My Profile', () => context.push('/profile')),
            _MenuItem(Icons.notifications, 'Notifications', () => context.push('/notifications')),
            _MenuItem(Icons.logout, 'Logout', () => _confirmSignOut(context, ref)),
          ]),
        ],
      ),
        ),
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: Text(
          kIsWeb
              ? 'Are you sure you want to sign out?'
              : 'Are you sure? Your data will be synced before signing out.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      if (!kIsWeb) {
        try {
          await SyncService.performSync();
        } catch (_) {}
      }
      try {
        await ref.read(firebaseAuthProvider).signOut();
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign out failed. Please try again.')),
          );
        }
      }
    }
  }

  Widget _buildSection(
      BuildContext context, String title, List<_MenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold)),
        ),
        ...items.map((item) => ListTile(
              leading: Icon(item.icon),
              title: Text(item.label),
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: item.onTap,
            )),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MenuItem(this.icon, this.label, this.onTap);
}
