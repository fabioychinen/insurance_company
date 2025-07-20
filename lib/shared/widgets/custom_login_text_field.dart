import 'package:flutter/material.dart';

class CustomLoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final InputDecoration? decoration;
  final TextAlign textAlign;

  const CustomLoginTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.decoration,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: decoration ??
          InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
    );
  }
}