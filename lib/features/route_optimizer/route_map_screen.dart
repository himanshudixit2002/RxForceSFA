import 'package:flutter/material.dart';

import '../../core/utils/responsive.dart';
import '../../presentation/widgets/coming_soon_banner.dart';

class RouteMapScreen extends StatelessWidget {
  const RouteMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Route Optimizer')),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: adaptiveFormMaxWidth(context)),
          child: Padding(
            padding: adaptivePadding(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.route,
                  size: 80,
                  color: theme.colorScheme.primary.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 24),
                const ComingSoonBanner(
                  feature:
                      'AI-powered route optimization is coming soon. Plan your visits manually for now.',
                  icon: Icons.alt_route,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
