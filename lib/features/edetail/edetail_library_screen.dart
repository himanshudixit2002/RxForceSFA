import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/core_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart';
import '../../presentation/widgets/empty_state.dart';
import '../../presentation/widgets/error_retry_card.dart';
import '../../presentation/widgets/shimmer_loading.dart';

final _edetailsProvider = StreamProvider<List<EDetailContent>>((ref) {
  return ref.watch(edetailRepositoryProvider).watchAll();
});

class EDetailLibraryScreen extends ConsumerStatefulWidget {
  const EDetailLibraryScreen({super.key});

  @override
  ConsumerState<EDetailLibraryScreen> createState() =>
      _EDetailLibraryScreenState();
}

class _EDetailLibraryScreenState extends ConsumerState<EDetailLibraryScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contentsAsync = ref.watch(_edetailsProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search presentations...',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
        ),
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: adaptiveMaxWidth(context),
          padding: adaptivePadding(context),
          child: contentsAsync.when(
            data: (contents) {
              final filtered = contents
                  .where((e) =>
                      e.title.toLowerCase().contains(_searchQuery) ||
                      e.productId.toLowerCase().contains(_searchQuery))
                  .toList();
              if (filtered.isEmpty) {
                return const EmptyState(
                  icon: Icons.slideshow_outlined,
                  title: 'No content available',
                );
              }
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: adaptiveGridColumns(context).clamp(2, 4),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, i) {
                  final c = filtered[i];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => context.go('/edetail/${c.id}'),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  theme.colorScheme.tertiaryContainer,
                              child: Icon(_iconForType(c.type),
                                  color: theme.colorScheme.onTertiaryContainer),
                            ),
                            const Spacer(),
                            Text(c.title,
                                style: theme.textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Text(c.type.toUpperCase(),
                                style: theme.textTheme.labelSmall?.copyWith(
                                    color:
                                        theme.colorScheme.onSurfaceVariant)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const ShimmerLoading(),
            error: (e, _) => ErrorRetryCard(
              message: e.toString(),
              onRetry: () => ref.invalidate(_edetailsProvider),
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'video':
        return Icons.videocam;
      case 'image':
        return Icons.image;
      default:
        return Icons.description;
    }
  }
}
