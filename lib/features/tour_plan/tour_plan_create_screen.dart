import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';

import '../../core/providers/core_providers.dart';
import '../../core/providers/user_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart' as db;
class TourPlanCreateScreen extends ConsumerStatefulWidget {
  const TourPlanCreateScreen({super.key});

  @override
  ConsumerState<TourPlanCreateScreen> createState() =>
      _TourPlanCreateScreenState();
}

class _TourPlanCreateScreenState extends ConsumerState<TourPlanCreateScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<String>> _dayDoctors = {};
  final Map<DateTime, String> _dayNotes = {};
  final Map<String, String> _doctorNames = {};
  bool _saving = false;
  bool _hasChanges = false;

  DateTime _normalizeDate(DateTime d) => DateTime(d.year, d.month, d.day);

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
          title: const Text('Create Tour Plan'),
          actions: [
            FilledButton.icon(
              onPressed: _saving ? null : _savePlan,
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
            maxWidth: adaptiveMaxWidth(context),
            padding: adaptivePadding(context),
            child: Column(
              children: [
                TableCalendar(
                  firstDay: DateTime(_focusedDay.year, _focusedDay.month, 1),
                  lastDay: DateTime(_focusedDay.year, _focusedDay.month + 2, 0),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) =>
                      _selectedDay != null && isSameDay(_selectedDay!, day),
                  onDaySelected: (selected, focused) {
                    setState(() {
                      _selectedDay = _normalizeDate(selected);
                      _focusedDay = focused;
                    });
                  },
                  eventLoader: (day) {
                    final key = _normalizeDate(day);
                    return _dayDoctors[key] ?? [];
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                      color: theme.colorScheme.tertiary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: const HeaderStyle(formatButtonVisible: false),
                ),
                const Divider(),
                if (_selectedDay != null)
                  Expanded(child: _buildDayEditor(theme))
                else
                  Expanded(
                    child: Center(
                      child: Text(
                        'Select a day to add doctors',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayEditor(ThemeData theme) {
    final key = _normalizeDate(_selectedDay!);
    final selectedDoctors = _dayDoctors[key] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Text(
                '${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _addDoctorToDay,
                icon: const Icon(Icons.add),
                label: const Text('Add Doctor'),
              ),
            ],
          ),
        ),
        Expanded(
          child: selectedDoctors.isEmpty
              ? Center(
                  child: Text(
                    'No doctors assigned',
                    style: theme.textTheme.bodyMedium,
                  ),
                )
              : ListView.builder(
                  itemCount: selectedDoctors.length,
                  itemBuilder: (context, i) => ListTile(
                    leading: const Icon(Icons.local_hospital),
                    title: Text(_doctorNames[selectedDoctors[i]] ?? selectedDoctors[i]),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.remove_circle_outline,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedDoctors.removeAt(i);
                          _dayDoctors[key] = selectedDoctors;
                          _hasChanges = true;
                        });
                      },
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Future<void> _addDoctorToDay() async {
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

    if (selected != null && _selectedDay != null) {
      final key = _normalizeDate(_selectedDay!);
      setState(() {
        _doctorNames[selected.id] = selected.name;
        _dayDoctors[key] = [...(_dayDoctors[key] ?? []), selected.id];
        _hasChanges = true;
      });
    }
  }

  Future<void> _savePlan() async {
    if (_dayDoctors.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one day with doctors')),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final uid = ref.read(authStateProvider).value?.uid ?? '';
      final planId = const Uuid().v4();

      await ref
          .read(tourPlanRepositoryProvider)
          .upsertPlan(
            db.TourPlansCompanion(
              id: Value(planId),
              mrId: Value(uid),
              month: Value(_focusedDay.month),
              year: Value(_focusedDay.year),
              status: const Value('draft'),
            ),
          );

      for (final entry in _dayDoctors.entries) {
        if (entry.value.isEmpty) continue;
        await ref
            .read(tourPlanRepositoryProvider)
            .upsertPlanDay(
              db.TourPlanDaysCompanion(
                id: Value(const Uuid().v4()),
                tourPlanId: Value(planId),
                date: Value(entry.key),
                doctorIds: Value(jsonEncode(entry.value)),
                notes: Value(_dayNotes[entry.key] ?? ''),
              ),
            );
      }

      await ref
          .read(activityLogRepositoryProvider)
          .log(
            userId: uid,
            action: 'create_tour_plan',
            entityType: 'tourPlan',
            entityId: planId,
            details: 'Tour plan for ${_focusedDay.month}/${_focusedDay.year}',
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tour plan saved as draft')),
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
}
