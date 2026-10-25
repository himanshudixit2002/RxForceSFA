import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';

import '../../core/providers/core_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart';
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/shimmer_loading.dart';

class TourPlanDetailScreen extends ConsumerStatefulWidget {
  final String planId;

  const TourPlanDetailScreen({super.key, required this.planId});

  @override
  ConsumerState<TourPlanDetailScreen> createState() =>
      _TourPlanDetailScreenState();
}

class _TourPlanDetailScreenState extends ConsumerState<TourPlanDetailScreen> {
  TourPlan? _plan;
  List<TourPlanDay> _days = [];
  bool _loading = true;
  Map<String, String> _doctorNames = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  String? _error;

  Future<void> _load() async {
    try {
      final repo = ref.read(tourPlanRepositoryProvider);
      final plan = await repo.getPlanById(widget.planId);
      final days = await repo.getDaysForPlan(widget.planId);
      final doctors = await ref.read(doctorRepositoryProvider).getAll();
      final dMap = {for (final d in doctors) d.id: d.name};
      if (mounted) {
        setState(() {
          _plan = plan;
          _days = days;
          _doctorNames = dMap;
          _loading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'Failed to load tour plan';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tour Plan')),
        body: const ShimmerLoading(itemCount: 5),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tour Plan')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
              const SizedBox(height: 12),
              Text(_error!, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              FilledButton.tonalIcon(
                onPressed: () {
                  setState(() { _loading = true; _error = null; });
                  _load();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_plan == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tour Plan')),
        body: const Center(child: Text('Plan not found')),
      );
    }

    final monthName =
        DateFormat.MMMM().format(DateTime(_plan!.year, _plan!.month));

    return Scaffold(
      appBar: AppBar(
        title: Text('$monthName ${_plan!.year}'),
        actions: [
          if (_plan!.status == 'draft')
            FilledButton(
              onPressed: _submitPlan,
              child: const Text('Submit'),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: adaptiveMaxWidth(context),
          padding: adaptivePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: theme.colorScheme.primary),
                      const SizedBox(width: 12),
                      Text('Status: ${_plan!.status.toUpperCase()}',
                          style: theme.textTheme.titleSmall),
                      const Spacer(),
                      Text('${_days.length} days planned',
                          style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Day-wise Plan',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Expanded(
                child: _days.isEmpty
                    ? const EmptyState(icon: Icons.calendar_today, title: 'No days in this plan')
                    : ListView.builder(
                        itemCount: _days.length,
                        itemBuilder: (context, i) {
                          final day = _days[i];
                          final doctors =
                              (jsonDecode(day.doctorIds) as List).cast<String>();
                          final dateStr =
                              DateFormat.MMMEd().format(day.date);
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ExpansionTile(
                              leading: CircleAvatar(
                                backgroundColor: day.isCompleted
                                    ? Colors.green.withValues(alpha: 0.15)
                                    : theme.colorScheme.surfaceContainerHighest,
                                child: Icon(
                                  day.isCompleted
                                      ? Icons.check
                                      : Icons.calendar_today,
                                  color: day.isCompleted
                                      ? Colors.green
                                      : theme.colorScheme.onSurfaceVariant,
                                  size: 18,
                                ),
                              ),
                              title: Text(dateStr,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              subtitle: Text(
                                  '${doctors.length} doctor(s)'),
                              children: doctors
                                  .map((d) => ListTile(
                                        leading:
                                            const Icon(Icons.local_hospital),
                                        title: Text(_doctorNames[d] ?? d),
                                      ))
                                  .toList(),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitPlan() async {
    try {
      await ref.read(tourPlanRepositoryProvider).submitPlan(widget.planId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tour plan submitted for approval')),
        );
        _load();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit tour plan. Please try again.')),
        );
      }
    }
  }
}
