import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:go_router/go_router.dart';

import '../../core/providers/core_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart';
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/shimmer_loading.dart';

class CampaignDetailScreen extends ConsumerStatefulWidget {
  final String campaignId;
  const CampaignDetailScreen({super.key, required this.campaignId});

  @override
  ConsumerState<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
}

class _CampaignDetailScreenState extends ConsumerState<CampaignDetailScreen> {
  Campaign? _campaign;
  bool _loading = true;
  Map<String, String> _doctorNames = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final c = await ref.read(campaignRepositoryProvider).getById(widget.campaignId);
    final doctors = await ref.read(doctorRepositoryProvider).getAll();
    final dMap = {for (final d in doctors) d.id: d.name};
    if (mounted) setState(() { _campaign = c; _doctorNames = dMap; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Campaign')),
        body: const ShimmerLoading(itemCount: 5),
      );
    }
    if (_campaign == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Campaign')),
        body: const Center(child: Text('Campaign not found')),
      );
    }

    final c = _campaign!;
    final isActive = c.status == 'active';
    List<String> targetDoctors = [];
    try {
      targetDoctors = (jsonDecode(c.targetDoctors) as List).cast<String>();
    } catch (_) {}

    final daysLeft = c.endDate.difference(DateTime.now()).inDays;

    return Scaffold(
      appBar: AppBar(
        title: Text(c.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Campaign',
            onPressed: () => context.push('/admin/campaigns/${widget.campaignId}/edit'),
          ),
        ],
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          padding: adaptivePadding(context),
          child: ListView(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: (isActive ? Colors.green : Colors.grey).withValues(alpha: 0.15),
                            child: Icon(Icons.campaign, color: isActive ? Colors.green : Colors.grey),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c.name, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: (isActive ? Colors.green : Colors.grey).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(c.status.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: isActive ? Colors.green : Colors.grey)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      _infoRow(theme, 'Start Date', DateFormat.yMMMd().format(c.startDate)),
                      _infoRow(theme, 'End Date', DateFormat.yMMMd().format(c.endDate)),
                      _infoRow(theme, 'Days Left', daysLeft > 0 ? '$daysLeft days' : 'Ended'),
                      if (c.description.isNotEmpty) _infoRow(theme, 'Description', c.description),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Target Doctors (${targetDoctors.length})',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (targetDoctors.isEmpty)
                const EmptyState(icon: Icons.people_outline, title: 'No target doctors assigned')
              else
                ...targetDoctors.map((d) => Card(
                  margin: const EdgeInsets.only(bottom: 4),
                  child: ListTile(
                    leading: const Icon(Icons.local_hospital),
                    title: Text(_doctorNames[d] ?? d),
                  ),
                )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant))),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
