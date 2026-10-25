import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/responsive.dart';

class ReportsHomeScreen extends StatelessWidget {
  const ReportsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final reports = [
      _ReportItem('Sales Report', Icons.attach_money, '/reports/sales',
          Colors.green),
      _ReportItem('Activity Report', Icons.trending_up, '/reports/activity',
          Colors.blue),
      _ReportItem('Attendance Report', Icons.access_time,
          '/reports/attendance', Colors.orange),
      _ReportItem('Expense Report', Icons.receipt_long, '/reports/expense',
          Colors.purple),
      _ReportItem('Sample Report', Icons.science, '/reports/sample',
          Colors.teal),
      _ReportItem('Tour Deviation', Icons.alt_route,
          '/reports/tour-deviation', Colors.red),
      _ReportItem('Target Achievement', Icons.track_changes,
          '/reports/target', Colors.indigo),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: adaptiveMaxWidth(context),
          padding: adaptivePadding(context),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: adaptiveGridColumns(context).clamp(2, 4),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
            ),
            itemCount: reports.length,
            itemBuilder: (context, i) {
              final r = reports[i];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => context.push(r.route),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: r.color.withValues(alpha: 0.12),
                          child: Icon(r.icon, color: r.color),
                        ),
                        const SizedBox(height: 12),
                        Text(r.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ReportItem {
  final String title;
  final IconData icon;
  final String route;
  final Color color;
  const _ReportItem(this.title, this.icon, this.route, this.color);
}
