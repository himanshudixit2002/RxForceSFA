import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../core/models/user_role.dart';
import '../../features/admin/admin_dashboard_screen.dart';
import '../../features/admin/territory_form_screen.dart';
import '../../features/admin/territory_management_screen.dart';
import '../../features/admin/user_form_screen.dart';
import '../../features/admin/user_management_screen.dart';
import '../../features/approval/approval_detail_screen.dart';
import '../../features/approval/approval_queue_screen.dart';
import '../../features/attendance/attendance_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/attendance/attendance_history_screen.dart';
import '../../features/campaign/campaign_create_screen.dart';
import '../../features/campaign/campaign_detail_screen.dart';
import '../../features/campaign/campaign_list_screen.dart';
import '../../features/doctor/doctor_form_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/dcr/dcr_list_screen.dart';
import '../../features/dcr/dcr_recording_screen.dart';
import '../../features/dcr/dcr_review_screen.dart';
import '../../features/doctor/doctor_detail_screen.dart';
import '../../features/doctor/doctor_list_screen.dart';
import '../../features/edetail/edetail_library_screen.dart';
import '../../features/edetail/edetail_viewer_screen.dart';
import '../../features/expense/expense_list_screen.dart';
import '../../features/manager/manager_dashboard_screen.dart';
import '../../features/manager/team_list_screen.dart';
import '../../features/expense/expense_review_screen.dart';
import '../../features/expense/receipt_capture_screen.dart';
import '../../features/leave/leave_request_screen.dart';
import '../../features/more/more_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/notifications/notification_list_screen.dart';
import '../../features/order/order_create_screen.dart';
import '../../features/order/order_detail_screen.dart';
import '../../features/order/order_list_screen.dart';
import '../../features/product/product_detail_screen.dart';
import '../../features/product/product_form_screen.dart';
import '../../features/product/product_list_screen.dart';
import '../../features/sample/sample_allocation_screen.dart';
import '../../features/target/target_assign_screen.dart';
import '../../features/reports/activity_report_screen.dart';
import '../../features/reports/reports_home_screen.dart';
import '../../features/reports/sales_report_screen.dart';
import '../../features/route_optimizer/route_map_screen.dart';
import '../../features/sample/sample_distribution_screen.dart';
import '../../features/sample/sample_stock_screen.dart';
import '../../features/target/target_dashboard_screen.dart';
import '../../features/tour_plan/tour_plan_create_screen.dart';
import '../../features/tour_plan/tour_plan_detail_screen.dart';
import '../../features/tour_plan/tour_plan_list_screen.dart';
import '../../data/models/database.dart';
import 'role_based_shell.dart';

class AuthNotifier extends ChangeNotifier {
  fb.User? _user;
  fb.User? get user => _user;

  void update(fb.User? user) {
    if (_user?.uid != user?.uid) {
      _user = user;
      notifyListeners();
    } else {
      _user = user;
    }
  }
}

class RoleNotifier extends ChangeNotifier {
  UserRole _role = UserRole.mr;
  UserRole get role => _role;

  void update(UserRole role) {
    if (_role != role) {
      _role = role;
      notifyListeners();
    }
  }
}

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();
  static final authNotifier = AuthNotifier();
  static final roleNotifier = RoleNotifier();

  static GoRouter? _cachedRouter;

  static GoRouter router(fb.User? currentUser, {UserRole role = UserRole.mr}) {
    authNotifier.update(currentUser);
    roleNotifier.update(role);
    if (_cachedRouter != null) return _cachedRouter!;

    _cachedRouter = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/',
      refreshListenable: authNotifier,
      redirect: (context, state) {
        final isLoggedIn = authNotifier.user != null;
        final isAuthRoute = state.matchedLocation == '/login' ||
            state.matchedLocation == '/register';
        if (!isLoggedIn && !isAuthRoute) return '/login';
        if (isLoggedIn && isAuthRoute) return '/';
        return null;
      },
      errorBuilder: (context, state) => const _NotFoundScreen(),
      routes: [
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const LoginScreen(),
            transitionsBuilder: _fadeTransition,
          ),
        ),
        GoRoute(
          path: '/register',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const RegisterScreen(),
            transitionsBuilder: _slideTransition,
          ),
        ),
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) => RoleBasedShell(child: child),
          routes: [
            // ─── Home / Dashboard ───
            GoRoute(
              path: '/',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const DashboardScreen(),
                transitionsBuilder: _fadeTransition,
              ),
            ),

            // ─── DCR ───
            GoRoute(
              path: '/dcr',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const DcrListScreen(),
                transitionsBuilder: _fadeTransition,
              ),
            ),

            // ─── Tour Plans ───
            GoRoute(
              path: '/tour-plan',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const TourPlanListScreen(),
                transitionsBuilder: _fadeTransition,
              ),
            ),

            // ─── Doctors ───
            GoRoute(
              path: '/doctors',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const DoctorListScreen(),
                transitionsBuilder: _fadeTransition,
              ),
            ),

            // ─── More ───
            GoRoute(
              path: '/more',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const MoreScreen(),
                transitionsBuilder: _fadeTransition,
              ),
            ),

            // ─── Admin: Dashboard ───
            GoRoute(
              path: '/admin/dashboard',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const AdminDashboardScreen(),
                transitionsBuilder: _fadeTransition,
              ),
            ),

            // ─── Admin: Users ───
            GoRoute(
              path: '/admin/users',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const UserManagementScreen(),
                transitionsBuilder: _fadeTransition,
              ),
            ),

            // ─── Admin: Approvals ───
            GoRoute(
              path: '/admin/approvals',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const ApprovalQueueScreen(),
                transitionsBuilder: _fadeTransition,
              ),
            ),

            // ─── Admin: Reports ───
            GoRoute(
              path: '/admin/reports',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const ReportsHomeScreen(),
                transitionsBuilder: _fadeTransition,
              ),
            ),

            // ─── Manager: Dashboard ───
            GoRoute(
              path: '/manager/dashboard',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const ManagerDashboardScreen(),
                transitionsBuilder: _fadeTransition,
              ),
            ),

            // ─── Manager: Team ───
            GoRoute(
              path: '/manager/team',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const TeamListScreen(),
                transitionsBuilder: _fadeTransition,
              ),
            ),

            // ─── Manager: Approvals ───
            GoRoute(
              path: '/manager/approvals',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const ApprovalQueueScreen(),
                transitionsBuilder: _fadeTransition,
              ),
            ),

            // ─── Manager: Reports ───
            GoRoute(
              path: '/manager/reports',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const ReportsHomeScreen(),
                transitionsBuilder: _fadeTransition,
              ),
            ),

            // ─── Notifications ───
            GoRoute(
              path: '/notifications',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const NotificationListScreen(),
                transitionsBuilder: _fadeTransition,
              ),
            ),

            // ─── Profile ───
            GoRoute(
              path: '/profile',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const ProfileScreen(),
                transitionsBuilder: _slideTransition,
              ),
            ),

            // ─── Products ───
            GoRoute(
              path: '/products',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const ProductListScreen(),
                transitionsBuilder: _fadeTransition,
              ),
            ),

            // ─── Samples ───
            GoRoute(
              path: '/samples',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const SampleStockScreen(),
                transitionsBuilder: _fadeTransition,
              ),
            ),

            // ─── Orders ───
            GoRoute(
              path: '/orders',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const OrderListScreen(),
                transitionsBuilder: _fadeTransition,
              ),
            ),

            // ─── Targets ───
            GoRoute(
              path: '/targets',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const TargetDashboardScreen(),
                transitionsBuilder: _fadeTransition,
              ),
            ),

            // ─── E-Detail ───
            GoRoute(
              path: '/edetail',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const EDetailLibraryScreen(),
                transitionsBuilder: _fadeTransition,
              ),
            ),

            // ─── Campaigns ───
            GoRoute(
              path: '/campaigns',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const CampaignListScreen(),
                transitionsBuilder: _fadeTransition,
              ),
            ),

            // ─── Attendance ───
            GoRoute(
              path: '/attendance',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const AttendanceScreen(),
                transitionsBuilder: _fadeTransition,
              ),
            ),

            // ─── Leave ───
            GoRoute(
              path: '/leave',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const LeaveRequestScreen(),
                transitionsBuilder: _fadeTransition,
              ),
            ),

            // ─── Reports ───
            GoRoute(
              path: '/reports',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const ReportsHomeScreen(),
                transitionsBuilder: _fadeTransition,
              ),
            ),

            // ─── Expenses ───
            GoRoute(
              path: '/expenses',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const ExpenseListScreen(),
                transitionsBuilder: _fadeTransition,
              ),
            ),
          ],
        ),

        // ─── Full-screen routes (no bottom nav) ───

        GoRoute(
          path: '/dcr/record',
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return CustomTransitionPage(
              key: state.pageKey,
              child: DcrRecordingScreen(
                doctorName: extra?['doctorName'] as String?,
                visitId: extra?['visitId'] as String?,
              ),
              transitionsBuilder: _slideUpTransition,
            );
          },
        ),
        GoRoute(
          path: '/dcr/review',
          pageBuilder: (context, state) {
            final extra = state.extra;
            String transcript = '';
            String? doctorName;
            String? visitId;
            if (extra is String) {
              transcript = extra;
            } else if (extra is Map<String, dynamic>) {
              transcript = extra['transcript'] as String? ?? '';
              doctorName = extra['doctorName'] as String?;
              visitId = extra['visitId'] as String?;
            }
            return CustomTransitionPage(
              key: state.pageKey,
              child: DcrReviewScreen(
                transcript: transcript,
                prefillDoctorName: doctorName,
                visitId: visitId,
              ),
              transitionsBuilder: _slideTransition,
            );
          },
        ),
        GoRoute(
          path: '/expense/capture',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const ReceiptCaptureScreen(),
            transitionsBuilder: _slideUpTransition,
          ),
        ),
        GoRoute(
          path: '/expense/review',
          pageBuilder: (context, state) {
            final data = state.extra as Map<String, dynamic>? ?? {};
            return CustomTransitionPage(
              key: state.pageKey,
              child: ExpenseReviewScreen(extractedData: data),
              transitionsBuilder: _slideTransition,
            );
          },
        ),
        GoRoute(
          path: '/route',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const RouteMapScreen(),
            transitionsBuilder: _slideUpTransition,
          ),
        ),
        GoRoute(
          path: '/orders/:orderId',
          pageBuilder: (context, state) {
            final orderId = state.pathParameters['orderId']!;
            return CustomTransitionPage(
              key: state.pageKey,
              child: OrderDetailScreen(orderId: orderId),
              transitionsBuilder: _slideTransition,
            );
          },
        ),
        GoRoute(
          path: '/campaigns/:campaignId',
          pageBuilder: (context, state) {
            final campaignId = state.pathParameters['campaignId']!;
            return CustomTransitionPage(
              key: state.pageKey,
              child: CampaignDetailScreen(campaignId: campaignId),
              transitionsBuilder: _slideTransition,
            );
          },
        ),
        GoRoute(
          path: '/edetail/:contentId',
          pageBuilder: (context, state) {
            final contentId = state.pathParameters['contentId']!;
            return CustomTransitionPage(
              key: state.pageKey,
              child: EDetailViewerScreen(contentId: contentId),
              transitionsBuilder: _slideTransition,
            );
          },
        ),
        GoRoute(
          path: '/doctors/new',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const DoctorFormScreen(),
            transitionsBuilder: _slideUpTransition,
          ),
        ),
        GoRoute(
          path: '/doctors/:doctorId',
          pageBuilder: (context, state) {
            final doctorId = state.pathParameters['doctorId']!;
            final doctor = state.extra as Doctor?;
            return CustomTransitionPage(
              key: state.pageKey,
              child: DoctorDetailScreen(
                doctorId: doctorId,
                initialDoctor: doctor,
              ),
              transitionsBuilder: _slideTransition,
            );
          },
        ),
        GoRoute(
          path: '/doctors/:doctorId/edit',
          pageBuilder: (context, state) {
            final doctorId = state.pathParameters['doctorId']!;
            return CustomTransitionPage(
              key: state.pageKey,
              child: DoctorFormScreen(doctorId: doctorId),
              transitionsBuilder: _slideTransition,
            );
          },
        ),
        GoRoute(
          path: '/attendance/history',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const AttendanceHistoryScreen(),
            transitionsBuilder: _slideTransition,
          ),
        ),
        GoRoute(
          path: '/admin/users/:userId',
          pageBuilder: (context, state) {
            final userId = state.pathParameters['userId']!;
            return CustomTransitionPage(
              key: state.pageKey,
              child: UserFormScreen(
                  userId: userId == 'new' ? null : userId),
              transitionsBuilder: _slideTransition,
            );
          },
        ),
        GoRoute(
          path: '/admin/territories',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const TerritoryManagementScreen(),
            transitionsBuilder: _slideTransition,
          ),
        ),
        GoRoute(
          path: '/admin/territories/:territoryId',
          pageBuilder: (context, state) {
            final id = state.pathParameters['territoryId']!;
            return CustomTransitionPage(
              key: state.pageKey,
              child:
                  TerritoryFormScreen(territoryId: id == 'new' ? null : id),
              transitionsBuilder: _slideTransition,
            );
          },
        ),
        GoRoute(
          path: '/admin/products',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const ProductListScreen(),
            transitionsBuilder: _slideTransition,
          ),
        ),
        GoRoute(
          path: '/admin/products/create',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const ProductFormScreen(),
            transitionsBuilder: _slideUpTransition,
          ),
        ),
        GoRoute(
          path: '/admin/products/:productId',
          pageBuilder: (context, state) {
            final id = state.pathParameters['productId']!;
            return CustomTransitionPage(
              key: state.pageKey,
              child: ProductFormScreen(productId: id),
              transitionsBuilder: _slideTransition,
            );
          },
        ),
        GoRoute(
          path: '/admin/targets',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const TargetDashboardScreen(),
            transitionsBuilder: _slideTransition,
          ),
        ),
        GoRoute(
          path: '/admin/targets/assign',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const TargetAssignScreen(),
            transitionsBuilder: _slideUpTransition,
          ),
        ),
        GoRoute(
          path: '/admin/samples/allocate',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const SampleAllocationScreen(),
            transitionsBuilder: _slideUpTransition,
          ),
        ),
        GoRoute(
          path: '/admin/campaigns',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const CampaignListScreen(),
            transitionsBuilder: _slideTransition,
          ),
        ),
        GoRoute(
          path: '/admin/campaigns/create',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const CampaignCreateScreen(),
            transitionsBuilder: _slideUpTransition,
          ),
        ),
        GoRoute(
          path: '/admin/campaigns/:campaignId/edit',
          pageBuilder: (context, state) {
            final id = state.pathParameters['campaignId']!;
            return CustomTransitionPage(
              key: state.pageKey,
              child: CampaignCreateScreen(campaignId: id),
              transitionsBuilder: _slideUpTransition,
            );
          },
        ),
        GoRoute(
          path: '/admin/approvals/:approvalId',
          pageBuilder: (context, state) {
            final id = state.pathParameters['approvalId']!;
            return CustomTransitionPage(
              key: state.pageKey,
              child: ApprovalDetailScreen(approvalId: id),
              transitionsBuilder: _slideTransition,
            );
          },
        ),
        GoRoute(
          path: '/manager/approvals/:approvalId',
          pageBuilder: (context, state) {
            final id = state.pathParameters['approvalId']!;
            return CustomTransitionPage(
              key: state.pageKey,
              child: ApprovalDetailScreen(approvalId: id),
              transitionsBuilder: _slideTransition,
            );
          },
        ),
        GoRoute(
          path: '/approvals/:approvalId',
          pageBuilder: (context, state) {
            final id = state.pathParameters['approvalId']!;
            return CustomTransitionPage(
              key: state.pageKey,
              child: ApprovalDetailScreen(approvalId: id),
              transitionsBuilder: _slideTransition,
            );
          },
        ),
        GoRoute(
          path: '/manager/team/:memberId',
          pageBuilder: (context, state) {
            final id = state.pathParameters['memberId']!;
            return CustomTransitionPage(
              key: state.pageKey,
              child: UserFormScreen(userId: id),
              transitionsBuilder: _slideTransition,
            );
          },
        ),
        GoRoute(
          path: '/tour-plan/create',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const TourPlanCreateScreen(),
            transitionsBuilder: _slideUpTransition,
          ),
        ),
        GoRoute(
          path: '/tour-plan/:planId',
          pageBuilder: (context, state) {
            final planId = state.pathParameters['planId']!;
            return CustomTransitionPage(
              key: state.pageKey,
              child: TourPlanDetailScreen(planId: planId),
              transitionsBuilder: _slideTransition,
            );
          },
        ),
        GoRoute(
          path: '/products/:productId',
          pageBuilder: (context, state) {
            final productId = state.pathParameters['productId']!;
            return CustomTransitionPage(
              key: state.pageKey,
              child: ProductDetailScreen(productId: productId),
              transitionsBuilder: _slideTransition,
            );
          },
        ),
        GoRoute(
          path: '/samples/distribute',
          pageBuilder: (context, state) {
            final doctorId = state.extra as String?;
            return CustomTransitionPage(
              key: state.pageKey,
              child: SampleDistributionScreen(doctorId: doctorId),
              transitionsBuilder: _slideUpTransition,
            );
          },
        ),
        GoRoute(
          path: '/orders/create',
          pageBuilder: (context, state) {
            final doctorId = state.extra as String?;
            return CustomTransitionPage(
              key: state.pageKey,
              child: OrderCreateScreen(doctorId: doctorId),
              transitionsBuilder: _slideUpTransition,
            );
          },
        ),
        GoRoute(
          path: '/reports/sales',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const SalesReportScreen(),
            transitionsBuilder: _slideTransition,
          ),
        ),
        GoRoute(
          path: '/reports/activity',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const ActivityReportScreen(),
            transitionsBuilder: _slideTransition,
          ),
        ),
        GoRoute(
          path: '/reports/attendance',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const AttendanceScreen(),
            transitionsBuilder: _slideTransition,
          ),
        ),
        GoRoute(
          path: '/reports/expense',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const ExpenseListScreen(),
            transitionsBuilder: _slideTransition,
          ),
        ),
        GoRoute(
          path: '/reports/sample',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const SampleStockScreen(),
            transitionsBuilder: _slideTransition,
          ),
        ),
        GoRoute(
          path: '/reports/tour-deviation',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const TourPlanListScreen(),
            transitionsBuilder: _slideTransition,
          ),
        ),
        GoRoute(
          path: '/reports/target',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const TargetDashboardScreen(),
            transitionsBuilder: _slideTransition,
          ),
        ),
      ],
    );

    return _cachedRouter!;
  }

  static Widget _fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }

  static Widget _slideTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
    return SlideTransition(
      position: Tween(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(curved),
      child: child,
    );
  }

  static Widget _slideUpTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
    return SlideTransition(
      position: Tween(
        begin: const Offset(0, 0.15),
        end: Offset.zero,
      ).animate(curved),
      child: FadeTransition(opacity: curved, child: child),
    );
  }
}

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.explore_off, size: 64, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text('Page not found', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
