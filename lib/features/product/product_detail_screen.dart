import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/core_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart';
import '../../presentation/widgets/shimmer_loading.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  Product? _product;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final p = await ref.read(productRepositoryProvider).getById(widget.productId);
      if (mounted) setState(() { _product = p; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = e.toString(); });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product')),
        body: const ShimmerLoading(itemCount: 5),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
              const SizedBox(height: 12),
              const Text('Failed to load product'),
              const SizedBox(height: 16),
              FilledButton.tonal(onPressed: _load, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    if (_product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product')),
        body: const Center(child: Text('Product not found')),
      );
    }

    final p = _product!;
    return Scaffold(
      appBar: AppBar(
        title: Text(p.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Product',
            onPressed: () => context.push('/admin/products/${p.id}'),
          ),
        ],
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          padding: adaptivePadding(context),
          child: ListView(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Hero(
                            tag: 'product-avatar-${p.id}',
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: theme.colorScheme.primaryContainer,
                              child: Icon(Icons.medication, size: 32,
                                  color: theme.colorScheme.onPrimaryContainer),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.name,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold)),
                                Text('SKU: ${p.sku}',
                                    style: theme.textTheme.bodySmall),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      _InfoRow('Category', p.category),
                      _InfoRow('Division', p.division),
                      _InfoRow('Price', '\u20B9${p.price.toStringAsFixed(2)}'),
                      _InfoRow('Status', p.isActive ? 'Active' : 'Inactive'),
                      if (p.description.isNotEmpty)
                        _InfoRow('Description', p.description),
                    ],
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

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
