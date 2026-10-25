import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/utils/responsive.dart';
import '../../presentation/widgets/coming_soon_banner.dart';
import '../../presentation/widgets/platform_image.dart';

class ReceiptCaptureScreen extends StatefulWidget {
  const ReceiptCaptureScreen({super.key});

  @override
  State<ReceiptCaptureScreen> createState() => _ReceiptCaptureScreenState();
}

class _ReceiptCaptureScreenState extends State<ReceiptCaptureScreen> {
  final _picker = ImagePicker();
  String? _error;
  String? _previewPath;

  bool get _showCameraOption => !kIsWeb;

  Future<bool> _ensureCameraPermission() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                const Text('Camera permission is required to take photos'),
            action: SnackBarAction(
              label: 'Settings',
              onPressed: openAppSettings,
            ),
          ),
        );
      }
      return false;
    }
    return true;
  }

  Future<void> _pickImage(ImageSource source) async {
    if (source == ImageSource.camera) {
      final granted = await _ensureCameraPermission();
      if (!granted) return;
    }

    setState(() => _error = null);

    final image = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1920,
    );

    if (image == null) return;
    setState(() => _previewPath = image.path);
  }

  void _proceedWithImage() {
    context.go('/expense/review', extra: {
      'amount': 0.0,
      'date': null,
      'rawText': '',
      'imagePath': _previewPath,
    });
  }

  void _proceedManually() {
    context.go('/expense/review', extra: {
      'amount': 0.0,
      'date': null,
      'rawText': '',
      'imagePath': null,
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Capture Receipt'),
        actions: [
          if (_previewPath != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Retake',
              onPressed: () => setState(() => _previewPath = null),
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: adaptiveFormMaxWidth(context)),
            child: _previewPath != null
                ? _buildPreview(theme)
                : _buildCapturePicker(theme),
          ),
        ),
      ),
    );
  }

  Widget _buildPreview(ThemeData theme) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: PlatformImage(
              path: _previewPath!,
              fit: BoxFit.contain,
              width: double.infinity,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              _error!,
              style: TextStyle(color: theme.colorScheme.error),
              textAlign: TextAlign.center,
            ),
          ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => setState(() => _previewPath = null),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Retake'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _proceedWithImage,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Continue'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCapturePicker(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long,
              size: 80,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Capture or select a receipt',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Attach a receipt image or enter details manually',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const ComingSoonBanner(
              feature: 'AI receipt scanning coming soon',
              icon: Icons.document_scanner,
            ),
            const SizedBox(height: 24),
            if (_showCameraOption) ...[
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Take Photo'),
                ),
              ),
              const SizedBox(height: 12),
            ],
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_library),
                label: const Text('Choose from Gallery'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: _proceedManually,
                icon: const Icon(Icons.edit_note),
                label: const Text('Enter Manually (Skip Receipt)'),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(
                _error!,
                style: TextStyle(color: theme.colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
