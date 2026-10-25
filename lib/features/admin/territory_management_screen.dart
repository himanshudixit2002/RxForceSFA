import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/user_providers.dart';
import '../../core/utils/responsive.dart';
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/error_retry_card.dart';
import '../../presentation/widgets/shimmer_loading.dart';

class TerritoryManagementScreen extends ConsumerWidget {
  const TerritoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final territoriesAsync = ref.watch(allTerritoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Territory Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Territory',
            onPressed: () => context.go('/admin/territories/new'),
          ),
        ],
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: adaptiveMaxWidth(context),
          padding: adaptivePadding(context),
          child: territoriesAsync.when(
            data: (territories) {
              if (territories.isEmpty) {
                return EmptyState(
                  icon: Icons.map,
                  title: 'No territories',
                  subtitle: 'Add territories to get started',
                  action: FilledButton.icon(
                    onPressed: () =>
                        context.go('/admin/territories/new'),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Territory'),
                  ),
                );
              }
              final roots =
                  territories.where((t) => t.parentId.isEmpty).toList();
              return ListView(
                children: roots.map((root) {
                  final children = territories
                      .where((t) => t.parentId == root.id)
                      .toList();
                  return ExpansionTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(root.name,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('Level ${root.level}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () =>
                          context.go('/admin/territories/${root.id}'),
                    ),
                    children: children
                        .map((child) => ListTile(
                              contentPadding:
                                  const EdgeInsets.only(left: 48),
                              leading: const Icon(Icons.subdirectory_arrow_right),
                              title: Text(child.name),
                              subtitle: Text('Level ${child.level}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => context
                                    .go('/admin/territories/${child.id}'),
                              ),
                            ))
                        .toList(),
                  );
                }).toList(),
              );
            },
            loading: () => const ShimmerLoading(itemCount: 5),
            error: (e, _) => ErrorRetryCard(
              message: 'Failed to load territories',
              onRetry: () => ref.invalidate(allTerritoriesProvider),
            ),
          ),
        ),
      ),
    );
  }
}
