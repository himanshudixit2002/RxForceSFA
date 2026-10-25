import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/providers/core_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart';
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/shimmer_loading.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  Order? _order;
  bool _loading = true;
  bool _processing = false;
  String _doctorName = '';
  Map<String, String> _productNames = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final order = await ref.read(orderRepositoryProvider).getById(widget.orderId);
    String doctorName = order?.doctorId ?? '';
    if (order != null) {
      final doctor = await ref.read(doctorRepositoryProvider).getById(order.doctorId);
      if (doctor != null) doctorName = doctor.name;
    }
    final products = await ref.read(productRepositoryProvider).getAll();
    final pMap = {for (final p in products) p.id: p.name};
    if (mounted) setState(() { _order = order; _doctorName = doctorName; _productNames = pMap; _loading = false; });
  }

  Future<void> _updateStatus(OrderStatus status) async {
    if (_order == null) return;
    setState(() => _processing = true);
    try {
      await ref.read(orderRepositoryProvider).updateStatus(_order!.id, status);
      await _load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order ${status.name}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong. Please try again.')));
      }
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Detail')),
        body: const ShimmerLoading(itemCount: 5),
      );
    }
    if (_order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Detail')),
        body: const Center(child: Text('Order not found')),
      );
    }

    final o = _order!;
    final itemsStream = ref.watch(orderRepositoryProvider).watchItems(o.id);

    return Scaffold(
      appBar: AppBar(title: Text('Order #${o.id.substring(0, 8)}')),
      body: SafeArea(
        child: ResponsiveCenter(
          padding: adaptivePadding(context),
          child: ListView(
            children: [
              _StatusTimeline(status: o.status, theme: theme),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _row(context, 'Order Date', DateFormat.yMMMd().format(o.orderDate)),
                      _row(context, 'Doctor', _doctorName),
                      _row(context, 'Status', o.status.name.toUpperCase()),
                      _row(context, 'Total', '\u20B9${o.totalAmount.toStringAsFixed(2)}'),
                      if (o.deliveryDate != null)
                        _row(context, 'Delivery', DateFormat.yMMMd().format(o.deliveryDate!)),
                      if (o.notes.isNotEmpty) _row(context, 'Notes', o.notes),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Items', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              StreamBuilder<List<OrderItem>>(
                stream: itemsStream,
                builder: (context, snap) {
                  if (!snap.hasData) return const ShimmerLoading(itemCount: 3);
                  final items = snap.data!;
                  if (items.isEmpty) return const EmptyState(icon: Icons.receipt_long, title: 'No items in this order');
                  return Column(
                    children: items.map((item) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.medication),
                        title: Text(_productNames[item.productId] ?? item.productId),
                        subtitle: Text('Qty: ${item.quantity} | Price: \u20B9${item.price.toStringAsFixed(2)} | Disc: ${item.discount}%'),
                        trailing: Text(
                          '\u20B9${(item.price * item.quantity * (1 - item.discount / 100)).toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )).toList(),
                  );
                },
              ),
              const SizedBox(height: 24),
              if (o.status == OrderStatus.draft) ...[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _processing ? null : () => _updateStatus(OrderStatus.cancelled),
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        label: const Text('Cancel', style: TextStyle(color: Colors.red)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _processing ? null : () => _updateStatus(OrderStatus.submitted),
                        icon: const Icon(Icons.send),
                        label: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ],
              if (o.status == OrderStatus.submitted)
                FilledButton.icon(
                  onPressed: _processing ? null : () => _updateStatus(OrderStatus.confirmed),
                  icon: const Icon(Icons.check),
                  label: const Text('Confirm Order'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant))),
          Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _StatusTimeline extends StatelessWidget {
  final OrderStatus status;
  final ThemeData theme;
  const _StatusTimeline({required this.status, required this.theme});

  @override
  Widget build(BuildContext context) {
    final steps = [OrderStatus.draft, OrderStatus.submitted, OrderStatus.confirmed, OrderStatus.dispatched, OrderStatus.delivered];
    final currentIdx = steps.indexOf(status);
    final isCancelled = status == OrderStatus.cancelled;

    if (isCancelled) {
      return Card(
        color: Colors.red.withValues(alpha: 0.1),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.cancel, color: Colors.red), SizedBox(width: 8), Text('Order Cancelled', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: steps.asMap().entries.map((e) {
            final done = e.key <= currentIdx;
            return Column(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: done ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
                  child: done
                      ? Icon(Icons.check, size: 16, color: theme.colorScheme.onPrimary)
                      : Text('${e.key + 1}', style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant)),
                ),
                const SizedBox(height: 4),
                Text(e.value.name, style: TextStyle(fontSize: 10, fontWeight: done ? FontWeight.bold : FontWeight.normal)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
