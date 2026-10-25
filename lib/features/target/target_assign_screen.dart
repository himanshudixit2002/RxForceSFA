import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../core/providers/core_providers.dart';
import '../../core/providers/user_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart';
class TargetAssignScreen extends ConsumerStatefulWidget {
  const TargetAssignScreen({super.key});

  @override
  ConsumerState<TargetAssignScreen> createState() => _TargetAssignScreenState();
}

class _TargetAssignScreenState extends ConsumerState<TargetAssignScreen> {
  final _formKey = GlobalKey<FormState>();
  String _mrId = '';
  String _mrName = '';
  final _targetValueCtrl = TextEditingController();
  final _periodCtrl = TextEditingController();
  String? _selectedProductId;
  TargetType _targetType = TargetType.monthly;
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
    setState(() => _saving = true);
    try {
      await ref
          .read(targetRepositoryProvider)
          .upsert(
            TargetsCompanion(
              id: Value(const Uuid().v4()),
              mrId: Value(_mrId),
              productId: Value(_selectedProductId ?? ''),
              targetType: Value(_targetType),
              targetValue: Value(double.tryParse(_targetValueCtrl.text) ?? 0),
              achievedValue: const Value(0),
              period: Value(_periodCtrl.text.trim()),
            ),
          );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Target assigned')));
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
    _targetValueCtrl.dispose();
    _periodCtrl.dispose();
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
        appBar: AppBar(title: const Text('Assign Target')),
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
                  DropdownButtonFormField<TargetType>(
                    value: _targetType,
                    decoration: const InputDecoration(labelText: 'Target Type'),
                    items: TargetType.values
                        .map(
                          (t) =>
                              DropdownMenuItem(value: t, child: Text(t.name)),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _targetType = v!),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedProductId,
                    decoration: const InputDecoration(
                      labelText: 'Product (optional)',
                    ),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('All Products'),
                      ),
                      ..._products.map(
                        (p) =>
                            DropdownMenuItem(value: p.id, child: Text(p.name)),
                      ),
                    ],
                    onChanged: (v) => setState(() => _selectedProductId = v),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _targetValueCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Target Value',
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (v) => v == null || double.tryParse(v) == null
                        ? 'Enter a number'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _periodCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Period (e.g. 2026-03, Q1-2026)',
                    ),
                    textInputAction: TextInputAction.done,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
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
                        : const Text('Assign Target'),
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
