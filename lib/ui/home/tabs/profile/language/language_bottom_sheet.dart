import 'package:flutter/material.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:flutter_application_1/l10n/provider/app_language_provider.dart';
import 'package:flutter_application_1/utils/app_colors.dart';
import 'package:provider/provider.dart';

class LanguageBottomSheet extends StatefulWidget {
  const LanguageBottomSheet({super.key});

  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<AppLanguageProvider>(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () {
              languageProvider.changeLanguage('ar');
              Navigator.pop(context);
            },
            child: languageProvider.applanguage == 'ar'
                ? _getSelectedItemLanguage(
                    language: AppLocalizations.of(context)!.arabic,
                    context: context,
                  )
                : _getUnSelectedItemLanguage(
                    language: AppLocalizations.of(context)!.arabic,
                    context: context,
                  ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              languageProvider.changeLanguage('en');
              Navigator.pop(context);
            },
            child: languageProvider.applanguage == 'en'
                ? _getSelectedItemLanguage(
                    language: AppLocalizations.of(context)!.english,
                    context: context,
                  )
                : _getUnSelectedItemLanguage(
                    language: AppLocalizations.of(context)!.english,
                    context: context,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _getSelectedItemLanguage({
    required String language,
    required BuildContext context,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(language, style: Theme.of(context).textTheme.titleLarge),
        const Icon(Icons.check, color: AppColors.mainLightColor, size: 30),
      ],
    );
  }

  Widget _getUnSelectedItemLanguage({
    required String language,
    required BuildContext context,
  }) {
    return Text(language, style: Theme.of(context).textTheme.headlineMedium);
  }
}
