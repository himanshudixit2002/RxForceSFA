import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';

class PendingSyncBadge extends ConsumerWidget {
  const PendingSyncBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final pending = ref.watch(pendingSyncCountProvider);

    final count = pending.value ?? 0;
    if (count == 0) return const SizedBox.shrink();

    return Tooltip(
      message: '$count item${count == 1 ? '' : 's'} waiting to sync',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: Badge(
            key: ValueKey(count),
            label: Text('$count'),
            child: Icon(
              Icons.cloud_upload_outlined,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
