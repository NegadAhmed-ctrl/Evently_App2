import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/l10n/provider/app_theme_provider.dart';
import 'package:flutter_application_1/ui/widgets/custom_elevated_bottom.dart';
import 'package:flutter_application_1/ui/widgets/custom_text_field.dart';
import 'package:flutter_application_1/utils/app_assets.dart';
import 'package:flutter_application_1/utils/app_colors.dart';
import 'package:flutter_application_1/utils/app_routes.dart';
import 'package:flutter_application_1/utils/size_utils.dart';
import 'package:flutter_application_1/utils/toast_utiles.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isObscure = true;
  bool isObscureRe = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (formKey.currentState?.validate() == true) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text,
            );

        await userCredential.user?.updateDisplayName(
          nameController.text.trim(),
        );

        if (mounted) {
          ToastUtiles.toastMsg(
            msg: "Account created successfully!",
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          Navigator.pushReplacementNamed(context, AppRoutes.homeRouteName);
        }
      } catch (e) {
        ToastUtiles.toastMsg(
          msg: "Registration Failed: ${e.toString()}",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;
    var themeProvider = Provider.of<AppThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: themeProvider.isDark
              ? AppColors.whiteColor
              : AppColors.mainLightColor,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    themeProvider.isDark
                        ? AppAssets.eventlyLogoDark
                        : AppAssets.eventlyLogo,
                    height: height * 0.1,
                  ),
                  SizedBox(height: height * 0.05),
                  CustomTextField(
                    controller: nameController,
                    hintText: "Name",
                    prefixIcon: Icon(
                      Icons.person,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Please enter your name";
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.02),
                  CustomTextField(
                    controller: emailController,
                    hintText: "Email",
                    prefixIcon: Icon(
                      Icons.email,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Please enter your email";
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.02),
                  CustomTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: isObscure,
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscure ? Icons.visibility_off : Icons.visibility,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () => setState(() => isObscure = !isObscure),
                    ),
                    validator: (value) {
                      if (value == null || value.length < 6)
                        return "Password must be at least 6 characters";
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.02),
                  CustomTextField(
                    controller: rePasswordController,
                    hintText: "Re-enter Password",
                    obscureText: isObscureRe,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscureRe ? Icons.visibility_off : Icons.visibility,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () =>
                          setState(() => isObscureRe = !isObscureRe),
                    ),
                    validator: (value) {
                      if (value != passwordController.text)
                        return "Passwords do not match";
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.04),
                  CustomElevatedBottom(
                    backgroundcolor: themeProvider.isDark
                        ? AppColors.mainDarkColor
                        : AppColors.mainLightColor,
                    onPressed: _register,
                    child: const Text(
                      "Create Account",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      InkWell(
                        onTap: () {
                          // ✅ تم التعديل هنا لـ onTap
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: AppColors.mainLightColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.mainLightColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
