import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:flutter_application_1/l10n/provider/app_language_provider.dart';
import 'package:flutter_application_1/l10n/provider/app_theme_provider.dart';
import 'package:flutter_application_1/ui/home/tabs/profile/widgets/app_config_item.dart';
import 'package:flutter_application_1/utils/app_colors.dart';
import 'package:flutter_application_1/utils/app_routes.dart';
import 'package:flutter_application_1/utils/size_utils.dart';
import 'package:provider/provider.dart';
import 'language/language_bottom_sheet.dart';
import 'theme/theme_bottom_sheet.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  // دالة لجلب اسم اليوزر
  String getUserName() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null &&
        user.displayName != null &&
        user.displayName!.isNotEmpty) {
      return user.displayName!;
    }
    return user?.email?.split('@').first ?? 'Negad Khalil';
  }

  // دالة لجلب إيميل اليوزر
  String getUserEmail() {
    return FirebaseAuth.instance.currentUser?.email ?? 'No Email';
  }

  // دالة تسجيل الخروج
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    if (mounted) {
      // بنمسح كل الشاشات اللي فاتت عشان اليوزر ميرجعش للـ Home بالـ Back button
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.loginRouteName,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<AppLanguageProvider>(context);
    var themeProvider = Provider.of<AppThemeProvider>(context);
    var height = context.height;
    var width = context.width;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.04,
            vertical: height * 0.04,
          ),
          child: Column(
            spacing: 0.02 * height,
            children: [
              SizedBox(height: height * 0.02),

              // ✅ تم التعديل هنا: استبدلنا لوجو ROUTE بأيقونة مستخدم افتراضية واحترافية (Avatar Placeholder)
              CircleAvatar(
                radius: 50,
                backgroundColor: themeProvider.isDark
                    ? AppColors.mainDarkColor.withOpacity(0.2)
                    : AppColors.mainLightColor.withOpacity(0.1),
                child: Icon(
                  Icons
                      .person_pin_rounded, // أيقونة المستخدم تعطي شكل بروفايل افتراضي وجميل
                  size: 75,
                  color: themeProvider.isDark
                      ? AppColors.whiteColor
                      : AppColors.mainLightColor,
                ),
              ),

              Text(
                getUserName(),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                getUserEmail(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: height * 0.01),
              AppConfigItem(
                text: AppLocalizations.of(context)!.dark_mode,
                icon: Switch(
                  activeTrackColor: AppColors.mainDarkColor,
                  inactiveTrackColor: AppColors.lightGreyColor,
                  activeThumbColor: AppColors.whiteColor,
                  inactiveThumbColor: AppColors.whiteColor,
                  trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((
                    states,
                  ) {
                    return AppColors.transparentColor;
                  }),
                  value: themeProvider.isDark,
                  onChanged: (value) {
                    themeProvider.changeTheme(
                      value ? ThemeMode.dark : ThemeMode.light,
                    );
                  },
                ),
              ),
              AppConfigItem(
                text: AppLocalizations.of(context)!.language,
                icon: IconButton(
                  onPressed: () {
                    showLanguageBottomSheet();
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Theme.of(context).cardColor,
                  ),
                ),
              ),
              AppConfigItem(
                text: AppLocalizations.of(context)!.logout,
                icon: IconButton(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout, color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showLanguageBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => const LanguageBottomSheet(),
    );
  }

  void showThemeBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => const ThemeBottomSheet(),
    );
  }
}
