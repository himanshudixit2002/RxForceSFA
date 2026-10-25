import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/core_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart';
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/error_retry_card.dart';
import '../../presentation/widgets/shimmer_loading.dart';

final _productsProvider = StreamProvider<List<Product>>((ref) {
  return ref.watch(productRepositoryProvider).watchAll();
});

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final productsAsync = ref.watch(_productsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/admin/products/create'),
        icon: const Icon(Icons.add),
        label: const Text('New Product'),
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: adaptiveMaxWidth(context),
          padding: adaptivePadding(context),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  isDense: true,
                ),
                onChanged: (v) => setState(() => _search = v),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: productsAsync.when(
                  data: (products) {
                    var filtered = products;
                    if (_search.isNotEmpty) {
                      final q = _search.toLowerCase();
                      filtered = filtered
                          .where((p) =>
                              p.name.toLowerCase().contains(q) ||
                              p.category.toLowerCase().contains(q) ||
                              p.sku.toLowerCase().contains(q))
                          .toList();
                    }
                    if (filtered.isEmpty) {
                      return const EmptyState(
                        icon: Icons.inventory_2_outlined,
                        title: 'No products found',
                      );
                    }
                    return ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, i) {
                        final p = filtered[i];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Hero(
                              tag: 'product-avatar-${p.id}',
                              child: CircleAvatar(
                                backgroundColor:
                                    theme.colorScheme.secondaryContainer,
                                child: Icon(Icons.medication,
                                    color: theme.colorScheme.onSecondaryContainer),
                              ),
                            ),
                            title: Text(p.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                            subtitle: Text(
                                '${p.category} \u2022 ${p.sku} \u2022 \u20B9${p.price.toStringAsFixed(2)}'),
                            trailing: p.isActive
                                ? const Icon(Icons.check_circle,
                                    color: Colors.green, size: 20)
                                : const Icon(Icons.cancel,
                                    color: Colors.red, size: 20),
                            onTap: () => context.go('/products/${p.id}'),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const ShimmerLoading(),
                  error: (e, _) => ErrorRetryCard(
                    message: e.toString(),
                    onRetry: () => ref.invalidate(_productsProvider),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
