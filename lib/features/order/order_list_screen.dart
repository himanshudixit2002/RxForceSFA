import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/providers/core_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart';
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/error_retry_card.dart';
import '../../presentation/widgets/shimmer_loading.dart';

final _ordersProvider = StreamProvider<List<Order>>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return Stream.value([]);
  return ref.watch(orderRepositoryProvider).watchForMr(uid);
});

class OrderListScreen extends ConsumerStatefulWidget {
  const OrderListScreen({super.key});

  @override
  ConsumerState<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends ConsumerState<OrderListScreen> {
  String? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(_ordersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/orders/create'),
        icon: const Icon(Icons.add),
        label: const Text('New Order'),
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: adaptiveMaxWidth(context),
          padding: adaptivePadding(context),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: _selectedStatus == null,
                      onSelected: (_) => setState(() => _selectedStatus = null),
                    ),
                    const SizedBox(width: 8),
                    ...OrderStatus.values.map((v) => v.name).map(
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
                  onRefresh: () async => ref.invalidate(_ordersProvider),
                  child: ordersAsync.when(
                    data: (orders) {
                      final filtered = _selectedStatus == null
                          ? orders
                          : orders.where((o) => o.status.name == _selectedStatus).toList();
                      if (filtered.isEmpty) {
                        return CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: const EmptyState(
                                icon: Icons.shopping_cart_outlined,
                                title: 'No orders yet',
                              ),
                            ),
                          ],
                        );
                      }
                      return ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final o = filtered[i];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: Hero(
                                tag: 'order-avatar-${o.id}',
                                child: CircleAvatar(
                                  backgroundColor:
                                      _statusColor(o.status).withValues(alpha: 0.15),
                                  child: Icon(Icons.receipt,
                                      color: _statusColor(o.status)),
                                ),
                              ),
                              title: Text('\u20B9${o.totalAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(fontWeight: FontWeight.w600)),
                              subtitle: Text(
                                  '${DateFormat.yMMMd().format(o.orderDate)} \u2022 ${o.status.name}'),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => context.go('/orders/${o.id}'),
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
                            onRetry: () => ref.invalidate(_ordersProvider),
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

  Color _statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.draft:
        return Colors.grey;
      case OrderStatus.submitted:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.dispatched:
        return Colors.purple;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }
}
