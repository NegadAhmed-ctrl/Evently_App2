import 'package:flutter/material.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:flutter_application_1/l10n/provider/app_language_provider.dart';
import 'package:flutter_application_1/l10n/provider/app_theme_provider.dart';
import 'package:flutter_application_1/ui/add_event/add_event.dart';
import 'package:flutter_application_1/ui/auth/Register/Register_screen.dart';
import 'package:flutter_application_1/ui/auth/login/login_screen.dart';
import 'package:flutter_application_1/ui/home/event_details/event_details_screen.dart';
import 'package:flutter_application_1/ui/home/tabs/profile/favorite/favorite_tab.dart';
import 'package:provider/provider.dart';
import 'utils/app_routes.dart';
import 'utils/app_theme.dart';
import 'ui/home/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_application_1/ui/home/event_details/event_edit.dart';
import 'package:flutter_application_1/ui/splash/splash_screen.dart';
import 'package:flutter_application_1/ui/onboarding/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppThemeProvider()),
        ChangeNotifierProvider(create: (context) => AppLanguageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<AppLanguageProvider>(context);
    var themeProvider = Provider.of<AppThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Evently App',
      initialRoute: AppRoutes.splashRouteName,
      routes: {
        AppRoutes.splashRouteName: (context) => const SplashScreen(),
        AppRoutes.onboardingRouteName: (context) => const OnboardingScreen(),

        AppRoutes.homeRouteName: (context) => HomeScreen(),
        AppRoutes.loginRouteName: (context) => const LoginScreen(),
        AppRoutes.registerRouteName: (context) => const RegisterScreen(),
        AppRoutes.favoritetab: (context) => const FavoriteTab(),
        AppRoutes.addEvent: (context) => const AddEvent(),
        AppRoutes.eventDetailsScreen: (context) => const EventDetailsScreen(),
        AppRoutes.eventEditScreen: (context) => const EditEventScreen(),
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(languageProvider.applanguage),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.appTheme,
    );
  }
}
