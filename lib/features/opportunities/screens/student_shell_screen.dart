import 'package:flutter/material.dart';
import 'browse_screen.dart';
import '../../applications/screens/my_applications_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../../core/theme/app_colors.dart';

class StudentShellScreen extends StatefulWidget {
  const StudentShellScreen({super.key});
  @override
  State<StudentShellScreen> createState() => _StudentShellScreenState();
}

class _StudentShellScreenState extends State<StudentShellScreen> {
  int _index = 0;

  final _screens = const [
    BrowseScreen(),
    BrowseScreen(),
    MyApplicationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        indicatorColor: AppColors.primary.withValues(alpha: 0.15),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppColors.primary),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search, color: AppColors.primary),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment, color: AppColors.primary),
            label: 'Applications',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.primary),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
