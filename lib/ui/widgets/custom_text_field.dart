import 'package:flutter/material.dart';

import 'package:flutter_application_1/utils/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final Color? borderColor;

  final Color? cursorColor;

  final String? hintText;

  final String? labelText;

  final TextStyle? hintStyle;

  final TextStyle? labelStyle;

  final Widget? prefix;

  final Widget? sufix;

  final TextStyle? style;

  final TextEditingController? controller;

  final void Function(String)? onChanged;

  final String? Function(String?)? validator;

  final TextInputType? keybordType;

  final bool? obScureText;

  final int? maxilines;

  final String? obscuringCharacter;

  const CustomTextField({
    super.key,

    this.borderColor,

    this.cursorColor,

    this.hintStyle,

    this.hintText,

    this.labelStyle,

    this.labelText,

    this.prefix,

    this.sufix,

    this.style,

    this.controller,

    this.onChanged,

    this.validator,

    this.keybordType,

    this.maxilines,

    this.obScureText,

    this.obscuringCharacter,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,

      onChanged: onChanged,

      validator: validator,

      keyboardType: keybordType ?? TextInputType.text,

      obscureText: obScureText ?? false,

      maxLines: maxilines,

      obscuringCharacter: obscuringCharacter ?? "*",

      style: style,

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

        prefixIcon: prefix,

        suffixIcon: sufix,
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
