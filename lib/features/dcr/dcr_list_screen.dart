import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/providers/core_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart';
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/error_retry_card.dart';
import '../../presentation/widgets/shimmer_loading.dart';

final _dcrsProvider = StreamProvider<List<Dcr>>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return Stream.value([]);
  return ref.watch(dcrRepositoryProvider).watchByMr(uid);
});

class DcrListScreen extends ConsumerStatefulWidget {
  const DcrListScreen({super.key});

  @override
  ConsumerState<DcrListScreen> createState() => _DcrListScreenState();
}

class _DcrListScreenState extends ConsumerState<DcrListScreen> {
  String _search = '';

  void _showDcrDetail(BuildContext context, Dcr dcr) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, controller) => Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            controller: controller,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text('DCR Details', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              _detailRow(theme, 'Doctor', dcr.doctorName),
              _detailRow(theme, 'Date', DateFormat.yMMMMd().format(dcr.createdAt)),
              _detailRow(theme, 'Products Discussed', dcr.productsDiscussed),
              if (dcr.notes.isNotEmpty)
                _detailRow(theme, 'Notes', dcr.notes),
              if (dcr.followUpDate != null)
                _detailRow(theme, 'Follow Up', DateFormat.yMMMd().format(dcr.followUpDate!)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 4),
          Text(value, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dcrsAsync = ref.watch(_dcrsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('DCR History')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/dcr/record'),
        icon: const Icon(Icons.mic),
        label: const Text('New DCR'),
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: adaptiveMaxWidth(context),
          padding: adaptivePadding(context),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search DCRs...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  isDense: true,
                ),
                onChanged: (v) => setState(() => _search = v),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => ref.invalidate(_dcrsProvider),
                  child: dcrsAsync.when(
                    data: (dcrs) {
                      var filtered = dcrs;
                      if (_search.isNotEmpty) {
                        final q = _search.toLowerCase();
                        filtered = filtered
                            .where((d) =>
                                d.doctorName.toLowerCase().contains(q) ||
                                d.productsDiscussed.toLowerCase().contains(q))
                            .toList();
                      }
                      if (filtered.isEmpty) {
                        return CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: const EmptyState(
                                icon: Icons.edit_note_outlined,
                                title: 'No DCRs found',
                              ),
                            ),
                          ],
                        );
                      }
                      return ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final d = filtered[i];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: theme.colorScheme.primaryContainer,
                                child: Text(d.doctorName.isNotEmpty ? d.doctorName[0] : '?',
                                    style: TextStyle(color: theme.colorScheme.onPrimaryContainer)),
                              ),
                              title: Text(d.doctorName, style: const TextStyle(fontWeight: FontWeight.w600)),
                              subtitle: Text(
                                  '${DateFormat.yMMMd().format(d.createdAt)} \u2022 ${d.productsDiscussed}'),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => _showDcrDetail(context, d),
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const ShimmerLoading(),
                    error: (e, _) => CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: ErrorRetryCard(
                            message: e.toString(),
                            onRetry: () => ref.invalidate(_dcrsProvider),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
