import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../core/providers/core_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart';
import '../../presentation/widgets/shimmer_loading.dart';

class ProductFormScreen extends ConsumerStatefulWidget {
  final String? productId;
  const ProductFormScreen({super.key, this.productId});

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _skuCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _divisionCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _isActive = true;
  bool _loading = true;
  bool _saving = false;
  bool _hasChanges = false;

  bool get _isEdit => widget.productId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      _loadProduct();
    } else {
      _loading = false;
    }
  }

  Future<void> _loadProduct() async {
    final p = await ref.read(productRepositoryProvider).getById(widget.productId!);
    if (p != null && mounted) {
      _nameCtrl.text = p.name;
      _skuCtrl.text = p.sku;
      _categoryCtrl.text = p.category;
      _divisionCtrl.text = p.division;
      _priceCtrl.text = p.price.toString();
      _descCtrl.text = p.description;
      _isActive = p.isActive;
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final id = widget.productId ?? const Uuid().v4();
      await ref
          .read(productRepositoryProvider)
          .upsert(
            ProductsCompanion(
              id: Value(id),
              name: Value(_nameCtrl.text.trim()),
              sku: Value(_skuCtrl.text.trim()),
              category: Value(_categoryCtrl.text.trim()),
              division: Value(_divisionCtrl.text.trim()),
              price: Value(double.tryParse(_priceCtrl.text) ?? 0),
              description: Value(_descCtrl.text.trim()),
              isActive: Value(_isActive),
            ),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEdit ? 'Product updated' : 'Product created'),
          ),
        );
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
  void dispose() {
    _nameCtrl.dispose();
    _skuCtrl.dispose();
    _categoryCtrl.dispose();
    _divisionCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text(_isEdit ? 'Edit Product' : 'New Product')),
        body: const ShimmerLoading(itemCount: 5),
      );
    }

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
        appBar: AppBar(title: Text(_isEdit ? 'Edit Product' : 'New Product')),
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
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _skuCtrl,
                    decoration: const InputDecoration(labelText: 'SKU'),
                    textInputAction: TextInputAction.next,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _categoryCtrl,
                    decoration: const InputDecoration(labelText: 'Category'),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _divisionCtrl,
                    decoration: const InputDecoration(labelText: 'Division'),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _priceCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Price (\u20B9)',
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (v) => v == null || double.tryParse(v) == null
                        ? 'Enter a valid price'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descCtrl,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Active'),
                    value: _isActive,
                    onChanged: (v) => setState(() {
                      _isActive = v;
                      _hasChanges = true;
                    }),
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
                        : Text(_isEdit ? 'Update Product' : 'Create Product'),
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
