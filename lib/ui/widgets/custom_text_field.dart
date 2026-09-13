import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final Color? borderColor;
  final Color? cursorColor;
  final String? hintText;
  final String? labelText;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;

  CustomTextField({
    super.key,
    this.borderColor,
    this.cursorColor,
    this.hintStyle,
    this.hintText,
    this.labelStyle,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: cursorColor ?? AppColors.mainLightColor,
      decoration: InputDecoration(
        enabledBorder: _buildDecorationBorder(
          borderColor: borderColor ?? Theme.of(context).highlightColor,
        ),
        focusedBorder: _buildDecorationBorder(
          borderColor: borderColor ?? Theme.of(context).highlightColor,
        ),
        errorBorder: _buildDecorationBorder(borderColor: Colors.red),
        focusedErrorBorder: _buildDecorationBorder(borderColor: Colors.red),
        hintText: hintText,
        hintStyle: hintStyle,
        labelText: labelText,
        labelStyle: labelStyle,
      ),
    );
  }

  OutlineInputBorder _buildDecorationBorder({required Color borderColor}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(width: 2, color: borderColor),
    );
  }
}
