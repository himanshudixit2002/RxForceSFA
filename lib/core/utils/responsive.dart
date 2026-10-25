import 'package:flutter/material.dart';

class Breakpoints {
  Breakpoints._();

  static const double compact = 600;
  static const double medium = 900;
  static const double expanded = 1200;
}

enum ScreenType { compact, medium, expanded }

ScreenType screenTypeOf(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width >= Breakpoints.expanded) return ScreenType.expanded;
  if (width >= Breakpoints.compact) return ScreenType.medium;
  return ScreenType.compact;
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenType screenType) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final ScreenType type;
        if (constraints.maxWidth >= Breakpoints.expanded) {
          type = ScreenType.expanded;
        } else if (constraints.maxWidth >= Breakpoints.compact) {
          type = ScreenType.medium;
        } else {
          type = ScreenType.compact;
        }
        return builder(context, type);
      },
    );
  }
}

EdgeInsets adaptivePadding(BuildContext context) {
  final type = screenTypeOf(context);
  switch (type) {
    case ScreenType.compact:
      return const EdgeInsets.all(16);
    case ScreenType.medium:
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 20);
    case ScreenType.expanded:
      return const EdgeInsets.symmetric(horizontal: 48, vertical: 24);
  }
}

double adaptiveMaxWidth(BuildContext context) {
  final type = screenTypeOf(context);
  switch (type) {
    case ScreenType.compact:
      return double.infinity;
    case ScreenType.medium:
      return 840;
    case ScreenType.expanded:
      return 1200;
  }
}

int adaptiveGridColumns(BuildContext context) {
  final type = screenTypeOf(context);
  switch (type) {
    case ScreenType.compact:
      return 3;
    case ScreenType.medium:
      return 4;
    case ScreenType.expanded:
      return 6;
  }
}

double adaptiveFormMaxWidth(BuildContext context) {
  final type = screenTypeOf(context);
  switch (type) {
    case ScreenType.compact:
      return double.infinity;
    case ScreenType.medium:
      return 600;
    case ScreenType.expanded:
      return 700;
  }
}

/// Wraps content in a centered, max-width constrained container
class ResponsiveCenter extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;

  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? adaptiveFormMaxWidth(context),
        ),
        child: padding != null
            ? Padding(padding: padding!, child: child)
            : child,
      ),
    );
  }
}
