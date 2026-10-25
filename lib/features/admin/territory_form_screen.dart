import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../core/providers/user_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart' as db;

class TerritoryFormScreen extends ConsumerStatefulWidget {
  final String? territoryId;

  const TerritoryFormScreen({super.key, this.territoryId});

  @override
  ConsumerState<TerritoryFormScreen> createState() =>
      _TerritoryFormScreenState();
}

class _TerritoryFormScreenState extends ConsumerState<TerritoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  int _level = 0;
  String _parentId = '';
  bool _isLoading = false;
  bool _isEdit = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.territoryId != null && widget.territoryId != 'new';
    if (_isEdit) _loadTerritory();
  }

  Future<void> _loadTerritory() async {
    final t = await ref
        .read(territoryRepositoryProvider)
        .getTerritoryById(widget.territoryId!);
    if (t != null && mounted) {
      setState(() {
        _nameCtrl.text = t.name;
        _level = t.level;
        _parentId = t.parentId;
        _hasChanges = false;
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final id = _isEdit ? widget.territoryId! : const Uuid().v4();
      await ref
          .read(territoryRepositoryProvider)
          .upsertTerritory(
            db.TerritoriesCompanion(
              id: Value(id),
              name: Value(_nameCtrl.text.trim()),
              parentId: Value(_parentId),
              level: Value(_level),
              boundaries: const Value('{}'),
            ),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEdit ? 'Territory updated' : 'Territory created'),
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final territories = ref.watch(allTerritoriesProvider).value ?? [];

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
          title: Text(_isEdit ? 'Edit Territory' : 'Create Territory'),
        ),
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
                      labelText: 'Territory Name',
                      prefixIcon: Icon(Icons.map),
                    ),
                    textInputAction: TextInputAction.done,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Name required' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _parentId.isEmpty ? null : _parentId,
                    decoration: const InputDecoration(
                      labelText: 'Parent Territory',
                      prefixIcon: Icon(Icons.account_tree),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: '',
                        child: Text('None (Root)'),
                      ),
                      ...territories
                          .where((t) => t.id != widget.territoryId)
                          .map(
                            (t) => DropdownMenuItem(
                              value: t.id,
                              child: Text(t.name),
                            ),
                          ),
                    ],
                    onChanged: (v) => setState(() => _parentId = v ?? ''),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: _level,
                    decoration: const InputDecoration(
                      labelText: 'Level',
                      prefixIcon: Icon(Icons.layers),
                    ),
                    items: List.generate(
                      5,
                      (i) =>
                          DropdownMenuItem(value: i, child: Text('Level $i')),
                    ),
                    onChanged: (v) {
                      if (v != null) setState(() => _level = v);
                    },
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _isLoading ? null : _save,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: Text(_isEdit ? 'Update' : 'Create'),
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
