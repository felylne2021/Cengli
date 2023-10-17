import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';

class FilledTextFieldWidget extends TextFormField {
  final String? hint;
  final TextEditingController controller;
  final String? errorMessage;
  final Widget? prefix;
  final Widget? suffix;
  final String? title;
  final bool? isEnabled;
  final Color? fillColor;
  final double borderRadius;
  final Function(String)? onChanged;

  FilledTextFieldWidget(
      {super.key,
      this.prefix,
      this.suffix,
      this.hint,
      required this.controller,
      this.errorMessage,
      this.title,
      this.isEnabled,
      this.borderRadius = 10.0,
      this.fillColor,
      this.onChanged})
      : super(
          onChanged: onChanged,
          decoration: InputDecoration(
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                borderSide: BorderSide.none,
              ),
              fillColor: fillColor,
              hintText: hint,
              hintStyle: KxTypography(
                  type: KxFontType.fieldText1, color: KxColors.neutral400),
              suffixIconConstraints:
                  const BoxConstraints(minHeight: 16, minWidth: 16),
              prefixIconConstraints:
                  const BoxConstraints(minHeight: 16, minWidth: 16),
              prefixIcon: prefix,
              suffixIcon: suffix,
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1.0),
              ),
              errorText: errorMessage),
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return errorMessage;
            }
            return null;
          },
          enabled: isEnabled,
        );
}
