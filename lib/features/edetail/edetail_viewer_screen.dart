import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/providers/core_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart';
import '../../presentation/widgets/shimmer_loading.dart';

class EDetailViewerScreen extends ConsumerStatefulWidget {
  final String contentId;
  const EDetailViewerScreen({super.key, required this.contentId});

  @override
  ConsumerState<EDetailViewerScreen> createState() => _EDetailViewerScreenState();
}

class _EDetailViewerScreenState extends ConsumerState<EDetailViewerScreen> {
  EDetailContent? _content;
  bool _loading = true;
  String _productName = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final c = await ref.read(edetailRepositoryProvider).getById(widget.contentId);
    String productName = c?.productId ?? '';
    if (c != null) {
      final product = await ref.read(productRepositoryProvider).getById(c.productId);
      if (product != null) productName = product.name;
    }
    if (mounted) setState(() { _content = c; _productName = productName; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('E-Detail')),
        body: const ShimmerLoading(itemCount: 5),
      );
    }
    if (_content == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('E-Detail')),
        body: const Center(child: Text('Content not found')),
      );
    }

    final c = _content!;

    return Scaffold(
      appBar: AppBar(title: Text(c.title)),
      body: SafeArea(
        child: ResponsiveCenter(
          padding: adaptivePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: theme.colorScheme.tertiaryContainer,
                        child: Icon(_iconForType(c.type), size: 40, color: theme.colorScheme.onTertiaryContainer),
                      ),
                      const SizedBox(height: 16),
                      Text(c.title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      const SizedBox(height: 8),
                      Chip(label: Text(c.type.toUpperCase()), side: BorderSide.none, backgroundColor: theme.colorScheme.secondaryContainer),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _row(theme, 'Product', _productName),
                      _row(theme, 'Version', c.version),
                      _row(theme, 'Status', c.isActive ? 'Active' : 'Inactive'),
                      if (c.url.isNotEmpty) _row(theme, 'URL', c.url),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              if (c.url.isNotEmpty)
                FilledButton.icon(
                  onPressed: () async {
                    final uri = Uri.tryParse(c.url);
                    if (uri != null && await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    } else if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Could not open URL')),
                      );
                    }
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Open Content'),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant))),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'pdf': return Icons.picture_as_pdf;
      case 'video': return Icons.videocam;
      case 'image': return Icons.image;
      default: return Icons.description;
    }
  }
}
