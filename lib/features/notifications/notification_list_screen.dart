import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/providers/core_providers.dart';
import '../../core/providers/user_providers.dart';
import '../../core/services/notification_service.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart' as db;
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/error_retry_card.dart';
import '../../presentation/widgets/shimmer_loading.dart';

final _notificationsProvider = StreamProvider<List<db.Notification>>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return Stream.value([]);
  return ref.watch(notificationRepositoryProvider).watchForUser(uid);
});

class NotificationListScreen extends ConsumerStatefulWidget {
  const NotificationListScreen({super.key});

  @override
  ConsumerState<NotificationListScreen> createState() =>
      _NotificationListScreenState();
}

class _NotificationListScreenState
    extends ConsumerState<NotificationListScreen> {
  bool _showUnreadOnly = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notifsAsync = ref.watch(_notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {
              final uid = ref.read(authStateProvider).value?.uid;
              if (uid != null) {
                ref.read(notificationRepositoryProvider).markAllRead(uid);
              }
            },
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: adaptiveMaxWidth(context),
          padding: adaptivePadding(context),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: false, label: Text('All')),
                    ButtonSegment(value: true, label: Text('Unread')),
                  ],
                  selected: {_showUnreadOnly},
                  onSelectionChanged: (s) =>
                      setState(() => _showUnreadOnly = s.first),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async =>
                      ref.invalidate(_notificationsProvider),
                  child: notifsAsync.when(
                    data: (notifs) {
                      final filtered = _showUnreadOnly
                          ? notifs.where((n) => !n.isRead).toList()
                          : notifs;
                      if (filtered.isEmpty) {
                        return CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: const EmptyState(
                                icon: Icons.notifications_none,
                                title: 'No notifications',
                              ),
                            ),
                          ],
                        );
                      }
                      return ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final n = filtered[i];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 4),
                            color: n.isRead
                                ? null
                                : theme.colorScheme.primaryContainer
                                    .withValues(alpha: 0.3),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: n.isRead
                                    ? theme.colorScheme.surfaceContainerHighest
                                    : theme.colorScheme.primary
                                        .withValues(alpha: 0.15),
                                child: Icon(
                                  _iconForType(n.type),
                                  color: n.isRead
                                      ? theme.colorScheme.onSurfaceVariant
                                      : theme.colorScheme.primary,
                                  size: 20,
                                ),
                              ),
                              title: Text(n.title,
                                  style: TextStyle(
                                      fontWeight: n.isRead
                                          ? FontWeight.normal
                                          : FontWeight.w600)),
                              subtitle: Text(
                                  '${n.body}\n${DateFormat.yMMMd().add_jm().format(n.createdAt)}'),
                              isThreeLine: true,
                              onTap: () {
                                if (!n.isRead) {
                                  ref
                                      .read(notificationRepositoryProvider)
                                      .markRead(n.id);
                                }
                                final route =
                                    NotificationService.routeForNotification(
                                        n.type, n.referenceId);
                                context.push(route);
                              },
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const ShimmerLoading(),
                    error: (e, _) => CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: ErrorRetryCard(
                            message: e.toString(),
                            onRetry: () =>
                                ref.invalidate(_notificationsProvider),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForType(db.NotificationType type) {
    switch (type) {
      case db.NotificationType.approvalRequest:
        return Icons.pending_actions;
      case db.NotificationType.approvalResult:
        return Icons.check_circle;
      case db.NotificationType.reminder:
        return Icons.alarm;
      case db.NotificationType.alert:
        return Icons.warning;
      case db.NotificationType.system:
        return Icons.settings;
    }
  }
}
