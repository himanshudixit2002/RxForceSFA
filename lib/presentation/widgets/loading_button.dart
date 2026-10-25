import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final bool expanded;

  const LoadingButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.label,
    this.icon,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 18),
                  const SizedBox(width: 8),
                  Text(label),
                ],
              )
            : Text(label);

    final button = FilledButton(
      onPressed: isLoading ? null : onPressed,
      child: child,
    );

    return expanded
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }
}
