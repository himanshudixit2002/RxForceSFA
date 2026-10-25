import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/providers/core_providers.dart';
import '../../core/providers/user_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart';
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/error_retry_card.dart';
import '../../presentation/widgets/shimmer_loading.dart';

final _campaignsProvider = StreamProvider<List<Campaign>>((ref) {
  return ref.watch(campaignRepositoryProvider).watchAll();
});

class CampaignListScreen extends ConsumerWidget {
  const CampaignListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campaignsAsync = ref.watch(_campaignsProvider);
    final role = ref.watch(currentUserRoleProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Campaigns')),
      floatingActionButton: role.isAdmin ? FloatingActionButton.extended(
        onPressed: () => context.push('/admin/campaigns/create'),
        icon: const Icon(Icons.add),
        label: const Text('New Campaign'),
      ) : null,
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: adaptiveMaxWidth(context),
          padding: adaptivePadding(context),
          child: RefreshIndicator(
            onRefresh: () async => ref.invalidate(_campaignsProvider),
            child: campaignsAsync.when(
              data: (campaigns) {
                if (campaigns.isEmpty) {
                  return CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: const EmptyState(
                          icon: Icons.campaign_outlined,
                          title: 'No campaigns',
                        ),
                      ),
                    ],
                  );
                }
                return ListView.builder(
                  itemCount: campaigns.length,
                  itemBuilder: (context, i) {
                    final c = campaigns[i];
                    final isActive = c.status == 'active';
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isActive
                              ? Colors.green.withValues(alpha: 0.15)
                              : Colors.grey.withValues(alpha: 0.15),
                          child: Icon(Icons.campaign,
                              color: isActive ? Colors.green : Colors.grey),
                        ),
                        title: Text(c.name,
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(
                            '${DateFormat.yMMMd().format(c.startDate)} - ${DateFormat.yMMMd().format(c.endDate)}'),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: (isActive ? Colors.green : Colors.grey)
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            c.status.toUpperCase(),
                            style: TextStyle(
                              color: isActive ? Colors.green : Colors.grey,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        onTap: () => context.go('/campaigns/${c.id}'),
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
                      onRetry: () => ref.invalidate(_campaignsProvider),
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
}
