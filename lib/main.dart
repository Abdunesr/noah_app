// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/auth_provider.dart';
import 'package:noah/screens/login_screen.dart';
import 'utils/colors.dart';
import 'screens/splash_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/bills_screen.dart';
import 'screens/announcements_screen.dart';
import 'screens/maintenance_screen.dart';
import 'screens/water_usage_screen.dart';
import 'screens/parking_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/marketplace_screen.dart'; // Import the marketplace screen
import 'screens/water_meter_screen.dart';
import 'screens/admin_blocked_screen.dart';
import 'screens/water_reader_home_screen.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'providers/locale_provider.dart';
import 'utils/localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const GreenParkApp(),
    ),
  );
}

class GreenParkApp extends ConsumerWidget {
  const GreenParkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      title: 'GreenPark Properties',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      locale: currentLocale,
      supportedLocales: const [
        Locale('en', ''),
        Locale('am', ''),
        Locale('om', ''),
      ],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        OromoMaterialLocalizationsDelegate(),
        OromoCupertinoLocalizationsDelegate(),
      ],
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/bills': (context) => const BillsScreen(),
        '/announcements': (context) => const AnnouncementsScreen(),
        '/maintenance': (context) => const MaintenanceScreen(),
        '/water': (context) => const WaterUsageScreen(),
        '/parking': (context) => const ParkingScreen(),
        '/calendar': (context) => const CalendarScreen(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/marketplace': (context) =>
            const MarketplaceScreen(), // Added marketplace route
        '/admin_blocked': (context) => const AdminBlockedScreen(),
        '/water_reader_home': (context) => const WaterReaderHomeScreen(),
      },
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      fontFamily: 'Inter',
      primaryColor: AppColors.primaryBlack,
      scaffoldBackgroundColor: AppColors.primaryWhite,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.primaryBlack,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.primaryWhite,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primaryBlack),
      ),
    );
  }
}
