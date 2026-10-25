import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../core/providers/core_providers.dart';
import '../../core/providers/user_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart';
import '../../presentation/widgets/coming_soon_banner.dart';

class DcrReviewScreen extends ConsumerStatefulWidget {
  final String transcript;
  final String? prefillDoctorName;
  final String? visitId;
  const DcrReviewScreen({
    super.key,
    required this.transcript,
    this.prefillDoctorName,
    this.visitId,
  });

  @override
  ConsumerState<DcrReviewScreen> createState() => _DcrReviewScreenState();
}

class _DcrReviewScreenState extends ConsumerState<DcrReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _doctorNameCtrl = TextEditingController();
  final _productsCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  DateTime? _followUpDate;
  bool _isSaving = false;
  bool _hasUnsavedChanges = false;
  String? _resolvedDoctorId;

  @override
  void initState() {
    super.initState();
    if (widget.prefillDoctorName != null &&
        widget.prefillDoctorName!.isNotEmpty) {
      _doctorNameCtrl.text = widget.prefillDoctorName!;
      _resolveDoctorId(widget.prefillDoctorName!);
    }
    _notesCtrl.text = widget.transcript;
    _doctorNameCtrl.addListener(_markDirty);
    _productsCtrl.addListener(_markDirty);
    _notesCtrl.addListener(_markDirty);
  }

  Future<void> _resolveDoctorId(String name) async {
    final doctors = await ref.read(doctorRepositoryProvider).getAll();
    final match = doctors.where(
        (d) => d.name.toLowerCase() == name.toLowerCase()).toList();
    if (match.isNotEmpty && mounted) {
      setState(() => _resolvedDoctorId = match.first.id);
    }
  }

  void _markDirty() {
    if (!_hasUnsavedChanges) setState(() => _hasUnsavedChanges = true);
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text(
            'You have unsaved changes. Are you sure you want to go back?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Discard')),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _pickFollowUpDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate:
          _followUpDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _followUpDate = date);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final user = ref.read(authStateProvider).value;
      final dcrRepo = ref.read(dcrRepositoryProvider);

      if (_resolvedDoctorId == null) {
        await _resolveDoctorId(_doctorNameCtrl.text.trim());
      }

      final dcr = Dcr(
        id: const Uuid().v4(),
        doctorName: _doctorNameCtrl.text.trim(),
        doctorId: _resolvedDoctorId ?? '',
        productsDiscussed: _productsCtrl.text.trim(),
        productsDetailed: '',
        samplesGiven: '',
        giftsGiven: '',
        followUpDate: _followUpDate,
        notes: _notesCtrl.text.trim(),
        callDuration: 0,
        geoLat: 0.0,
        geoLng: 0.0,
        createdAt: DateTime.now(),
        mrId: user?.uid ?? '',
      );

      await dcrRepo.save(dcr);

      if (widget.visitId != null && widget.visitId!.isNotEmpty) {
        await ref.read(visitRepositoryProvider).markCompleted(
              widget.visitId!,
              'DCR submitted',
            );
      }

      await ref.read(activityLogRepositoryProvider).log(
            userId: user?.uid ?? '',
            action: 'create_dcr',
            entityType: 'dcr',
            entityId: dcr.id,
            details: 'DCR created for ${dcr.doctorName}',
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('DCR saved successfully')));
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Something went wrong. Please try again.')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _doctorNameCtrl.removeListener(_markDirty);
    _productsCtrl.removeListener(_markDirty);
    _notesCtrl.removeListener(_markDirty);
    _doctorNameCtrl.dispose();
    _productsCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Review Call Report')),
        body: SafeArea(
          child: ResponsiveBuilder(
            builder: (context, screenType) {
              if (screenType != ScreenType.compact) {
                return _buildWideLayout(theme);
              }
              return _buildFormContent(theme);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWideLayout(ThemeData theme) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: adaptiveMaxWidth(context)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Original Text',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: theme.colorScheme.outlineVariant),
                      ),
                      child: Text(
                        widget.transcript,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(
              flex: 3,
              child: _buildFormContent(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormContent(ThemeData theme) {
    return SingleChildScrollView(
      padding: adaptivePadding(context),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: adaptiveFormMaxWidth(context),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ComingSoonBanner(
                  feature:
                      'AI-powered parsing coming soon. Please fill in details manually.',
                  icon: Icons.auto_awesome,
                ),
                const SizedBox(height: 16),
                if (screenTypeOf(context) == ScreenType.compact) ...[
                  ExpansionTile(
                    initiallyExpanded: false,
                    tilePadding: EdgeInsets.zero,
                    title: Text(
                      'Original Text',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    leading: Icon(
                      Icons.notes,
                      size: 20,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    children: [
                      Text(
                        widget.transcript,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 16),
                ],
                TextFormField(
                  controller: _doctorNameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Doctor Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Doctor name is required'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _productsCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Products Discussed',
                    prefixIcon: Icon(Icons.medication),
                    helperText: 'Comma-separated list',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.calendar_month),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _followUpDate != null
                            ? 'Follow-up: ${DateFormat.yMMMd().format(_followUpDate!)}'
                            : 'Set Follow-up Date',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                    TextButton(
                      onPressed: _pickFollowUpDate,
                      child: Text(
                          _followUpDate != null ? 'Change' : 'Pick Date'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Additional Notes',
                    prefixIcon: Icon(Icons.notes),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: _isSaving ? null : _save,
                  icon: _isSaving
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: const Text('Save Report'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
