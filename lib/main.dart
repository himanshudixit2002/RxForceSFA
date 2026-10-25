import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/providers/core_providers.dart';
import 'core/services/firebase_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/sync_service.dart';
import 'presentation/navigation/app_router.dart';
import 'presentation/themes/app_theme.dart';
import 'presentation/widgets/offline_banner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  try {
    await SyncService.initialize();
  } catch (e) {
    debugPrint('SyncService init failed (non-fatal): $e');
  }
  try {
    await NotificationService.instance.initialize();
  } catch (e) {
    debugPrint('NotificationService init failed (non-fatal): $e');
  }
  runApp(const ProviderScope(child: RxForceSFAApp()));
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final user = ref.watch(authStateProvider.select((s) => s.value));
  final router = AppRouter.router(user);
  NotificationService.instance.setRouter(router);
  return router;
});

class RxForceSFAApp extends ConsumerStatefulWidget {
  const RxForceSFAApp({super.key});

  @override
  ConsumerState<RxForceSFAApp> createState() => _RxForceSFAAppState();
}

class _RxForceSFAAppState extends ConsumerState<RxForceSFAApp> {
  bool _initialSyncDone = false;
  bool _wasOffline = false;

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen(_onConnectivityChanged);
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final isOffline = results.contains(ConnectivityResult.none);
    if (_wasOffline && !isOffline && !kIsWeb) {
      SyncService.performSync();
    }
    _wasOffline = isOffline;
  }

  void _triggerStartupSync() {
    if (_initialSyncDone) return;
    _initialSyncDone = true;
    if (!kIsWeb) SyncService.performSync();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          _triggerStartupSync();
        }
        final router = ref.watch(goRouterProvider);
        return MaterialApp.router(
          title: 'RxForce SFA',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          routerConfig: router,
          builder: (context, child) {
            return OfflineBanner(child: child ?? const SizedBox.shrink());
          },
        );
      },
      loading: () => MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const _SplashScreen(),
      ),
      error: (e, _) => MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: _InitErrorScreen(error: e),
      ),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 20),
            Text(
              'RxForce SFA',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 160,
              child: LinearProgressIndicator(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InitErrorScreen extends StatefulWidget {
  final Object error;
  const _InitErrorScreen({required this.error});

  @override
  State<_InitErrorScreen> createState() => _InitErrorScreenState();
}

class _InitErrorScreenState extends State<_InitErrorScreen> {
  bool _retrying = false;

  Future<void> _retry() async {
    setState(() => _retrying = true);
    try {
      await FirebaseService.initialize();
      await SyncService.initialize();
      if (mounted) {
        runApp(const ProviderScope(child: RxForceSFAApp()));
      }
    } catch (_) {
      if (mounted) setState(() => _retrying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to initialize',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please check your connection and try again.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _retrying ? null : _retry,
                icon: _retrying
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
