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
import 'package:exam04/theme/app_theme.dart';
import 'services/fcm_service.dart';
import 'utils/animations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Инициализация FCM
  final fcmService = FCMService();
  await fcmService.initialize();
  
  String? token = await fcmService.getToken();
  print('FCM Token: $token');
  
  final prefs = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => LocalizationService(prefs)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationService>(
      builder: (context, localizationService, _) {
        return MaterialApp(
          title: 'TaskMaster',
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'CascadiaMono',
            colorScheme: ColorScheme.light(
              primary: Colors.purple.shade300,
              secondary: Colors.purple.shade200,
              surface: Colors.white,
              background: Colors.grey.shade50,
              onPrimary: Colors.white,
              onSecondary: Colors.purple.shade900,
              onSurface: Colors.purple.shade900,
              onBackground: Colors.purple.shade900,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: false,
              titleSpacing: 24,
              iconTheme: IconThemeData(color: Colors.purple.shade300),
              titleTextStyle: TextStyle(
                color: Colors.purple.shade900,
                fontSize: 28,
                fontWeight: FontWeight.w600,
                fontFamily: 'CascadiaMono',
                letterSpacing: -0.5,
              ),
            ),
            navigationBarTheme: NavigationBarThemeData(
              backgroundColor: Colors.white,
              indicatorColor: Colors.purple.shade100,
              labelTextStyle: MaterialStateProperty.all(
                TextStyle(
                  color: Colors.purple.shade900,
                  fontFamily: 'CascadiaMono',
                  fontWeight: FontWeight.w600,
                ),
              ),
              iconTheme: MaterialStateProperty.all(
                IconThemeData(color: Colors.purple.shade300),
              ),
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.purple.shade300,
              foregroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            cardTheme: CardTheme(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade300,
                foregroundColor: Colors.white,
                elevation: 2,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontFamily: 'CascadiaMono',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
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
          locale: localizationService.locale,
          home: Consumer<AuthService>(
            builder: (context, authService, _) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: authService.isAuthenticated
                    ? const HomeScreen(key: ValueKey('home'))
                    : const AuthScreen(key: ValueKey('auth')),
              );
            },
          ),
          onGenerateRoute: (settings) {
            if (settings.name == '/home') {
              return FadePageRoute(child: const HomeScreen());
            }
            if (settings.name == '/auth') {
              return FadePageRoute(child: const AuthScreen());
            }
            return null;
          },
        );
      },
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

class FadePageRouteBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
