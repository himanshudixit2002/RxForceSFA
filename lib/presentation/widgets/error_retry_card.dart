import 'package:flutter/material.dart';

class ErrorRetryCard extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorRetryCard({
    super.key,
    this.message = 'Something went wrong',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 12),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              Semantics(
                button: true,
                label: 'Retry action',
                child: FilledButton.tonal(
                  onPressed: onRetry,
                  child: const Text('Retry'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
