import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../core/providers/core_providers.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/database.dart';
import '../../presentation/widgets/error_retry_card.dart';
import '../../presentation/widgets/shimmer_loading.dart';

final _todayAttendanceProvider = FutureProvider<Attendance?>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return null;
  return ref.watch(attendanceRepositoryProvider).getTodayAttendance(uid);
});

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  bool _processing = false;

  Future<Position> _getPosition() async {
    await Geolocator.requestPermission();
    return Geolocator.getCurrentPosition();
  }

  Future<void> _punchIn() async {
    setState(() => _processing = true);
    try {
      String selfiePath = '';
      double lat = 0.0;
      double lng = 0.0;

      if (!kIsWeb) {
        final picker = ImagePicker();
        final photo = await picker.pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front,
          maxWidth: 640,
          imageQuality: 70,
        );
        if (photo == null) {
          if (mounted) setState(() => _processing = false);
          return;
        }
        selfiePath = photo.path;
        final pos = await _getPosition();
        lat = pos.latitude;
        lng = pos.longitude;
      }

      final uid = ref.read(authStateProvider).value?.uid ?? '';
      await ref.read(attendanceRepositoryProvider).punchIn(
            id: const Uuid().v4(),
            mrId: uid,
            lat: lat,
            lng: lng,
            selfie: selfiePath,
          );
      ref.invalidate(_todayAttendanceProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Punched in successfully')),
        );
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

  Future<void> _punchOut(String attendanceId) async {
    setState(() => _processing = true);
    try {
      double lat = 0.0;
      double lng = 0.0;

      if (!kIsWeb) {
        final pos = await _getPosition();
        lat = pos.latitude;
        lng = pos.longitude;
      }

      await ref.read(attendanceRepositoryProvider).punchOut(
            id: attendanceId,
            lat: lat,
            lng: lng,
          );
      ref.invalidate(_todayAttendanceProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Punched out successfully')),
        );
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
    final todayAsync = ref.watch(_todayAttendanceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        actions: [
          TextButton.icon(
            onPressed: () => context.push('/attendance/history'),
            icon: const Icon(Icons.history, size: 18),
            label: const Text('History'),
          ),
        ],
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          padding: adaptivePadding(context),
          child: todayAsync.when(
            data: (today) {
              final hasPunchedIn = today?.punchInTime != null;
              final hasPunchedOut = today?.punchOutTime != null;

              return Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(
                            hasPunchedIn
                                ? (hasPunchedOut
                                    ? Icons.check_circle
                                    : Icons.access_time)
                                : Icons.fingerprint,
                            size: 64,
                            color: hasPunchedIn
                                ? (hasPunchedOut
                                    ? Colors.green
                                    : Colors.orange)
                                : theme.colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            hasPunchedOut
                                ? 'Day Complete'
                                : (hasPunchedIn
                                    ? 'Working...'
                                    : 'Not Punched In'),
                            style: theme.textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            DateFormat.yMMMMd().format(DateTime.now()),
                            style: theme.textTheme.bodyMedium?.copyWith(
                                color:
                                    theme.colorScheme.onSurfaceVariant),
                          ),
                          if (hasPunchedIn && today?.punchInTime != null) ...[
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.login, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                    'In: ${DateFormat.jm().format(today!.punchInTime!)}'),
                                if (hasPunchedOut &&
                                    today.punchOutTime != null) ...[
                                  const SizedBox(width: 24),
                                  const Icon(Icons.logout, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                      'Out: ${DateFormat.jm().format(today.punchOutTime!)}'),
                                ],
                              ],
                            ),
                          ],
                          if (hasPunchedIn && hasPunchedOut &&
                              today!.punchInTime != null && today.punchOutTime != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Working hours: ${today.punchOutTime!.difference(today.punchInTime!).inHours}h ${today.punchOutTime!.difference(today.punchInTime!).inMinutes % 60}m',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                          const SizedBox(height: 24),
                          if (!hasPunchedIn)
                            FilledButton.icon(
                              onPressed: _processing ? null : _punchIn,
                              icon: _processing
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child:
                                          CircularProgressIndicator(
                                              strokeWidth: 2))
                                  : const Icon(Icons.login),
                              label: const Text('Punch In'),
                            )
                          else if (!hasPunchedOut)
                            OutlinedButton.icon(
                              onPressed: _processing
                                  ? null
                                  : () => _punchOut(today!.id),
                              icon: _processing
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child:
                                          CircularProgressIndicator(
                                              strokeWidth: 2))
                                  : const Icon(Icons.logout),
                              label: const Text('Punch Out'),
                            ),
                          if (kIsWeb) ...[
                            const SizedBox(height: 12),
                            Text(
                              'Selfie and location are captured on mobile only',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => const ShimmerLoading(itemCount: 3),
            error: (e, _) => ErrorRetryCard(
              message: 'Failed to load attendance',
              onRetry: () => ref.invalidate(_todayAttendanceProvider),
            ),
          ),
        ),
      ),
    );
  }
}
