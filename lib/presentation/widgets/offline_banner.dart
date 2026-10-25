import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/core_providers.dart';

class OfflineBanner extends ConsumerWidget {
  final Widget child;

  const OfflineBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityProvider);
    final isOffline =
        connectivity.whenOrNull(
          data: (results) => results.contains(ConnectivityResult.none),
        ) ??
        false;

    return Column(
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: isOffline
              ? Semantics(
                  label: 'Offline mode active',
                  child: MaterialBanner(
                    content: const Text('You are offline'),
                    leading: const Icon(Icons.cloud_off),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    actions: const [SizedBox.shrink()],
                    backgroundColor:
                        Theme.of(context).colorScheme.errorContainer,
                    forceActionsBelow: true,
                  ),
                )
              : const SizedBox.shrink(),
        ),
        Expanded(child: child),
      ],
    );
  }
}
