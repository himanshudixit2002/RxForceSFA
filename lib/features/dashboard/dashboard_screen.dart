import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/core_providers.dart';
import '../../core/providers/user_providers.dart';
import '../../core/services/sync_service.dart';
import '../../core/utils/responsive.dart';
import 'widgets/pending_sync_badge.dart';
import 'widgets/recommended_visits_widget.dart';
import 'widgets/tour_program_card.dart';

final _todayDcrCountProvider = StreamProvider<int>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return Stream.value(0);
  return ref.watch(dcrRepositoryProvider).watchByMr(uid).map((list) {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    return list.where((d) => !d.createdAt.isBefore(start)).length;
  });
});

final _monthlyOrderCountProvider = StreamProvider<int>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return Stream.value(0);
  return ref.watch(orderRepositoryProvider).watchForMr(uid).map((list) {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    return list.where((o) => !o.orderDate.isBefore(monthStart)).length;
  });
});

final _pendingApprovalCountProvider = StreamProvider<int>((ref) {
  final count = ref.watch(pendingApprovalsProvider).value?.length ?? 0;
  return Stream.value(count);
});

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _isSyncing = false;

  Future<void> _syncNow() async {
    if (_isSyncing) return;
    setState(() => _isSyncing = true);
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(const SnackBar(content: Text('Syncing...')));
    try {
      await SyncService.syncNow();
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(const SnackBar(content: Text('Sync complete')));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(const SnackBar(content: Text('Sync failed')));
      }
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  Future<void> _confirmSignOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text(
          'Are you sure? Unsynced data will be uploaded next time you sign in.',
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
    if (confirmed == true && mounted) {
      try {
        await SyncService.performSync();
      } catch (_) {}
      try {
        await ref.read(firebaseAuthProvider).signOut();
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Sign out failed. Please try again.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authStateProvider);
    final user = authState.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RxForce SFA'),
        actions: [
          const PendingSyncBadge(),
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isSyncing
                  ? SizedBox(
                      key: const ValueKey('syncing'),
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.primary,
                      ),
                    )
                  : const Icon(Icons.sync, key: ValueKey('sync')),
            ),
            tooltip: 'Sync Now',
            onPressed: _isSyncing ? null : _syncNow,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: _confirmSignOut,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _syncNow,
        child: ResponsiveBuilder(
          builder: (context, screenType) {
            if (screenType == ScreenType.compact) {
              return _CompactDashboard(user: user, theme: theme);
            }
            return _WideDashboard(
              user: user,
              theme: theme,
              screenType: screenType,
            );
          },
        ),
      ),
    );
  }
}

class _CompactDashboard extends ConsumerWidget {
  final User? user;
  final ThemeData theme;

  const _CompactDashboard({this.user, required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _GreetingCard(user: user),
        const SizedBox(height: 16),
        _KpiRow(ref: ref),
        const SizedBox(height: 16),
        const RecommendedVisitsWidget(),
        const SizedBox(height: 16),
        TourProgramCard(mrId: user?.uid ?? ''),
        const SizedBox(height: 24),
        Text(
          'Quick Actions',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        const _QuickActionsGrid(),
      ],
    );
  }
}

class _KpiRow extends StatelessWidget {
  final WidgetRef ref;
  const _KpiRow({required this.ref});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final todayCalls = ref.watch(_todayDcrCountProvider).value ?? 0;
    final monthOrders = ref.watch(_monthlyOrderCountProvider).value ?? 0;
    final pendingApprovals = ref.watch(_pendingApprovalCountProvider).value ?? 0;

    return Row(
      children: [
        Expanded(child: _MiniKpi(label: "Today's Calls", value: '$todayCalls', icon: Icons.phone_in_talk, color: Colors.blue, theme: theme, onTap: () => context.go('/dcr'))),
        const SizedBox(width: 8),
        Expanded(child: _MiniKpi(label: 'Monthly Orders', value: '$monthOrders', icon: Icons.shopping_bag, color: Colors.green, theme: theme, onTap: () => context.go('/orders'))),
        const SizedBox(width: 8),
        Expanded(child: _MiniKpi(label: 'Pending', value: '$pendingApprovals', icon: Icons.pending_actions, color: Colors.orange, theme: theme, onTap: () => context.go('/more'))),
      ],
    );
  }
}

class _MiniKpi extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final ThemeData theme;
  final VoidCallback? onTap;
  const _MiniKpi({required this.label, required this.value, required this.icon, required this.color, required this.theme, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 4),
              Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}

class _WideDashboard extends ConsumerWidget {
  final User? user;
  final ThemeData theme;
  final ScreenType screenType;

  const _WideDashboard({
    this.user,
    required this.theme,
    required this.screenType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: adaptivePadding(context),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: adaptiveMaxWidth(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _GreetingCard(user: user),
              const SizedBox(height: 16),
              _KpiRow(ref: ref),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        const RecommendedVisitsWidget(),
                        const SizedBox(height: 16),
                        TourProgramCard(mrId: user?.uid ?? ''),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Quick Actions',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _QuickActionTile(
                          icon: Icons.mic,
                          label: 'New DCR',
                          subtitle: 'Voice call report',
                          color: theme.colorScheme.primary,
                          onTap: () => context.push('/dcr/record'),
                        ),
                        const SizedBox(height: 8),
                        _QuickActionTile(
                          icon: Icons.receipt_long,
                          label: 'Log Expense',
                          subtitle: 'Log expense',
                          color: theme.colorScheme.tertiary,
                          onTap: () => context.push('/expense/capture'),
                        ),
                        const SizedBox(height: 8),
                        _QuickActionTile(
                          icon: Icons.route,
                          label: 'Optimize Route',
                          subtitle: 'Plan visit route',
                          color: theme.colorScheme.secondary,
                          onTap: () => context.push('/route'),
                        ),
                        const SizedBox(height: 8),
                        _QuickActionTile(
                          icon: Icons.people_outlined,
                          label: 'Doctors',
                          subtitle: 'View all doctors',
                          color: theme.colorScheme.primary,
                          onTap: () => context.go('/doctors'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GreetingCard extends StatelessWidget {
  final User? user;
  const _GreetingCard({this.user});

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                (user?.displayName ?? user?.email ?? 'M')[0].toUpperCase(),
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_greeting,',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    user?.displayName ?? user?.email ?? 'Medical Rep',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final columns = adaptiveGridColumns(context);

    return GridView.count(
      crossAxisCount: columns.clamp(2, 4),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _ActionCard(
          icon: Icons.mic,
          label: 'New DCR',
          color: theme.colorScheme.primary,
          onTap: () => context.push('/dcr/record'),
        ),
        _ActionCard(
          icon: Icons.receipt_long,
          label: 'Log Expense',
          color: theme.colorScheme.tertiary,
          onTap: () => context.push('/expense/capture'),
        ),
        _ActionCard(
          icon: Icons.route,
          label: 'Optimize\nRoute',
          color: theme.colorScheme.secondary,
          onTap: () => context.push('/route'),
        ),
        _ActionCard(
          icon: Icons.people_outlined,
          label: 'Doctors',
          color: theme.colorScheme.primary,
          onTap: () => context.go('/doctors'),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                style: theme.textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
