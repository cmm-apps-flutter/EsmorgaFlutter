import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EsmorgaBottomBar extends StatelessWidget {
  final List<BottomNavItem> items;
  final String currentRoute;

  const EsmorgaBottomBar({
    super.key,
    required this.items,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      selectedIndex: _getSelectedIndex(),
      onDestinationSelected: (index) {
        final item = items[index];
        context.go(item.route);
      },
      destinations: items.map((item) {
        final isSelected = currentRoute == item.route;
        return NavigationDestination(
          icon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Icon(
              item.icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          label: item.label,
        );
      }).toList(),
    );
  }

  int _getSelectedIndex() {
    for (int i = 0; i < items.length; i++) {
      if (items[i].route == currentRoute) {
        return i;
      }
    }
    return 0;
  }
}

class BottomNavItem {
  final String route;
  final IconData icon;
  final String label;

  const BottomNavItem({
    required this.route,
    required this.icon,
    required this.label,
  });

  static const explore = BottomNavItem(
    route: '/events',
    icon: Icons.search_outlined,
    label: 'Explore',
  );

  static const myEvents = BottomNavItem(
    route: '/my-events',
    icon: Icons.calendar_today,
    label: 'My Events',
  );

  static const profile = BottomNavItem(
    route: '/profile',
    icon: Icons.person_outline,
    label: 'Profile',
  );

  static const List<BottomNavItem> items = [
    explore,
    myEvents,
    profile,
  ];
}

