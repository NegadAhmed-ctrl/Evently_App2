import 'package:flutter/material.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:flutter_application_1/l10n/provider/app_language_provider.dart';
import 'package:flutter_application_1/l10n/provider/app_theme_provider.dart';
import 'package:flutter_application_1/ui/home/tabs/profile/widgets/app_config_item.dart';
import 'package:flutter_application_1/utils/app_assets.dart';
import 'package:flutter_application_1/utils/app_colors.dart';
import 'package:flutter_application_1/utils/app_theme.dart';
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
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(AppAssets.logoLightImage),
              ),
              Text(
                "Route Academy",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                "routeacademy@gmail.com",
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
                icon: Icon(Icons.logout, color: Colors.red),
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
      builder: (context) => LanguageBottomSheet(),
    );
  }

  void showThemeBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ThemeBottomSheet(),
    );
  }
}
