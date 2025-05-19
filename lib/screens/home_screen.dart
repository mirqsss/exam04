import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exam04/services/auth_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:exam04/screens/tasks_screen.dart';
import 'package:exam04/screens/calendar_screen.dart';
import 'package:exam04/screens/statistics_screen.dart';
import 'package:exam04/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const TasksScreen(),
    const CalendarScreen(),
    const StatisticsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthService>().signOut();
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.task),
            label: l10n.tasks,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_today),
            label: l10n.calendar,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart),
            label: l10n.statistics,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person),
            label: l10n.profile,
          ),
        ],
      ),
    );
  }
} 