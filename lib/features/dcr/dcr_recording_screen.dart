import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/responsive.dart';
import '../../presentation/widgets/coming_soon_banner.dart';

class DcrRecordingScreen extends StatefulWidget {
  final String? doctorName;
  final String? visitId;

  const DcrRecordingScreen({super.key, this.doctorName, this.visitId});

  @override
  State<DcrRecordingScreen> createState() => _DcrRecordingScreenState();
}

class _DcrRecordingScreenState extends State<DcrRecordingScreen> {
  final _textController = TextEditingController();

  void _proceedToReview() {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your call report first')),
      );
      return;
    }
    context.go('/dcr/review', extra: <String, dynamic>{
      'transcript': text,
      'doctorName': widget.doctorName,
      'visitId': widget.visitId,
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasText = _textController.text.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Call Report'),
        actions: [
          if (hasText)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Clear',
              onPressed: () => setState(() => _textController.clear()),
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: adaptiveFormMaxWidth(context),
            ),
            child: Padding(
              padding: adaptivePadding(context),
              child: Column(
                children: [
                  const ComingSoonBanner(
                    feature: 'Voice recording and AI parsing coming soon',
                    icon: Icons.mic,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText:
                            'Type your call report here...\n\n'
                            'Example: "Visited Dr. Sharma today, discussed '
                            'Amoxicillin and Metformin tablets. '
                            'Follow up scheduled for next Monday."',
                        hintMaxLines: 8,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16)),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerLowest,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: hasText ? _proceedToReview : null,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Continue'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
