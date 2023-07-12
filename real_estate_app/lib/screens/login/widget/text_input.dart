import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextInput extends StatelessWidget {
  final textEditingController;
  final TextInputType textInputType;
  final String hint;
  final bool hideInput;
  final String? label;

  final String? Function(String?)? validator;
  final String? Function(String?)? onChnaged;


  const TextInput({
    Key? key,
    required this.textEditingController,
    required this.hint,
    required this.hideInput,
    this.validator,
    required this.textInputType,
    this.label,
    this.onChnaged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChnaged,
      controller: textEditingController,
      obscureText: hideInput,
      validator: validator,
      keyboardType: textInputType,
      decoration: InputDecoration(
        label: label != null ? Text(label!) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        filled: true,
        
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
