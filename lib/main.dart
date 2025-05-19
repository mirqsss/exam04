import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:exam04/services/localization_service.dart';
import 'package:exam04/services/auth_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:exam04/screens/auth_screen.dart';
import 'package:exam04/screens/home_screen.dart';
import 'package:exam04/screens/tasks_screen.dart';
import 'package:exam04/screens/calendar_screen.dart';
import 'package:exam04/screens/statistics_screen.dart';
import 'package:exam04/screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: MaterialApp(
        title: 'Task Manager',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('ru'),
          Locale('kk'),
        ],
        home: Consumer<AuthService>(
          builder: (context, authService, _) {
            return authService.isAuthenticated
                ? const HomeScreen()
                : const AuthScreen();
          },
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            icon: const Icon(Icons.language),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l10n.language),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text('English'),
                        onTap: () {
                          context.read<LocalizationService>().setLocale('en');
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Русский'),
                        onTap: () {
                          context.read<LocalizationService>().setLocale('ru');
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Қазақша'),
                        onTap: () {
                          context.read<LocalizationService>().setLocale('kk');
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
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
