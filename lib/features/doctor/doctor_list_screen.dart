import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/core_providers.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart';
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/shimmer_loading.dart';

class DoctorListScreen extends ConsumerStatefulWidget {
  const DoctorListScreen({super.key});

  @override
  ConsumerState<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends ConsumerState<DoctorListScreen> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String? _selectedSpecialization;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final doctorRepo = ref.watch(doctorRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctors'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/doctors/new'),
        icon: const Icon(Icons.add),
        label: const Text('Add Doctor'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: adaptiveMaxWidth(context),
                  ),
                  child: SearchBar(
                    controller: _searchCtrl,
                    hintText: 'Search doctors...',
                    leading: const Icon(Icons.search),
                    trailing: _searchQuery.isNotEmpty
                        ? [
                            IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchCtrl.clear();
                                setState(() => _searchQuery = '');
                              },
                            ),
                          ]
                        : null,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    padding: const WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(doctorRepositoryProvider);
                },
                child: StreamBuilder<List<Doctor>>(
                  stream: doctorRepo.watchAll(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.error_outline,
                                size: 48,
                                color: theme.colorScheme.error),
                            const SizedBox(height: 12),
                            Text('Failed to load doctors',
                                style: theme.textTheme.titleMedium),
                            const SizedBox(height: 8),
                            FilledButton.tonalIcon(
                              onPressed: () {
                                ref.invalidate(doctorRepositoryProvider);
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting &&
                        !snapshot.hasData) {
                      return const ShimmerLoading();
                    }

                    final doctors = snapshot.data ?? [];
                    if (doctors.isEmpty) {
                      return CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: const EmptyState(
                              icon: Icons.people_outline,
                              title: 'No doctors found',
                              subtitle: 'Doctors will appear here after syncing',
                            ),
                          ),
                        ],
                      );
                    }

                  final specializations = doctors
                      .map((d) => d.specialization)
                      .where((s) => s.isNotEmpty)
                      .toSet()
                      .toList()
                    ..sort();

                  var filtered = doctors;
                  if (_searchQuery.isNotEmpty) {
                    final q = _searchQuery.toLowerCase();
                    filtered = filtered
                        .where((d) =>
                            d.name.toLowerCase().contains(q) ||
                            d.specialization.toLowerCase().contains(q) ||
                            d.clinicAddress.toLowerCase().contains(q))
                        .toList();
                  }
                  if (_selectedSpecialization != null) {
                    filtered = filtered
                        .where(
                            (d) => d.specialization == _selectedSpecialization)
                        .toList();
                  }

                  return Column(
                    children: [
                      if (specializations.length > 1)
                        SizedBox(
                          height: 42,
                          child: Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: adaptiveMaxWidth(context),
                              ),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                padding:
                                    const EdgeInsets.only(left: 16, right: 24),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: FilterChip(
                                      label: const Text('All'),
                                      selected:
                                          _selectedSpecialization == null,
                                      onSelected: (_) => setState(
                                          () => _selectedSpecialization = null),
                                    ),
                                  ),
                                  ...specializations.map((spec) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: FilterChip(
                                        label: Text(spec),
                                        selected:
                                            _selectedSpecialization == spec,
                                        onSelected: (sel) => setState(() =>
                                            _selectedSpecialization =
                                                sel ? spec : null),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: filtered.isEmpty
                            ? Center(
                                child: Text(
                                  'No matching doctors',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              )
                            : ResponsiveBuilder(
                                builder: (context, screenType) {
                                  if (screenType == ScreenType.compact) {
                                    return _DoctorListView(
                                      doctors: filtered,
                                      theme: theme,
                                    );
                                  }
                                  return _DoctorGridView(
                                    doctors: filtered,
                                    theme: theme,
                                    crossAxisCount:
                                        screenType == ScreenType.expanded
                                            ? 3
                                            : 2,
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
          ],
        ),
      ),
    );
  }
}

class _DoctorListView extends StatelessWidget {
  final List<Doctor> doctors;
  final ThemeData theme;

  const _DoctorListView({required this.doctors, required this.theme});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: doctors.length,
      itemBuilder: (context, index) =>
          _DoctorCard(doctor: doctors[index], theme: theme),
    );
  }
}

class _DoctorGridView extends StatelessWidget {
  final List<Doctor> doctors;
  final ThemeData theme;
  final int crossAxisCount;

  const _DoctorGridView({
    required this.doctors,
    required this.theme,
    required this.crossAxisCount,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: adaptiveMaxWidth(context)),
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 8,
            crossAxisSpacing: 12,
            mainAxisExtent: 120,
          ),
          itemCount: doctors.length,
          itemBuilder: (context, index) =>
              _DoctorCard(doctor: doctors[index], theme: theme),
        ),
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final ThemeData theme;

  const _DoctorCard({required this.doctor, required this.theme});

  @override
  Widget build(BuildContext context) {
    final initials = doctor.name
        .split(' ')
        .take(2)
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .join();

    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.go('/doctors/${doctor.id}', extra: doctor),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Hero(
                tag: 'doctor-avatar-${doctor.id}',
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      doctor.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (doctor.specialization.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        doctor.specialization,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                    if (doctor.clinicAddress.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        doctor.clinicAddress,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (doctor.lastVisitDate != null)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppFormatters.dateShort(doctor.lastVisitDate!),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Last visit',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
