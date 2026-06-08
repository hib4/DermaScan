import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/history_screen.dart';
import '../screens/home_screen.dart';
import '../screens/learn_screen.dart';
import '../screens/scan/scan_entry_screen.dart';
import '../screens/settings_screen.dart';
import '../theme/app_colors.dart';

/// Bottom navigation shell for the main DermaScan app.
/// Manages tabs locally with IndexedStack to avoid route transition animations.
class ScaffoldWithNavBar extends StatefulWidget {
  const ScaffoldWithNavBar({super.key});

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final navBackground = AppColors.background(context).withValues(alpha: 0.96);
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeScreen(),
          ScanEntryScreen(),
          HistoryScreen(),
          LearnScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: navBackground,
          border: Border(top: BorderSide(color: AppColors.softBorder(context))),
        ),
        child: SafeArea(
          top: false,
          child: CupertinoTabBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor: Colors.transparent,
            activeColor: AppColors.primaryInteractive(context),
            inactiveColor: AppColors.mutedIcon(context),
            border: null,
            iconSize: 23,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.house),
                activeIcon: Icon(CupertinoIcons.house_fill),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.camera),
                activeIcon: Icon(CupertinoIcons.camera_fill),
                label: 'Scan',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.clock),
                activeIcon: Icon(CupertinoIcons.clock_fill),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.book),
                activeIcon: Icon(CupertinoIcons.book_fill),
                label: 'Learn',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person),
                activeIcon: Icon(CupertinoIcons.person_fill),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
