import 'package:flutter/material.dart';
import 'package:flutter_application_1/l10n/provider/app_language_provider.dart';
import 'package:flutter_application_1/l10n/provider/app_theme_provider.dart';
import 'package:flutter_application_1/utils/app_assets.dart';
import 'package:flutter_application_1/utils/app_colors.dart';
import 'package:flutter_application_1/utils/app_routes.dart';
import 'package:flutter_application_1/utils/size_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  Future<void> _finishOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_onboarding', true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.loginRouteName);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<AppThemeProvider>(context);
    var langProvider = Provider.of<AppLanguageProvider>(context);
    bool isDark = themeProvider.isDark;
    bool isEn = langProvider.applanguage == 'en';
    var height = context.height;
    var width = context.width;

    // الداتا بتاعة الشاشات
    List<Map<String, String>> onboardingData = [
      {
        "image": isDark
            ? AppAssets.onboardingPersonalizeDark
            : AppAssets.onboardingPersonalize,
        "title": isEn ? "Personalize Your Experience" : "تخصيص تجربتك",
        "desc": isEn
            ? "Choose your language and theme to get started"
            : "اختر لغتك والمظهر للبدء",
      },
      {
        "image": isDark
            ? AppAssets.onboardingDiscoverDark
            : AppAssets.onboardingDiscover,
        "title": isEn
            ? "Find Events That Inspire You"
            : "ابحث عن الأحداث التي تلهمك",
        "desc": isEn
            ? "Dive into a world of events tailored to your unique interests."
            : "اغطس في عالم من الأحداث المصممة خصيصاً لاهتماماتك.",
      },
      {
        "image": isDark
            ? AppAssets.onboardingPlanningDark
            : AppAssets.onboardingPlanning,
        "title": isEn ? "Effortless Event Planning" : "تخطيط الأحداث بسهولة",
        "desc": isEn
            ? "Take the hassle out of organizing events with our all-in-one planning tools."
            : "تخلص من عناء تنظيم الأحداث مع أدوات التخطيط الشاملة لدينا.",
      },
      {
        "image": isDark
            ? AppAssets.onboardingConnectDark
            : AppAssets.onboardingConnect,
        "title": isEn
            ? "Connect with Friends & Share Moments"
            : "تواصل مع الأصدقاء وشارك اللحظات",
        "desc": isEn
            ? "Make every event memorable by sharing the experience with others."
            : "اجعل كل حدث لا يُنسى من خلال مشاركة التجربة مع الآخرين.",
      },
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_currentIndex > 0)
            TextButton(
              onPressed: _finishOnboarding,
              child: Text(
                isEn ? "Skip" : "تخطي",
                style: TextStyle(
                  color: isDark
                      ? AppColors.whiteColor
                      : AppColors.mainLightColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: onboardingData.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          onboardingData[index]["image"]!,
                          height: height * 0.35,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: height * 0.04),
                        Text(
                          onboardingData[index]["title"]!,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.whiteColor
                                    : AppColors.mainLightColor,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: height * 0.02),
                        Text(
                          onboardingData[index]["desc"]!,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        if (index == 0) ...[
                          SizedBox(height: height * 0.04),
                          // أزرار اللغة والثيم للشاشة الأولى فقط
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isEn ? "Language" : "اللغة",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              ToggleButtons(
                                borderRadius: BorderRadius.circular(12),
                                isSelected: [isEn, !isEn],
                                onPressed: (i) {
                                  langProvider.changeLanguage(
                                    i == 0 ? 'en' : 'ar',
                                  );
                                },
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Text("EN"),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Text("AR"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: height * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isEn ? "Theme" : "المظهر",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              ToggleButtons(
                                borderRadius: BorderRadius.circular(12),
                                isSelected: [!isDark, isDark],
                                onPressed: (i) {
                                  themeProvider.changeTheme(
                                    i == 0 ? ThemeMode.light : ThemeMode.dark,
                                  );
                                },
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Icon(Icons.wb_sunny),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Icon(Icons.nightlight_round),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
              // الجزء السفلي (الزراير والنقاط)
              Padding(
                padding: EdgeInsets.only(bottom: height * 0.02),
                child: _currentIndex == 0
                    ? SizedBox(
                        width: double.infinity,
                        height: height * 0.06,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark
                                ? AppColors.mainDarkColor
                                : AppColors.mainLightColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Text(
                            isEn ? "Let's Start" : "هيا نبدأ",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: isDark
                                  ? AppColors.whiteColor
                                  : AppColors.mainLightColor,
                            ),
                          ),
                          Row(
                            children: List.generate(
                              onboardingData.length,
                              (index) => Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                height: 8,
                                width: _currentIndex == index ? 24 : 8,
                                decoration: BoxDecoration(
                                  color: _currentIndex == index
                                      ? (isDark
                                            ? AppColors.mainDarkColor
                                            : AppColors.mainLightColor)
                                      : Colors.grey.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (_currentIndex == onboardingData.length - 1) {
                                _finishOnboarding();
                              } else {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            icon: Icon(
                              _currentIndex == onboardingData.length - 1
                                  ? Icons.check
                                  : Icons.arrow_forward,
                              color: isDark
                                  ? AppColors.whiteColor
                                  : AppColors.mainLightColor,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
