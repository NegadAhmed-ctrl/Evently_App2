import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/l10n/provider/app_theme_provider.dart';
import 'package:flutter_application_1/utils/app_assets.dart';
import 'package:flutter_application_1/utils/app_routes.dart';
import 'package:flutter_application_1/utils/size_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    // هنستنى ثانيتين عشان اللوجو يظهر
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    // بنشيك اليوزر شاف الـ onboarding قبل كده ولا لأ
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seenOnboarding = prefs.getBool('seen_onboarding') ?? false;

    if (!seenOnboarding) {
      Navigator.pushReplacementNamed(context, AppRoutes.onboardingRouteName);
    } else {
      // لو شافها، بنشيك هو عامل لوجين ولا لأ
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.pushReplacementNamed(context, AppRoutes.homeRouteName);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.loginRouteName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<AppThemeProvider>(context);
    var height = context.height;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(
              themeProvider.isDark
                  ? AppAssets.eventlyLogoDark
                  : AppAssets.eventlyLogo,
              height: height * 0.2,
            ),
            const Spacer(),
            Image.asset(
              themeProvider.isDark
                  ? AppAssets.routeSupervisedDark
                  : AppAssets.routeSupervised,
              height: height * 0.1,
            ),
            SizedBox(height: height * 0.05),
          ],
        ),
      ),
    );
  }
}
