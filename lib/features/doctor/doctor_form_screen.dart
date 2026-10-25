import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../core/providers/core_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart';
import '../../presentation/widgets/shimmer_loading.dart';

class DoctorFormScreen extends ConsumerStatefulWidget {
  final String? doctorId;
  const DoctorFormScreen({super.key, this.doctorId});

  @override
  ConsumerState<DoctorFormScreen> createState() => _DoctorFormScreenState();
}

class _DoctorFormScreenState extends ConsumerState<DoctorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _specCtrl = TextEditingController();
  final _clinicCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _territoryCtrl = TextEditingController();
  final _classCtrl = TextEditingController();
  final _latCtrl = TextEditingController();
  final _lngCtrl = TextEditingController();
  bool _loading = true;
  bool _saving = false;
  bool _hasChanges = false;
  Doctor? _existingDoctor;

  bool get _isEdit => widget.doctorId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      _loadDoctor();
    } else {
      _loading = false;
    }
  }

  Future<void> _loadDoctor() async {
    final d = await ref
        .read(doctorRepositoryProvider)
        .getById(widget.doctorId!);
    if (d != null && mounted) {
      _existingDoctor = d;
      _nameCtrl.text = d.name;
      _specCtrl.text = d.specialization;
      _clinicCtrl.text = d.clinicAddress;
      _phoneCtrl.text = d.phone;
      _territoryCtrl.text = d.territory;
      _classCtrl.text = d.classification;
      _latCtrl.text = d.latitude.toString();
      _lngCtrl.text = d.longitude.toString();
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final id = widget.doctorId ?? const Uuid().v4();
      await ref
          .read(doctorRepositoryProvider)
          .upsert(
            Doctor(
              id: id,
              name: _nameCtrl.text.trim(),
              specialization: _specCtrl.text.trim(),
              clinicAddress: _clinicCtrl.text.trim(),
              phone: _phoneCtrl.text.trim(),
              territory: _territoryCtrl.text.trim(),
              classification: _classCtrl.text.trim(),
              latitude: double.tryParse(_latCtrl.text) ?? 0.0,
              longitude: double.tryParse(_lngCtrl.text) ?? 0.0,
              lastVisitDate: _existingDoctor?.lastVisitDate,
              visitFrequency: _existingDoctor?.visitFrequency ?? 0,
              conversionProbability: _existingDoctor?.conversionProbability ?? 0,
            ),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isEdit ? 'Doctor updated' : 'Doctor added')),
        );
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
    _nameCtrl.dispose();
    _specCtrl.dispose();
    _clinicCtrl.dispose();
    _phoneCtrl.dispose();
    _territoryCtrl.dispose();
    _classCtrl.dispose();
    _latCtrl.dispose();
    _lngCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text(_isEdit ? 'Edit Doctor' : 'Add Doctor')),
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
        appBar: AppBar(title: Text(_isEdit ? 'Edit Doctor' : 'Add Doctor')),
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
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _specCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Specialization',
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _clinicCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Clinic Address',
                    ),
                    textInputAction: TextInputAction.next,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneCtrl,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _territoryCtrl,
                    decoration: const InputDecoration(labelText: 'Territory'),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _classCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Classification (A/B/C)',
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _latCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Latitude',
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _lngCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Longitude',
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                    ],
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
                        : Text(_isEdit ? 'Update Doctor' : 'Add Doctor'),
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
