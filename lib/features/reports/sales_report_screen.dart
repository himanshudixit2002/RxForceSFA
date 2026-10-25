import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/core_providers.dart';
import '../../core/services/export_service.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart';

final _ordersProvider = StreamProvider<List<Order>>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return Stream.value([]);
  return ref.watch(orderRepositoryProvider).watchForMr(uid);
});

final _doctorNamesProvider = FutureProvider<Map<String, String>>((ref) async {
  final doctors = await ref.watch(doctorRepositoryProvider).getAll();
  return {for (final d in doctors) d.id: d.name};
});

class SalesReportScreen extends ConsumerWidget {
  const SalesReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final ordersAsync = ref.watch(_ordersProvider);
    final doctorNames = ref.watch(_doctorNamesProvider).value ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: 'Export CSV',
            onPressed: () {
              final orders = ordersAsync.value ?? [];
              final monthlySales = _aggregateByMonth(orders);
              final monthNames = [
                'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
              ];
              createExportService().exportCsv(
                fileName: 'sales_report',
                headers: ['Month', 'Sales'],
                rows: monthlySales.entries
                    .map((e) => [monthNames[e.key - 1], e.value.toStringAsFixed(0)])
                    .toList(),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: adaptiveMaxWidth(context),
          padding: adaptivePadding(context),
          child: ordersAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (orders) {
              final monthlySales = _aggregateByMonth(orders);
              final maxY = monthlySales.values.isEmpty
                  ? 100.0
                  : monthlySales.values.reduce((a, b) => a > b ? a : b) * 1.2;
              final monthNames = [
                'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
              ];

              return ListView(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Monthly Sales Trend',
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: monthlySales.isEmpty
                                ? const Center(child: Text('No sales data yet'))
                                : BarChart(
                                    BarChartData(
                                      alignment: BarChartAlignment.spaceAround,
                                      maxY: maxY,
                                      barGroups: monthlySales.entries.map((e) {
                                        return BarChartGroupData(
                                          x: e.key,
                                          barRods: [
                                            BarChartRodData(
                                              toY: e.value,
                                              color: theme.colorScheme.primary,
                                              width: 16,
                                              borderRadius: const BorderRadius.vertical(
                                                  top: Radius.circular(4)),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                      titlesData: FlTitlesData(
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            getTitlesWidget: (v, _) {
                                              final idx = v.toInt();
                                              if (idx >= 1 && idx <= 12) {
                                                return Text(monthNames[idx - 1],
                                                    style: const TextStyle(fontSize: 10));
                                              }
                                              return const SizedBox.shrink();
                                            },
                                          ),
                                        ),
                                        leftTitles: const AxisTitles(
                                            sideTitles: SideTitles(showTitles: false)),
                                        topTitles: const AxisTitles(
                                            sideTitles: SideTitles(showTitles: false)),
                                        rightTitles: const AxisTitles(
                                            sideTitles: SideTitles(showTitles: false)),
                                      ),
                                      borderData: FlBorderData(show: false),
                                      gridData: const FlGridData(show: false),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDoctorSplit(theme, orders, doctorNames),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Map<int, double> _aggregateByMonth(List<Order> orders) {
    final now = DateTime.now();
    final thisYear = orders.where((o) => o.orderDate.year == now.year);
    final map = <int, double>{};
    for (final o in thisYear) {
      map[o.orderDate.month] = (map[o.orderDate.month] ?? 0) + o.totalAmount;
    }
    return Map.fromEntries(map.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
  }

  Widget _buildDoctorSplit(
      ThemeData theme, List<Order> orders, Map<String, String> doctorNames) {
    final doctorTotals = <String, double>{};
    for (final o in orders) {
      final name = doctorNames[o.doctorId] ?? o.doctorId;
      doctorTotals[name] = (doctorTotals[name] ?? 0) + o.totalAmount;
    }

    final total = doctorTotals.values.fold(0.0, (a, b) => a + b);
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sales by Doctor',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: doctorTotals.isEmpty
                  ? const Center(child: Text('No data'))
                  : PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: doctorTotals.entries.toList().asMap().entries.map((e) {
                          final pct = total > 0
                              ? (e.value.value / total * 100).toStringAsFixed(0)
                              : '0';
                          return PieChartSectionData(
                            value: e.value.value,
                            title: '$pct%',
                            color: colors[e.key % colors.length],
                            radius: 50,
                          );
                        }).toList(),
                      ),
                    ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 4,
              children: doctorTotals.entries.toList().asMap().entries.map((e) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: colors[e.key % colors.length],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(e.value.key, style: theme.textTheme.bodySmall),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
