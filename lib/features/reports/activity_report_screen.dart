import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/core_providers.dart';
import '../../core/services/export_service.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart';

final _dcrsProvider = StreamProvider<List<Dcr>>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return Stream.value([]);
  return ref.watch(dcrRepositoryProvider).watchByMr(uid);
});

final _doctorCountProvider = FutureProvider<int>((ref) async {
  final doctors = await ref.watch(doctorRepositoryProvider).getAll();
  return doctors.length;
});

class ActivityReportScreen extends ConsumerWidget {
  const ActivityReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dcrsAsync = ref.watch(_dcrsProvider);
    final totalDoctors = ref.watch(_doctorCountProvider).value ?? 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: 'Export CSV',
            onPressed: () {
              final dcrs = dcrsAsync.value ?? [];
              final dailyCounts = _aggregateByWeekday(dcrs);
              const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
              createExportService().exportCsv(
                fileName: 'activity_report',
                headers: ['Day', 'Calls'],
                rows: List.generate(
                    7, (i) => [days[i], dailyCounts[i + 1] ?? 0]),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: adaptiveMaxWidth(context),
          padding: adaptivePadding(context),
          child: dcrsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (dcrs) {
              final now = DateTime.now();
              final monthStart = DateTime(now.year, now.month, 1);
              final thisMonth =
                  dcrs.where((d) => !d.createdAt.isBefore(monthStart)).toList();
              final totalCalls = thisMonth.length;
              final uniqueDoctors =
                  thisMonth.map((d) => d.doctorName).toSet().length;
              final coverage = totalDoctors > 0
                  ? (uniqueDoctors / totalDoctors * 100).toStringAsFixed(0)
                  : '0';
              final frequency = uniqueDoctors > 0
                  ? (totalCalls / uniqueDoctors).toStringAsFixed(1)
                  : '0.0';

              final dailyCounts = _aggregateByWeekday(dcrs);
              final maxY = dailyCounts.values.isEmpty
                  ? 10.0
                  : dailyCounts.values.reduce((a, b) => a > b ? a : b).toDouble() * 1.3;

              return ListView(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: _KpiCard('Total Calls', '$totalCalls',
                              Icons.phone, Colors.blue)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _KpiCard('Coverage', '$coverage%',
                              Icons.location_on, Colors.green)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _KpiCard('Frequency', frequency,
                              Icons.repeat, Colors.orange)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Daily Calls (This Week)',
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: dailyCounts.isEmpty
                                ? const Center(child: Text('No call data yet'))
                                : LineChart(
                                    LineChartData(
                                      lineBarsData: [
                                        LineChartBarData(
                                          spots: List.generate(
                                              7,
                                              (i) => FlSpot(
                                                  i.toDouble(),
                                                  (dailyCounts[i + 1] ?? 0)
                                                      .toDouble())),
                                          isCurved: true,
                                          color: theme.colorScheme.primary,
                                          barWidth: 3,
                                          dotData: const FlDotData(show: false),
                                          belowBarData: BarAreaData(
                                            show: true,
                                            color: theme.colorScheme.primary
                                                .withValues(alpha: 0.1),
                                          ),
                                        ),
                                      ],
                                      titlesData: FlTitlesData(
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            getTitlesWidget: (v, _) {
                                              const days = [
                                                'Mon', 'Tue', 'Wed', 'Thu',
                                                'Fri', 'Sat', 'Sun'
                                              ];
                                              if (v.toInt() < days.length) {
                                                return Text(days[v.toInt()],
                                                    style: const TextStyle(
                                                        fontSize: 10));
                                              }
                                              return const SizedBox.shrink();
                                            },
                                          ),
                                        ),
                                        leftTitles: const AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false)),
                                        topTitles: const AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false)),
                                        rightTitles: const AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false)),
                                      ),
                                      maxY: maxY,
                                      borderData: FlBorderData(show: false),
                                      gridData: const FlGridData(show: false),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// Returns map of weekday (1=Mon..7=Sun) to DCR count for the current week.
  Map<int, int> _aggregateByWeekday(List<Dcr> dcrs) {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final weekStart = DateTime(monday.year, monday.month, monday.day);
    final weekEnd = weekStart.add(const Duration(days: 7));

    final thisWeek = dcrs.where(
        (d) => !d.createdAt.isBefore(weekStart) && d.createdAt.isBefore(weekEnd));
    final map = <int, int>{};
    for (final d in thisWeek) {
      final wd = d.createdAt.weekday;
      map[wd] = (map[wd] ?? 0) + 1;
    }
    return map;
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiCard(this.label, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(value,
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
