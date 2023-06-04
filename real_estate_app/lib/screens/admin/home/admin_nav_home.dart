import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_app/router/router.gr.dart';
import 'package:real_estate_app/screens/admin/main/admin_main_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';


class AdminNavScreen extends StatefulWidget {
  const AdminNavScreen({super.key});

  @override
  State<AdminNavScreen> createState() => _NavigationPagesState();
}

class _NavigationPagesState extends State<AdminNavScreen> {
  @override
  Widget build(BuildContext context) {
    print('admin nav screen');
    return AutoTabsScaffold(
      appBarBuilder: (context, tabsRouter) => AppBar(
        title: const Text('Admin Panel'),
        centerTitle: true,
        leading: const AutoLeadingButton(),
      ),
      routes: const [
        Adminhome(),
        Adminsetting(),
      ],
      bottomNavigationBuilder: (context, tabsRouter) {
        return SalomonBottomBar(
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text('Home'),
              selectedColor: Theme.of(context).colorScheme.primary,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.settings),
              title: const Text('Settings'),
              selectedColor: Theme.of(context).colorScheme.primary,
            ),
            
          ],
        );
      },
    );
  }
}
