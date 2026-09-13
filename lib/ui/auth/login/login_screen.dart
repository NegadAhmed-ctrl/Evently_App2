import 'package:flutter/material.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:flutter_application_1/l10n/provider/app_theme_provider.dart';
import 'package:flutter_application_1/ui/widgets/custom_text_field.dart';
import 'package:flutter_application_1/utils/app_assets.dart';
import 'package:flutter_application_1/utils/app_theme.dart';
import 'package:flutter_application_1/utils/size_utils.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;
    var themeProvider = Provider.of<AppThemeProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.04,
            vertical: 0.02,
          ),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: height * 0.02,
              children: [
                Image.asset(
                  themeProvider.isDark
                      ? AppAssets.logoDarkImage
                      : AppAssets.logoLightImage,
                ),
                Text(
                  AppLocalizations.of(context)!.login_to_your_account,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                CustomTextField(
                  hintText: AppLocalizations.of(context)!.email_hint,
                  hintStyle: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
