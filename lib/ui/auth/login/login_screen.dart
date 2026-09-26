import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_utils.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:flutter_application_1/l10n/provider/app_theme_provider.dart';
import 'package:flutter_application_1/ui/widgets/custom_elevated_bottom.dart';
import 'package:flutter_application_1/ui/widgets/custom_text_field.dart';
import 'package:flutter_application_1/utils/app_assets.dart';
import 'package:flutter_application_1/utils/app_colors.dart';
import 'package:flutter_application_1/utils/app_routes.dart';
import 'package:flutter_application_1/utils/app_styles.dart';
import 'package:flutter_application_1/utils/size_utils.dart';
import 'package:flutter_application_1/utils/toast_utiles.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;
    var themeProvider = Provider.of<AppThemeProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.04,
              vertical: height * 0.02,
            ),
            child: Form(
              key: formkey,
              child: Column(
                spacing: height * 0.02,
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    prefix: Icon(Icons.email, color: AppColors.disableColor),
                    controller: emailcontroller,
                    keybordType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please Enter Email";
                      }

                      final bool emailValid = RegExp(
                        r"^[\w.+-]+@[\w-]+(\.[\w-]+)+$",
                      ).hasMatch(value.trim());

                      if (!emailValid) {
                        return "Please Enter Valid Email";
                      }

                      return null;
                    },
                  ),

                  CustomTextField(
                    style: Theme.of(context).textTheme.bodySmall,
                    hintText: AppLocalizations.of(context)!.password_hint,
                    hintStyle: Theme.of(context).textTheme.bodyLarge,
                    keybordType: TextInputType.visiblePassword,
                    prefix: Icon(
                      Icons.lock_open_outlined,
                      color: AppColors.disableColor,
                    ),
                    sufix: Icon(
                      Icons.visibility_off_outlined,
                      color: AppColors.disableColor,
                    ),
                    controller: passwordcontroller,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please Enter Password";
                      }

                      if (value.length < 6) {
                        return "Password Should be at least 6 chars";
                      }

                      return null;
                    },
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          AppLocalizations.of(context)!.forget_password,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                decoration: TextDecoration.underline,
                                decorationColor: Theme.of(context).dividerColor,
                              ),
                        ),
                      ),
                    ],
                  ),

                  CustomElevatedBottom(
                    onPressed: () => login(context),
                    child: Text(
                      AppLocalizations.of(context)!.login,
                      style: AppStyles.medium18White,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.dont_have_account,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.registerRouteName);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.signup,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                decoration: TextDecoration.underline,
                                decorationColor: Theme.of(context).cardColor,
                              ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Theme.of(context).dividerColor,
                          thickness: 2,
                          indent: width * 0.02,
                          endIndent: width * 0.06,
                        ),
                      ),
                      Text(AppLocalizations.of(context)!.or),
                      Expanded(
                        child: Divider(
                          color: Theme.of(context).dividerColor,
                          thickness: 2,
                          indent: width * 0.06,
                          endIndent: width * 0.02,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.03),

                  CustomElevatedBottom(
                    bordercolor: Theme.of(context).dividerColor,
                    pading: height * 0.02,
                    backgroundcolor: Theme.of(context).highlightColor,
                    onPressed: () async {
                      User? user = await FirebaseUtils.signInWithGoogle();

                      if (user != null) {
                        ToastUtiles.toastMsg(
                          msg: "Google Login Successfully",
                          backgroundColor: Colors.green,
                          textColor: AppColors.whiteColor,
                        );
                        if (context.mounted) {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed(AppRoutes.homeRouteName);
                        }
                      } else {
                        _showError("Google Login Failed");
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: width * 0.04,
                      children: [
                        Image.asset(AppAssets.googleLogo),
                        Text(
                          AppLocalizations.of(context)!.login_with_google,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showError(String msg) {
    ToastUtiles.toastMsg(
      msg: msg,
      backgroundColor: AppColors.redColor,
      textColor: AppColors.whiteColor,
    );
  }

  Future<void> login(BuildContext context) async {
    if (formkey.currentState?.validate() != true) return;

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailcontroller.text.trim(),
        password: passwordcontroller.text,
      );

      ToastUtiles.toastMsg(
        msg: "Login successfully",
        backgroundColor: Colors.green,
        textColor: AppColors.whiteColor,
      );

      debugPrint("id: ${credential.user?.uid}");

      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.homeRouteName);
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
        case 'user-not-found':
        case 'wrong-password':
          _showError("Email or password incorrect");
          break;

        case 'invalid-email':
          _showError("Invalid email format");
          break;

        case 'user-disabled':
          _showError("This account has been disabled");
          break;

        case 'too-many-requests':
          _showError("Too many attempts, try again later");
          break;

        case 'network-request-failed':
          _showError("No Internet Connection");
          break;

        default:
          _showError("Something went wrong, try again");
      }
    } catch (e) {
      debugPrint(e.toString());
      _showError("Something went wrong, try again");
    }
  }
}
