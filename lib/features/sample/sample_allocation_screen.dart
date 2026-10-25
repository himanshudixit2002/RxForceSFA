import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../core/providers/core_providers.dart';
import '../../core/providers/user_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart';
class SampleAllocationScreen extends ConsumerStatefulWidget {
  const SampleAllocationScreen({super.key});

  @override
  ConsumerState<SampleAllocationScreen> createState() =>
      _SampleAllocationScreenState();
}

class _SampleAllocationScreenState
    extends ConsumerState<SampleAllocationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _mrId = '';
  String _mrName = '';
  final _qtyCtrl = TextEditingController();
  String? _selectedProductId;
  List<Product> _products = [];
  bool _saving = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final prods = await ref.read(productRepositoryProvider).getAll();
    if (mounted) setState(() => _products = prods);
  }

  Future<void> _pickMr() async {
    final users = await ref.read(userRepositoryProvider).getAllUsers();
    final mrs = users.where((u) => u.role == 'mr').toList();
    if (!mounted) return;
    final selected = await showDialog<User>(
      context: context,
      builder: (context) {
        String filter = '';
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final filtered = mrs
                .where((u) => u.name.toLowerCase().contains(filter.toLowerCase()))
                .toList();
            return SimpleDialog(
              title: const Text('Select MR'),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search MR...',
                      prefixIcon: Icon(Icons.search),
                      isDense: true,
                    ),
                    onChanged: (v) => setDialogState(() => filter = v),
                  ),
                ),
                const SizedBox(height: 8),
                ...filtered.map(
                  (u) => SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, u),
                    child: Text('${u.name} (${u.email})'),
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
        _mrId = selected.id;
        _mrName = selected.name;
        _hasChanges = true;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_mrId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Select an MR')));
      return;
    }
    if (_selectedProductId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Select a product')));
      return;
    }
    setState(() => _saving = true);
    try {
      final qty = int.tryParse(_qtyCtrl.text) ?? 0;
      await ref
          .read(sampleRepositoryProvider)
          .updateStock(
            StockLedgersCompanion(
              id: Value(const Uuid().v4()),
              productId: Value(_selectedProductId!),
              mrId: Value(_mrId),
              received: Value(qty),
              closingStock: Value(qty),
              date: Value(DateTime.now()),
            ),
          );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Stock allocated')));
        setState(() => _hasChanges = false);
        context.pop();
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong. Please try again.'),
          ),
        );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _qtyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        appBar: AppBar(title: const Text('Allocate Samples')),
        body: SafeArea(
          child: ResponsiveCenter(
            padding: adaptivePadding(context),
            child: Form(
              key: _formKey,
              onChanged: () {
                if (!_hasChanges) setState(() => _hasChanges = true);
              },
              child: ListView(
                children: [
                  InkWell(
                    onTap: _pickMr,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'MR (Medical Representative)',
                        prefixIcon: Icon(Icons.person_outline),
                        suffixIcon: Icon(Icons.arrow_drop_down),
                      ),
                      child: Text(
                        _mrName.isNotEmpty ? _mrName : 'Tap to select an MR',
                        style: _mrName.isNotEmpty
                            ? null
                            : TextStyle(color: Theme.of(context).hintColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedProductId,
                    decoration: const InputDecoration(labelText: 'Product'),
                    items: _products
                        .map(
                          (p) => DropdownMenuItem(
                            value: p.id,
                            child: Text(p.name),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _selectedProductId = v),
                    validator: (v) => v == null ? 'Select a product' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _qtyCtrl,
                    decoration: const InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v == null || int.tryParse(v) == null
                        ? 'Enter a valid quantity'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Allocate Stock'),
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
