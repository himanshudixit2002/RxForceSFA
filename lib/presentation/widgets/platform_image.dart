import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'platform_image_io.dart' if (dart.library.html) 'platform_image_web.dart'
    as platform;

class PlatformImage extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const PlatformImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty) {
      final placeholder = _errorPlaceholder(context);
      if (borderRadius != null) {
        return ClipRRect(borderRadius: borderRadius!, child: placeholder);
      }
      return placeholder;
    }

    final isUrl = path.startsWith('http://') || path.startsWith('https://');

    Widget image;
    if (isUrl) {
      image = CachedNetworkImage(
        imageUrl: path,
        fit: fit,
        width: width,
        height: height,
        fadeInDuration: const Duration(milliseconds: 200),
        placeholder: (context, _) => _shimmerPlaceholder(context),
        errorWidget: (context, _, __) => _errorPlaceholder(context),
      );
    } else if (kIsWeb) {
      image = Image.network(
        path,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, __, ___) => _errorPlaceholder(context),
      );
    } else {
      image = platform.buildFileImage(
        path: path,
        fit: fit,
        width: width,
        height: height,
        errorPlaceholder: _errorPlaceholder(context),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }

  Widget _shimmerPlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    return Shimmer.fromColors(
      baseColor: theme.colorScheme.surfaceContainerHighest,
      highlightColor: theme.colorScheme.surface,
      child: Container(
        width: width,
        height: height,
        color: theme.colorScheme.surfaceContainerHighest,
      ),
    );
  }

  Widget _errorPlaceholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.broken_image_outlined,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
