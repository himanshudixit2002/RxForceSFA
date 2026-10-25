import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/providers/core_providers.dart';
import '../../core/providers/user_providers.dart';
import '../../core/services/approval_service.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart';
import '../../presentation/widgets/shimmer_loading.dart';

class ApprovalDetailScreen extends ConsumerStatefulWidget {
  final String approvalId;
  const ApprovalDetailScreen({super.key, required this.approvalId});

  @override
  ConsumerState<ApprovalDetailScreen> createState() =>
      _ApprovalDetailScreenState();
}

class _ApprovalDetailScreenState extends ConsumerState<ApprovalDetailScreen> {
  Approval? _approval;
  bool _loading = true;
  bool _processing = false;
  String _requesterName = '';
  final _commentCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await ref.read(approvalRepositoryProvider).getById(widget.approvalId);
    String requesterName = result?.requesterId ?? '';
    if (result != null) {
      final user = await ref.read(userRepositoryProvider).getUserById(result.requesterId);
      if (user != null) requesterName = user.name;
    }
    if (mounted) setState(() { _approval = result; _requesterName = requesterName; _loading = false; });
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _process(ApprovalStatus status) async {
    if (_approval == null) return;
    setState(() => _processing = true);

    try {
      final service = ApprovalService(
        ref.read(approvalRepositoryProvider),
        ref.read(notificationRepositoryProvider),
      );
      await service.processApproval(
        approvalId: _approval!.id,
        newStatus: status,
        comments: _commentCtrl.text,
        requesterId: _approval!.requesterId,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(status == ApprovalStatus.approved
                  ? 'Approved'
                  : 'Rejected')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Something went wrong. Please try again.')));
      }
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Approval Detail')),
        body: const ShimmerLoading(itemCount: 5),
      );
    }

    if (_approval == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Approval Detail')),
        body: const Center(child: Text('Not found')),
      );
    }

    final a = _approval!;
    final isPending = a.status == ApprovalStatus.pending;

    return Scaffold(
      appBar: AppBar(title: const Text('Approval Detail')),
      body: SafeArea(
        child: ResponsiveCenter(
          padding: adaptivePadding(context),
          child: ListView(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _row('Type', a.type.name.toUpperCase()),
                      _row('Requester', _requesterName),
                      _row('Date', DateFormat.yMMMd().format(a.createdAt)),
                      _row('Status', a.status.name.toUpperCase()),
                      if (a.comments.isNotEmpty)
                        _row('Comments', a.comments),
                    ],
                  ),
                ),
              ),
              if (isPending) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _commentCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Comments',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _processing
                            ? null
                            : () => _process(ApprovalStatus.rejected),
                        icon: const Icon(Icons.close, color: Colors.red),
                        label: const Text('Reject',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _processing
                            ? null
                            : () => _process(ApprovalStatus.approved),
                        icon: const Icon(Icons.check),
                        label: const Text('Approve'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ),
          Expanded(
              child: Text(value,
                  style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
