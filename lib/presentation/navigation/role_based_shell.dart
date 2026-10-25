import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/user_providers.dart';
import '../../core/utils/responsive.dart';

class RoleBasedShell extends ConsumerWidget {
  final Widget child;

  const RoleBasedShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(unreadNotificationCountProvider).value ?? 0;
    final location = GoRouterState.of(context).uri.path;
    final screenType = screenTypeOf(context);

    final destinations = _destinations(unreadCount);
    final selectedIndex = _indexForLocation(location);

    if (screenType == ScreenType.expanded) {
      return _DesktopLayout(
        destinations: destinations,
        selectedIndex: selectedIndex,
        child: child,
      );
    }

    if (screenType == ScreenType.medium) {
      return _TabletLayout(
        destinations: destinations,
        selectedIndex: selectedIndex,
        child: child,
      );
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (i) => _onDestinationSelected(context, i),
        destinations: destinations,
      ),
    );
  }

  static List<NavigationDestination> _destinations(int unreadCount) {
    return [
      const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home'),
      const NavigationDestination(
          icon: Icon(Icons.edit_note_outlined),
          selectedIcon: Icon(Icons.edit_note),
          label: 'DCR'),
      const NavigationDestination(
          icon: Icon(Icons.calendar_month_outlined),
          selectedIcon: Icon(Icons.calendar_month),
          label: 'Tour Plan'),
      const NavigationDestination(
          icon: Icon(Icons.local_hospital_outlined),
          selectedIcon: Icon(Icons.local_hospital),
          label: 'Doctors'),
      NavigationDestination(
          icon: Badge(
            isLabelVisible: unreadCount > 0,
            label: Text('$unreadCount'),
            child: const Icon(Icons.more_horiz_outlined),
          ),
          selectedIcon: const Icon(Icons.more_horiz),
          label: 'More'),
    ];
  }

  static int _indexForLocation(String location) {
    if (location.startsWith('/dcr')) return 1;
    if (location.startsWith('/tour-plan')) return 2;
    if (location.startsWith('/doctors')) return 3;
    if (location == '/') return 0;
    return 4; // Everything else (More and sub-screens)
  }

  static void _onDestinationSelected(BuildContext context, int index) {
    const paths = ['/', '/dcr', '/tour-plan', '/doctors', '/more'];
    context.go(paths[index]);
  }
}

class _TabletLayout extends StatelessWidget {
  final List<NavigationDestination> destinations;
  final int selectedIndex;
  final Widget child;

  const _TabletLayout({
    required this.destinations,
    required this.selectedIndex,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: (i) =>
                RoleBasedShell._onDestinationSelected(context, i),
            labelType: NavigationRailLabelType.all,
            destinations: destinations
                .map((d) => NavigationRailDestination(
                      icon: d.icon,
                      selectedIcon: d.selectedIcon,
                      label: Text(d.label),
                    ))
                .toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  final List<NavigationDestination> destinations;
  final int selectedIndex;
  final Widget child;

  const _DesktopLayout({
    required this.destinations,
    required this.selectedIndex,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Row(
        children: [
          NavigationDrawer(
            selectedIndex: selectedIndex,
            onDestinationSelected: (i) =>
                RoleBasedShell._onDestinationSelected(context, i),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Text('RxForce SFA',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ),
              const Divider(indent: 16, endIndent: 16),
              ...destinations.map((d) => NavigationDrawerDestination(
                    icon: d.icon,
                    selectedIcon: d.selectedIcon,
                    label: Text(d.label),
                  )),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}
