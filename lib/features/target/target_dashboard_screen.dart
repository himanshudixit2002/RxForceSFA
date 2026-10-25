import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/core_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart';
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/error_retry_card.dart';
import '../../presentation/widgets/shimmer_loading.dart';

final _targetsProvider = StreamProvider<List<Target>>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return Stream.value([]);
  return ref.watch(targetRepositoryProvider).watchForMr(uid);
});

final _productNamesProvider = FutureProvider<Map<String, String>>((ref) async {
  final products = await ref.watch(productRepositoryProvider).getAll();
  return {for (final p in products) p.id: p.name};
});

class TargetDashboardScreen extends ConsumerWidget {
  const TargetDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final targetsAsync = ref.watch(_targetsProvider);
    final productNames = ref.watch(_productNamesProvider).value ?? {};

    return Scaffold(
      appBar: AppBar(title: const Text('Targets')),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: adaptiveMaxWidth(context),
          padding: adaptivePadding(context),
          child: RefreshIndicator(
            onRefresh: () async => ref.invalidate(_targetsProvider),
            child: targetsAsync.when(
              data: (targets) {
                if (targets.isEmpty) {
                  return CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: const EmptyState(
                          icon: Icons.track_changes_outlined,
                          title: 'No targets assigned',
                        ),
                      ),
                    ],
                  );
                }
                return ListView(
                  children: [
                    _buildOverallProgress(targets, theme),
                    const SizedBox(height: 16),
                    ...targets.map((t) => _buildTargetCard(t, theme, productNames)),
                  ],
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
                      onRetry: () => ref.invalidate(_targetsProvider),
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

  Widget _buildOverallProgress(List<Target> targets, ThemeData theme) {
    final totalTarget = targets.fold(0.0, (s, t) => s + t.targetValue);
    final totalAchieved = targets.fold(0.0, (s, t) => s + t.achievedValue);
    final pct = totalTarget > 0 ? (totalAchieved / totalTarget) : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Overall Achievement',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              width: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: CircularProgressIndicator(
                      value: pct.clamp(0, 1).toDouble(),
                      strokeWidth: 10,
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      color: pct >= 1 ? Colors.green : theme.colorScheme.primary,
                    ),
                  ),
                  Text('${(pct * 100).toStringAsFixed(0)}%',
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetCard(Target t, ThemeData theme, Map<String, String> productNames) {
    final pct =
        t.targetValue > 0 ? t.achievedValue / t.targetValue : 0.0;
    final color = pct >= 1
        ? Colors.green
        : pct >= 0.5
            ? Colors.orange
            : Colors.red;
    final productLabel = productNames[t.productId];
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (productLabel != null && productLabel.isNotEmpty)
                        Text(productLabel, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                      Text(t.period,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Text('${(pct * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                        color: color, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: pct.clamp(0, 1).toDouble(),
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              color: color,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              'Target: \u20B9${t.targetValue.toStringAsFixed(0)} | Achieved: \u20B9${t.achievedValue.toStringAsFixed(0)}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
