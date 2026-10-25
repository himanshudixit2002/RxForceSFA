import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../core/providers/core_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart';
class CampaignCreateScreen extends ConsumerStatefulWidget {
  final String? campaignId;
  const CampaignCreateScreen({super.key, this.campaignId});

  @override
  ConsumerState<CampaignCreateScreen> createState() =>
      _CampaignCreateScreenState();
}

class _CampaignCreateScreenState extends ConsumerState<CampaignCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  List<Doctor> _allDoctors = [];
  final Set<String> _selectedDoctorIds = {};
  bool _saving = false;
  bool _hasChanges = false;
  bool get _isEditing => widget.campaignId != null;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final docs = await ref.read(doctorRepositoryProvider).getAll();
    if (mounted) setState(() => _allDoctors = docs);
    if (_isEditing) {
      final c = await ref.read(campaignRepositoryProvider).getById(widget.campaignId!);
      if (c != null && mounted) {
        _nameCtrl.text = c.name;
        _descCtrl.text = c.description;
        List<String> targets = [];
        try {
          targets = (jsonDecode(c.targetDoctors) as List).cast<String>();
        } catch (_) {}
        setState(() {
          _startDate = c.startDate;
          _endDate = c.endDate;
          _selectedDoctorIds.addAll(targets);
        });
      }
    }
  }

  Future<void> _pickDate(bool isStart) async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (d != null) {
      setState(() {
        if (isStart) {
          _startDate = d;
        } else {
          _endDate = d;
        }
        _hasChanges = true;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select start and end dates')),
      );
      return;
    }
    if (_endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End date must be after start date')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await ref
          .read(campaignRepositoryProvider)
          .upsert(
            CampaignsCompanion(
              id: Value(_isEditing ? widget.campaignId! : const Uuid().v4()),
              name: Value(_nameCtrl.text.trim()),
              description: Value(_descCtrl.text.trim()),
              startDate: Value(_startDate!),
              endDate: Value(_endDate!),
              status: const Value('active'),
              targetDoctors: Value(jsonEncode(_selectedDoctorIds.toList())),
            ),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isEditing ? 'Campaign updated' : 'Campaign created')),
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
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFmt = DateFormat.yMMMd();

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
        appBar: AppBar(title: Text(_isEditing ? 'Edit Campaign' : 'Create Campaign')),
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
                      labelText: 'Campaign Name',
                    ),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descCtrl,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pickDate(true),
                          icon: const Icon(Icons.calendar_today, size: 16),
                          label: Text(
                            _startDate == null
                                ? 'Start Date'
                                : dateFmt.format(_startDate!),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pickDate(false),
                          icon: const Icon(Icons.calendar_today, size: 16),
                          label: Text(
                            _endDate == null
                                ? 'End Date'
                                : dateFmt.format(_endDate!),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Target Doctors',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_allDoctors.isEmpty)
                    const Text('No doctors available')
                  else
                    ..._allDoctors.map(
                      (d) => CheckboxListTile(
                        title: Text(d.name),
                        subtitle: Text(d.specialization),
                        value: _selectedDoctorIds.contains(d.id),
                        onChanged: (v) {
                          setState(() {
                            if (v == true)
                              _selectedDoctorIds.add(d.id);
                            else
                              _selectedDoctorIds.remove(d.id);
                            _hasChanges = true;
                          });
                        },
                      ),
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
                        : Text(_isEditing ? 'Update Campaign' : 'Create Campaign'),
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
