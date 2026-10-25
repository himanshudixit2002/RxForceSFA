import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/providers/core_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart';
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/error_retry_card.dart';
import '../../presentation/widgets/shimmer_loading.dart';

final _attendanceProvider = StreamProvider<List<Attendance>>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return Stream.value([]);
  return ref.watch(attendanceRepositoryProvider).watchForMr(uid);
});

class AttendanceHistoryScreen extends ConsumerStatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  ConsumerState<AttendanceHistoryScreen> createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends ConsumerState<AttendanceHistoryScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, List<Attendance>> _buildEvents(List<Attendance> records) {
    final map = <DateTime, List<Attendance>>{};
    for (final a in records) {
      final day = DateTime(a.date.year, a.date.month, a.date.day);
      map.putIfAbsent(day, () => []).add(a);
    }
    return map;
  }

  List<Attendance> _getEventsForDay(Map<DateTime, List<Attendance>> events, DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return events[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final attendanceAsync = ref.watch(_attendanceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Attendance History')),
      body: SafeArea(
        child: ResponsiveCenter(
          padding: adaptivePadding(context),
          child: attendanceAsync.when(
            loading: () => const ShimmerLoading(itemCount: 5),
            error: (e, _) => Center(
              child: ErrorRetryCard(
                message: 'Failed to load attendance history',
                onRetry: () => ref.invalidate(_attendanceProvider),
              ),
            ),
            data: (records) {
              final events = _buildEvents(records);
              final selected = _selectedDay != null
                  ? _getEventsForDay(events, _selectedDay!)
                  : <Attendance>[];

              return Column(
                children: [
                  TableCalendar<Attendance>(
                    firstDay: DateTime(2020),
                    lastDay: DateTime(2030),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    eventLoader: (day) => _getEventsForDay(events, day),
                    selectedDayPredicate: (d) => isSameDay(_selectedDay, d),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() { _selectedDay = selectedDay; _focusedDay = focusedDay; });
                    },
                    onFormatChanged: (f) => setState(() => _calendarFormat = f),
                    onPageChanged: (d) => _focusedDay = d,
                    calendarStyle: CalendarStyle(
                      markerDecoration: BoxDecoration(color: theme.colorScheme.primary, shape: BoxShape.circle),
                      markerSize: 6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (selected.isEmpty)
                    const Expanded(child: EmptyState(icon: Icons.event_available, title: 'No records for this day'))
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: selected.length,
                        itemBuilder: (_, i) {
                          final a = selected[i];
                          final timeFmt = DateFormat.jm();
                          String? workingHours;
                          if (a.punchInTime != null && a.punchOutTime != null) {
                            final diff = a.punchOutTime!.difference(a.punchInTime!);
                            workingHours = '${diff.inHours}h ${diff.inMinutes % 60}m';
                          }
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: const Icon(Icons.access_time),
                              title: Text(a.punchInTime != null ? 'Punch In: ${timeFmt.format(a.punchInTime!)}' : 'No punch-in'),
                              subtitle: Text(
                                (a.punchOutTime != null ? 'Punch Out: ${timeFmt.format(a.punchOutTime!)}' : 'Not punched out') +
                                (workingHours != null ? '  •  $workingHours' : ''),
                              ),
                              trailing: Text(a.status.name, style: TextStyle(fontWeight: FontWeight.bold, color: a.status == AttendanceStatus.present ? Colors.green : Colors.orange)),
                            ),
                          );
                        },
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
}
