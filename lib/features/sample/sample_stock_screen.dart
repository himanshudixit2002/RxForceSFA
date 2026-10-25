import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/core_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart';
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/error_retry_card.dart';
import '../../presentation/widgets/shimmer_loading.dart';

final _stockProvider = StreamProvider<List<StockLedger>>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return Stream.value([]);
  return ref.watch(sampleRepositoryProvider).watchStock(uid);
});

final _productsMapProvider = FutureProvider<Map<String, String>>((ref) async {
  final products = await ref.watch(productRepositoryProvider).getAll();
  return {for (final p in products) p.id: p.name};
});

class SampleStockScreen extends ConsumerWidget {
  const SampleStockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockAsync = ref.watch(_stockProvider);
    final productNames = ref.watch(_productsMapProvider).value ?? {};

    return Scaffold(
      appBar: AppBar(title: const Text('Sample Stock')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/samples/distribute'),
        icon: const Icon(Icons.send),
        label: const Text('Distribute'),
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: adaptiveMaxWidth(context),
          padding: adaptivePadding(context),
          child: RefreshIndicator(
            onRefresh: () async => ref.invalidate(_stockProvider),
            child: stockAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: const EmptyState(
                          icon: Icons.inventory_outlined,
                          title: 'No stock data',
                        ),
                      ),
                    ],
                  );
                }
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final s = items[i];
                    final productName = productNames[s.productId] ?? s.productId;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(productName,
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _StockChip('Opening', s.openingStock, Colors.blue),
                                const SizedBox(width: 8),
                                _StockChip('Received', s.received, Colors.green),
                                const SizedBox(width: 8),
                                _StockChip('Distributed', s.distributed, Colors.orange),
                                const SizedBox(width: 8),
                                _StockChip('Closing', s.closingStock, Colors.purple),
                              ],
                            ),
                          ],
                        ),
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
                      onRetry: () => ref.invalidate(_stockProvider),
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

class _StockChip extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _StockChip(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text('$value',
                style: TextStyle(fontWeight: FontWeight.bold, color: color)),
            Text(label, style: TextStyle(fontSize: 10, color: color)),
          ],
        ),
      ),
    );
  }
}
