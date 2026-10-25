import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../core/providers/core_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart' as db;
class SampleDistributionScreen extends ConsumerStatefulWidget {
  final String? doctorId;
  const SampleDistributionScreen({super.key, this.doctorId});

  @override
  ConsumerState<SampleDistributionScreen> createState() =>
      _SampleDistributionScreenState();
}

class _SampleDistributionScreenState
    extends ConsumerState<SampleDistributionScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedProductId;
  String _doctorId = '';
  String _doctorName = '';
  final _qtyCtrl = TextEditingController(text: '1');
  final _batchCtrl = TextEditingController();
  String _type = 'sample';
  bool _saving = false;
  bool _hasChanges = false;
  List<db.Product> _products = [];

  @override
  void initState() {
    super.initState();
    _doctorId = widget.doctorId ?? '';
    _loadProducts();
    if (_doctorId.isNotEmpty) _loadDoctorName();
  }

  Future<void> _loadProducts() async {
    final products = await ref.read(productRepositoryProvider).getAll();
    if (mounted) setState(() => _products = products);
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

  @override
  void dispose() {
    _qtyCtrl.dispose();
    _batchCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _selectedProductId == null)
      return;
    setState(() => _saving = true);

    try {
      final uid = ref.read(authStateProvider).value?.uid ?? '';
      await ref
          .read(sampleRepositoryProvider)
          .distribute(
            db.SamplesCompanion(
              id: Value(const Uuid().v4()),
              productId: Value(_selectedProductId!),
              mrId: Value(uid),
              doctorId: Value(_doctorId),
              quantity: Value(int.tryParse(_qtyCtrl.text) ?? 1),
              date: Value(DateTime.now()),
              batchNo: Value(_batchCtrl.text),
              type: Value(_type),
            ),
          );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Sample distributed')));
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
        appBar: AppBar(title: const Text('Distribute Sample/Gift')),
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
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'sample', label: Text('Sample')),
                      ButtonSegment(value: 'gift', label: Text('Gift')),
                    ],
                    selected: {_type},
                    onSelectionChanged: (v) => setState(() {
                      _type = v.first;
                      _hasChanges = true;
                    }),
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedProductId,
                    decoration: const InputDecoration(
                      labelText: 'Product',
                      prefixIcon: Icon(Icons.medication),
                    ),
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
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      prefixIcon: Icon(Icons.numbers),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      final n = int.tryParse(v ?? '');
                      if (n == null || n <= 0) return 'Enter valid quantity';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _batchCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Batch Number',
                      prefixIcon: Icon(Icons.tag),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check),
                    label: const Text('Distribute'),
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
