import 'package:esmorga_flutter/view/home/esmorga_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  final Widget child;

  const HomeScreen({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.path;

    return Scaffold(
      body: child,
      bottomNavigationBar: EsmorgaBottomBar(
        items: BottomNavItem.items,
        currentRoute: currentRoute,
      ),
    );
  }
}

