import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final bool filled;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.filled = false,
  });

  factory StatusBadge.fromName(String name) {
    final color = _colorForStatus(name);
    return StatusBadge(label: name, color: color);
  }

  static Color _colorForStatus(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'confirmed':
      case 'delivered':
      case 'active':
      case 'completed':
        return Colors.green;
      case 'pending':
      case 'submitted':
      case 'dispatched':
        return Colors.orange;
      case 'rejected':
      case 'cancelled':
      case 'inactive':
        return Colors.red;
      case 'draft':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: filled ? color : color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: filled ? Colors.white : color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
