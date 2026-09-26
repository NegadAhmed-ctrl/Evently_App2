import 'package:flutter/material.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:flutter_application_1/l10n/provider/app_theme_provider.dart';
import 'package:flutter_application_1/ui/widgets/custom_elevated_bottom.dart';
import 'package:flutter_application_1/ui/widgets/custom_text_field.dart';
import 'package:flutter_application_1/utils/app_assets.dart';
import 'package:flutter_application_1/utils/app_colors.dart';
import 'package:flutter_application_1/utils/app_routes.dart';
import 'package:flutter_application_1/utils/app_styles.dart';
import 'package:flutter_application_1/utils/app_theme.dart';
import 'package:flutter_application_1/utils/size_utils.dart';
import 'package:flutter_application_1/utils/toast_utiles.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final namecontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final rePasswordcontroller = TextEditingController();
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
                    AppLocalizations.of(context)!.create_your_account,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  CustomTextField(
                    hintText: AppLocalizations.of(context)!.name_hint,
                    hintStyle: Theme.of(context).textTheme.bodyLarge,
                    prefix: Icon(
                      Icons.person_2_outlined,
                      color: AppColors.disableColor,
                    ),
                    controller: namecontroller,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please Enter Name";
                      }
                      return null;
                    },
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

                  CustomTextField(
                    style: Theme.of(context).textTheme.bodySmall,
                    hintText: AppLocalizations.of(
                      context,
                    )!.confirm_password_hint,
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
                    controller: rePasswordcontroller,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please Enter Password";
                      }
                      if (value != passwordcontroller.text) {
                        return "Re-Password does not match";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.02),

                  CustomElevatedBottom(
                    onPressed: () => register(context),
                    child: Text(
                      AppLocalizations.of(context)!.signup,
                      style: AppStyles.medium18White,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.already_have_account,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.login,
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
                  SizedBox(height: height * 0.01),

                  CustomElevatedBottom(
                    bordercolor: Theme.of(context).dividerColor,
                    pading: height * 0.02,
                    backgroundcolor: Theme.of(context).highlightColor,
                    onPressed: () => register(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: width * 0.04,
                      children: [
                        Image.asset(AppAssets.googleLogo),
                        Text(
                          AppLocalizations.of(context)!.signup_with_google,
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

  Future<void> register(BuildContext context) async {
    if (formkey.currentState?.validate() != true) return;

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailcontroller.text.trim(),
            password: passwordcontroller.text,
          );

      await credential.user?.updateDisplayName(namecontroller.text.trim());

      ToastUtiles.toastMsg(
        msg: "Account created successfully",
        backgroundColor: Colors.green,
        textColor: AppColors.whiteColor,
      );

      debugPrint("id: ${credential.user?.uid}");

      // ✅ غير الـ Navigator.pop بـ pushReplacementNamed
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.homeRouteName);
      } // Go back to the login screen after a successful sign up
      if (context.mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          _showError("The password provided is too weak");
          break;
        case 'email-already-in-use':
          _showError("The account already exists for that email");
          break;
        case 'invalid-email':
          _showError("Invalid email format");
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
