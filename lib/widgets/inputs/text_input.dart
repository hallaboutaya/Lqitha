library;
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: Colors.white.withOpacity(0.80),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.27, color: Colors.white.withOpacity(0.60)),
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: const [
          BoxShadow(color: AppColors.shadowPurpleSubtle, blurRadius: 40, offset: Offset(0, 12)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}


