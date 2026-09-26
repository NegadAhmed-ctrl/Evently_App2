import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/app_colors.dart';
import 'package:flutter_application_1/utils/size_utils.dart';

class CustomElevatedBottom extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final Color? backgroundcolor;
  final Color? bordercolor;
  final double? pading;
  const CustomElevatedBottom({
    super.key,
    this.onPressed,
    this.child,
    this.backgroundcolor,
    this.bordercolor,
    this.pading,
  });

  @override
  Widget build(BuildContext context) {
    var hieght = context.height;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: bordercolor ?? AppColors.transparentColor),
          borderRadius: BorderRadiusGeometry.circular(16),
        ),
        padding: EdgeInsets.symmetric(vertical: pading ?? hieght * 0.01),
        backgroundColor: backgroundcolor ?? Theme.of(context).cardColor,
      ),

      onPressed: onPressed,
      child: child,
    );
  }
}
