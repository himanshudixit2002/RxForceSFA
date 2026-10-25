import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/providers/core_providers.dart';
import '../../core/utils/responsive.dart';
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/error_retry_card.dart';
import '../../presentation/widgets/shimmer_loading.dart';

final _tourPlansProvider = StreamProvider<List>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return Stream.value([]);
  return ref.watch(tourPlanRepositoryProvider).watchPlansForMr(uid);
});

class TourPlanListScreen extends ConsumerStatefulWidget {
  const TourPlanListScreen({super.key});

  @override
  ConsumerState<TourPlanListScreen> createState() =>
      _TourPlanListScreenState();
}

class _TourPlanListScreenState extends ConsumerState<TourPlanListScreen> {
  String? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    final plansAsync = ref.watch(_tourPlansProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Tour Plans')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/tour-plan/create'),
        icon: const Icon(Icons.add),
        label: const Text('New Plan'),
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: adaptiveMaxWidth(context),
          padding: adaptivePadding(context),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16, right: 24, top: 8, bottom: 8),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: _selectedStatus == null,
                      onSelected: (_) => setState(() => _selectedStatus = null),
                    ),
                    const SizedBox(width: 8),
                    ...<String>['draft', 'approved', 'active', 'completed'].map(
                      (s) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(s[0].toUpperCase() + s.substring(1)),
                          selected: _selectedStatus == s,
                          onSelected: (_) => setState(() => _selectedStatus = s),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => ref.invalidate(_tourPlansProvider),
                  child: plansAsync.when(
                    data: (plans) {
                      final filtered = _selectedStatus == null
                          ? plans
                          : plans.where((p) => p.status == _selectedStatus).toList();
                      if (filtered.isEmpty) {
                        return CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: const EmptyState(
                                icon: Icons.calendar_month,
                                title: 'No tour plans yet',
                                subtitle: 'Create your monthly tour plan',
                              ),
                            ),
                          ],
                        );
                      }
                      return ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final plan = filtered[i];
                          final monthName = DateFormat.MMMM().format(
                              DateTime(plan.year, plan.month));
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    _statusColor(plan.status).withValues(alpha: 0.15),
                                child: Icon(Icons.calendar_today,
                                    color: _statusColor(plan.status)),
                              ),
                              title: Text('$monthName ${plan.year}',
                                  style: const TextStyle(fontWeight: FontWeight.w600)),
                              subtitle: Text('Status: ${plan.status}'),
                              trailing: _StatusChip(status: plan.status),
                              onTap: () => context.go('/tour-plan/${plan.id}'),
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
                            onRetry: () => ref.invalidate(_tourPlansProvider),
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

  Color _statusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'submitted':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'approved':
        color = Colors.green;
        break;
      case 'rejected':
        color = Colors.red;
        break;
      case 'submitted':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
            color: color, fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }
}
