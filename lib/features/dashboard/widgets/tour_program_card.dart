import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/core_providers.dart';
import '../../../data/models/database.dart';
import '../../../presentation/widgets/empty_state.dart';
import '../../../presentation/widgets/shimmer_loading.dart';

class TourProgramCard extends ConsumerWidget {
  final String mrId;
  const TourProgramCard({super.key, required this.mrId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final visitRepo = ref.watch(visitRepositoryProvider);
    final doctorRepo = ref.watch(doctorRepositoryProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Today's Tour Program",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => context.go('/route'),
                  icon: const Icon(Icons.map_outlined, size: 18),
                  label: const Text('Map'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            StreamBuilder<List<Visit>>(
              stream: visitRepo.watchTodayVisits(mrId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ShimmerLoading(itemCount: 3);
                }

                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Could not load visits',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  );
                }

                final visits = snapshot.data ?? [];
                if (visits.isEmpty) {
                  return const EmptyState(
                    icon: Icons.calendar_today_outlined,
                    title: 'No visits scheduled today',
                    subtitle: 'Your tour program will appear here',
                  );
                }

                return Column(
                  children: List.generate(visits.length, (index) {
                    final visit = visits[index];
                    final time =
                        '${visit.visitDate.hour.toString().padLeft(2, '0')}:'
                        '${visit.visitDate.minute.toString().padLeft(2, '0')}';
                    return Column(
                      children: [
                        if (index > 0) const Divider(height: 1),
                        FutureBuilder<Doctor?>(
                          future: doctorRepo.getById(visit.doctorId),
                          builder: (context, docSnap) {
                            final doctorName =
                                docSnap.data?.name ?? visit.doctorId;
                            final spec = docSnap.data?.specialization ?? '';
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                radius: 18,
                                backgroundColor: visit.isCompleted
                                    ? theme.colorScheme.primaryContainer
                                    : theme
                                        .colorScheme.surfaceContainerHighest,
                                child: Icon(
                                  visit.isCompleted
                                      ? Icons.check
                                      : Icons.schedule,
                                  size: 18,
                                  color: visit.isCompleted
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              title: Text(doctorName),
                              subtitle: Text(
                                spec.isNotEmpty ? '$time  •  $spec' : time,
                                style: theme.textTheme.bodySmall,
                              ),
                              trailing: visit.isCompleted
                                  ? Chip(
                                      label: const Text('Done'),
                                      backgroundColor:
                                          theme.colorScheme.primaryContainer,
                                      labelStyle: TextStyle(
                                        color: theme.colorScheme.primary,
                                        fontSize: 12,
                                      ),
                                    )
                                  : Icon(
                                      Icons.chevron_right,
                                      color:
                                          theme.colorScheme.onSurfaceVariant,
                                    ),
                              onTap: visit.isCompleted
                                  ? null
                                  : () => context.go('/dcr/record', extra: {
                                        'doctorName': doctorName,
                                        'visitId': visit.id,
                                      }),
                            );
                          },
                        ),
                      ],
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
