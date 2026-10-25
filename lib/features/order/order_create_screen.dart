import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../core/providers/core_providers.dart';
import '../../core/providers/user_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart' as db;
class OrderCreateScreen extends ConsumerStatefulWidget {
  final String? doctorId;
  const OrderCreateScreen({super.key, this.doctorId});

  @override
  ConsumerState<OrderCreateScreen> createState() => _OrderCreateScreenState();
}

class _OrderCreateScreenState extends ConsumerState<OrderCreateScreen> {
  final List<_OrderLine> _lines = [];
  List<db.Product> _products = [];
  bool _saving = false;
  String _doctorId = '';
  String _doctorName = '';
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _doctorId = widget.doctorId ?? '';
    _loadProducts();
    if (_doctorId.isNotEmpty) _loadDoctorName();
  }

  Future<void> _loadProducts() async {
    final p = await ref.read(productRepositoryProvider).getAll();
    if (mounted) setState(() => _products = p);
  }

  Future<void> _loadDoctorName() async {
    final doc = await ref.read(doctorRepositoryProvider).getById(_doctorId);
    if (doc != null && mounted) setState(() => _doctorName = doc.name);
  }

  Future<void> _pickDoctor() async {
    final doctors = await ref.read(doctorRepositoryProvider).getAll();
    if (!mounted) return;
    final selected = await showDialog<db.Doctor>(
      context: context,
      builder: (context) {
        String filter = '';
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final filtered = doctors
                .where((d) => d.name.toLowerCase().contains(filter.toLowerCase()))
                .toList();
            return SimpleDialog(
              title: const Text('Select Doctor'),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search doctors...',
                      prefixIcon: Icon(Icons.search),
                      isDense: true,
                    ),
                    onChanged: (v) => setDialogState(() => filter = v),
                  ),
                ),
                const SizedBox(height: 8),
                ...filtered.map(
                  (d) => SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, d),
                    child: Text(d.name),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
    if (selected != null) {
      setState(() {
        _doctorId = selected.id;
        _doctorName = selected.name;
        _hasChanges = true;
      });
    }
  }

  double get _total => _lines.fold(0.0, (s, l) {
    final price = l.product?.price ?? 0;
    final disc = l.discount;
    return s + (price * l.quantity * (1 - disc / 100));
  });

  Future<void> _save() async {
    if (_doctorId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a doctor')),
      );
      return;
    }
    if (_lines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one product')),
      );
      return;
    }
    final hasNullProduct = _lines.any((l) => l.product == null);
    if (hasNullProduct) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a product for each line')),
      );
      return;
    }
    setState(() => _saving = true);

    try {
      final uid = ref.read(authStateProvider).value?.uid ?? '';
      final orderId = const Uuid().v4();

      final items = _lines.map((l) {
        final price = l.product?.price ?? 0;
        return db.OrderItemsCompanion(
          id: Value(const Uuid().v4()),
          orderId: Value(orderId),
          productId: Value(l.product?.id ?? ''),
          quantity: Value(l.quantity),
          price: Value(price),
          discount: Value(l.discount),
        );
      }).toList();

      await ref
          .read(orderRepositoryProvider)
          .createOrder(
            db.OrdersCompanion(
              id: Value(orderId),
              mrId: Value(uid),
              doctorId: Value(_doctorId),
              status: const Value(db.OrderStatus.draft),
              totalAmount: Value(_total),
              orderDate: Value(DateTime.now()),
            ),
            items,
          );

      await ref
          .read(activityLogRepositoryProvider)
          .log(
            userId: uid,
            action: 'create_order',
            entityType: 'order',
            entityId: orderId,
            details: 'Order created for doctor $_doctorId, total: $_total',
          );

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Order created')));
        setState(() => _hasChanges = false);
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final discard = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Discard changes?'),
            content: const Text('You have unsaved changes that will be lost.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Keep Editing'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Discard'),
              ),
            ],
          ),
        );
        if (discard == true && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Order'),
          actions: [
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: const Text('Save'),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          child: ResponsiveCenter(
            maxWidth: adaptiveFormMaxWidth(context),
            padding: adaptivePadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: _pickDoctor,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Doctor',
                      prefixIcon: Icon(Icons.person_outline),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    child: Text(
                      _doctorName.isNotEmpty ? _doctorName : 'Tap to select a doctor',
                      style: _doctorName.isNotEmpty
                          ? null
                          : TextStyle(color: Theme.of(context).hintColor),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Text('Total: ', style: theme.textTheme.titleMedium),
                        Text(
                          '\u20B9${_total.toStringAsFixed(2)}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _lines.add(_OrderLine());
                      _hasChanges = true;
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Product'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _lines.length,
                    itemBuilder: (context, i) {
                      final line = _lines[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<db.Product>(
                                      value: line.product,
                                      decoration: const InputDecoration(
                                        labelText: 'Product',
                                        isDense: true,
                                      ),
                                      items: _products
                                          .map(
                                            (p) => DropdownMenuItem(
                                              value: p,
                                              child: Text(p.name),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (v) => setState(() {
                                        _lines[i].product = v;
                                        _hasChanges = true;
                                      }),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => setState(() {
                                      _lines.removeAt(i);
                                      _hasChanges = true;
                                    }),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: '${line.quantity}',
                                      decoration: const InputDecoration(
                                        labelText: 'Qty',
                                        isDense: true,
                                      ),
                                      keyboardType: TextInputType.number,
                                      onChanged: (v) => setState(() {
                                        _lines[i].quantity =
                                            int.tryParse(v) ?? 1;
                                        _hasChanges = true;
                                      }),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: '${line.discount}',
                                      decoration: const InputDecoration(
                                        labelText: 'Disc %',
                                        isDense: true,
                                      ),
                                      keyboardType: TextInputType.number,
                                      onChanged: (v) => setState(() {
                                        _lines[i].discount =
                                            double.tryParse(v) ?? 0;
                                        _hasChanges = true;
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderLine {
  db.Product? product;
  int quantity = 1;
  double discount = 0;
}
