import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/providers/user_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart';
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/error_retry_card.dart';
import '../../presentation/widgets/shimmer_loading.dart';

final _userNamesProvider = FutureProvider<Map<String, String>>((ref) async {
  final users = await ref.watch(userRepositoryProvider).getAllUsers();
  return {for (final u in users) u.id: u.name};
});

class ApprovalQueueScreen extends ConsumerWidget {
  const ApprovalQueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingApprovalsProvider);
    final userNames = ref.watch(_userNamesProvider).value ?? {};

    return Scaffold(
      appBar: AppBar(title: const Text('Approval Queue')),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: adaptiveMaxWidth(context),
          padding: adaptivePadding(context),
          child: RefreshIndicator(
            onRefresh: () async => ref.invalidate(pendingApprovalsProvider),
            child: pendingAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: const EmptyState(
                          icon: Icons.check_circle_outline,
                          title: 'No pending approvals',
                          subtitle: "You're all caught up!",
                        ),
                      ),
                    ],
                  );
                }
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final a = items[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.orange.withValues(alpha: 0.15),
                          child: Icon(_iconForType(a.type),
                              color: Colors.orange),
                        ),
                        title: Text('${_labelForType(a.type)} Approval',
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(
                            'From: ${userNames[a.requesterId] ?? a.requesterId}\n${DateFormat.yMMMd().format(a.createdAt)}'),
                        isThreeLine: true,
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          final currentPath = GoRouterState.of(context).uri.toString();
                          final prefix = currentPath.startsWith('/manager')
                              ? '/manager'
                              : '/admin';
                          context.go('$prefix/approvals/${a.id}');
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
                      onRetry: () => ref.invalidate(pendingApprovalsProvider),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconForType(ApprovalEntityType type) {
    switch (type) {
      case ApprovalEntityType.expense:
        return Icons.receipt;
      case ApprovalEntityType.tourPlan:
        return Icons.calendar_month;
      case ApprovalEntityType.leave:
        return Icons.event_busy;
      case ApprovalEntityType.order:
        return Icons.shopping_cart;
      case ApprovalEntityType.sample:
        return Icons.science;
    }
  }

  String _labelForType(ApprovalEntityType type) {
    switch (type) {
      case ApprovalEntityType.expense:
        return 'Expense';
      case ApprovalEntityType.tourPlan:
        return 'Tour Plan';
      case ApprovalEntityType.leave:
        return 'Leave';
      case ApprovalEntityType.order:
        return 'Order';
      case ApprovalEntityType.sample:
        return 'Sample';
    }
  }
}
