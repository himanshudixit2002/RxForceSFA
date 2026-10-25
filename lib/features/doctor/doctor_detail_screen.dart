import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/providers/core_providers.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart';
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/shimmer_loading.dart';

class DoctorDetailScreen extends ConsumerStatefulWidget {
  final String doctorId;
  final Doctor? initialDoctor;

  const DoctorDetailScreen({
    super.key,
    required this.doctorId,
    this.initialDoctor,
  });

  @override
  ConsumerState<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends ConsumerState<DoctorDetailScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  Doctor? _doctor;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _doctor = widget.initialDoctor;
    _loadDoctor();
  }

  Future<void> _loadDoctor() async {
    final d = await ref.read(doctorRepositoryProvider).getById(widget.doctorId);
    if (mounted) setState(() { _doctor = d ?? _doctor; _loading = false; });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loading && _doctor == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const ShimmerLoading(itemCount: 5),
      );
    }

    final doctor = _doctor;
    if (doctor == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Doctor')),
        body: const Center(child: Text('Doctor not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(doctor.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Doctor',
            onPressed: () => context.push('/doctors/${doctor.id}/edit'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.person), text: 'Overview'),
            Tab(icon: Icon(Icons.history), text: 'Visits'),
            Tab(icon: Icon(Icons.science), text: 'Samples'),
            Tab(icon: Icon(Icons.shopping_cart), text: 'Orders'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _OverviewTab(doctor: doctor, theme: theme),
          _VisitsTab(doctorId: doctor.id),
          _SamplesTab(doctorId: doctor.id),
          _OrdersTab(doctorId: doctor.id),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 360;
              if (compact) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton.outlined(
                      onPressed: () => context.push('/dcr/record', extra: {'doctorName': doctor.name}),
                      icon: const Icon(Icons.edit_note),
                      tooltip: 'Record DCR',
                    ),
                    IconButton.outlined(
                      onPressed: () => context.push('/samples/distribute', extra: doctor.id),
                      icon: const Icon(Icons.science),
                      tooltip: 'Sample',
                    ),
                    IconButton.filled(
                      onPressed: () => context.push('/orders/create', extra: doctor.id),
                      icon: const Icon(Icons.add_shopping_cart),
                      tooltip: 'Order',
                    ),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/dcr/record', extra: {'doctorName': doctor.name}),
                      icon: const Icon(Icons.edit_note, size: 18),
                      label: const Text('DCR'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/samples/distribute', extra: doctor.id),
                      icon: const Icon(Icons.science, size: 18),
                      label: const Text('Sample'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => context.push('/orders/create', extra: doctor.id),
                      icon: const Icon(Icons.add_shopping_cart, size: 18),
                      label: const Text('Order'),
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

class _OverviewTab extends StatelessWidget {
  final Doctor doctor;
  final ThemeData theme;
  const _OverviewTab({required this.doctor, required this.theme});

  @override
  Widget build(BuildContext context) {
    final initials = doctor.name
        .split(' ')
        .take(2)
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .join();

    return SingleChildScrollView(
      child: ResponsiveCenter(
        padding: adaptivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ProfileHeader(doctor: doctor, initials: initials, theme: theme),
            const SizedBox(height: 24),
            _InfoSection(title: 'Contact', children: [
              if (doctor.phone.isNotEmpty) _InfoRow(icon: Icons.phone, label: 'Phone', value: doctor.phone),
              if (doctor.clinicAddress.isNotEmpty) _InfoRow(icon: Icons.location_on, label: 'Address', value: doctor.clinicAddress),
              if (doctor.territory.isNotEmpty) _InfoRow(icon: Icons.map, label: 'Territory', value: doctor.territory),
              if (doctor.classification.isNotEmpty) _InfoRow(icon: Icons.star, label: 'Classification', value: doctor.classification),
            ]),
            const SizedBox(height: 16),
            _InfoSection(title: 'Visit History', children: [
              _InfoRow(icon: Icons.calendar_today, label: 'Last Visit', value: doctor.lastVisitDate != null ? AppFormatters.date(doctor.lastVisitDate!) : 'Never'),
              _InfoRow(icon: Icons.repeat, label: 'Visit Frequency', value: '${doctor.visitFrequency} visit${doctor.visitFrequency == 1 ? '' : 's'}'),
            ]),
            const SizedBox(height: 16),
            _InfoSection(title: 'Analytics', children: [_ConversionBar(probability: doctor.conversionProbability, theme: theme)]),
            if (doctor.latitude != 0 || doctor.longitude != 0) ...[
              const SizedBox(height: 16),
              _InfoSection(title: 'Location', children: [
                _InfoRow(icon: Icons.my_location, label: 'Coordinates', value: '${doctor.latitude.toStringAsFixed(4)}, ${doctor.longitude.toStringAsFixed(4)}'),
              ]),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _VisitsTab extends ConsumerWidget {
  final String doctorId;
  const _VisitsTab({required this.doctorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitsStream = ref.watch(visitRepositoryProvider).watchAll().map(
          (list) => list
              .where((v) => v.doctorId == doctorId)
              .toList()
            ..sort((a, b) => b.visitDate.compareTo(a.visitDate)),
        );
    return StreamBuilder<List<Visit>>(
      stream: visitsStream,
      builder: (context, snap) {
        if (!snap.hasData) return const ShimmerLoading();
        final visits = snap.data!;
        if (visits.isEmpty) {
          return const EmptyState(
            icon: Icons.history,
            title: 'No visits recorded',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: visits.length,
          itemBuilder: (_, i) {
            final v = visits[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.event),
                title: Text(DateFormat.yMMMd().add_jm().format(v.visitDate)),
                subtitle: Text(v.outcome.isNotEmpty ? v.outcome : v.notes),
                trailing: Icon(
                  v.isCompleted ? Icons.check_circle : Icons.schedule,
                  color: v.isCompleted ? Colors.green : Colors.orange,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

final _productNamesProvider = FutureProvider<Map<String, String>>((ref) async {
  final products = await ref.watch(productRepositoryProvider).getAll();
  return {for (final p in products) p.id: p.name};
});

class _SamplesTab extends ConsumerWidget {
  final String doctorId;
  const _SamplesTab({required this.doctorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.watch(sampleRepositoryProvider).watchForDoctor(doctorId);
    final productNames = ref.watch(_productNamesProvider).value ?? {};
    return StreamBuilder<List<Sample>>(
      stream: stream,
      builder: (context, snap) {
        if (!snap.hasData) return const ShimmerLoading();
        final samples = snap.data!;
        if (samples.isEmpty) {
          return const EmptyState(
            icon: Icons.science,
            title: 'No samples distributed',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: samples.length,
          itemBuilder: (_, i) {
            final s = samples[i];
            final productName = productNames[s.productId] ?? s.productId;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.medication),
                title: Text(productName),
                subtitle: Text('Qty: ${s.quantity} | Batch: ${s.batchNo}\n${DateFormat.yMMMd().format(s.date)}'),
                isThreeLine: true,
              ),
            );
          },
        );
      },
    );
  }
}

class _OrdersTab extends ConsumerWidget {
  final String doctorId;
  const _OrdersTab({required this.doctorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(authStateProvider).value?.uid ?? '';
    final stream = ref.watch(orderRepositoryProvider).watchForMr(uid).map(
          (list) => list
              .where((o) => o.doctorId == doctorId)
              .toList()
            ..sort((a, b) => b.orderDate.compareTo(a.orderDate)),
        );
    return StreamBuilder<List<Order>>(
      stream: stream,
      builder: (context, snap) {
        if (!snap.hasData) return const ShimmerLoading();
        final orders = snap.data!;
        if (orders.isEmpty) {
          return const EmptyState(
            icon: Icons.shopping_cart,
            title: 'No orders placed',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (_, i) {
            final o = orders[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.receipt),
                title: Text('Order #${o.id.substring(0, 8)}'),
                subtitle: Text('\u20B9${o.totalAmount.toStringAsFixed(2)} | ${DateFormat.yMMMd().format(o.orderDate)}'),
                trailing: Chip(label: Text(o.status.name), side: BorderSide.none),
                onTap: () => context.push('/orders/${o.id}'),
              ),
            );
          },
        );
      },
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final Doctor doctor;
  final String initials;
  final ThemeData theme;
  const _ProfileHeader({required this.doctor, required this.initials, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Hero(
              tag: 'doctor-avatar-${doctor.id}',
              child: CircleAvatar(
                radius: 40,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(initials, style: TextStyle(color: theme.colorScheme.onPrimaryContainer, fontWeight: FontWeight.w700, fontSize: 28)),
              ),
            ),
            const SizedBox(height: 16),
            Text(doctor.name, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center),
            if (doctor.specialization.isNotEmpty) ...[
              const SizedBox(height: 4),
              Chip(label: Text(doctor.specialization), backgroundColor: theme.colorScheme.secondaryContainer, side: BorderSide.none),
            ],
            if (doctor.classification.isNotEmpty) ...[
              const SizedBox(height: 4),
              Chip(label: Text('Class ${doctor.classification}'), backgroundColor: theme.colorScheme.tertiaryContainer, side: BorderSide.none),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _InfoSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (children.isEmpty) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.primary)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const Spacer(),
          Flexible(child: Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500), textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}

class _ConversionBar extends StatelessWidget {
  final double probability;
  final ThemeData theme;
  const _ConversionBar({required this.probability, required this.theme});

  @override
  Widget build(BuildContext context) {
    final percent = (probability * 100).clamp(0, 100);
    final color = percent >= 70 ? Colors.green : percent >= 40 ? Colors.orange : Colors.red;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Conversion Probability', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            Text('${percent.toStringAsFixed(0)}%', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: color)),
          ]),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(value: probability.clamp(0, 1), backgroundColor: theme.colorScheme.surfaceContainerHighest, valueColor: AlwaysStoppedAnimation(color), minHeight: 8),
          ),
        ],
      ),
    );
  }
}
