import 'package:flutter/material.dart';

class Text_Form_Field extends StatelessWidget {
  final String? hintText;
  final obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardtype;
  final int? maxlength;
  final TextEditingController? controller;
  final Widget? sicon;
  final Widget? picon;
  final TextInputAction? textInputAction;
  final bool readOnly;

  Text_Form_Field(
      {super.key,
        required this.hintText,
        this.obscureText = false,
        this.validator,
        this.keyboardtype,
        this.maxlength,
        this.controller,
        this.sicon,
        this.picon,
        this.textInputAction,
        this.readOnly = false,
      });

  @override
  Widget build(BuildContext context) {
    // final themeChange = Provider.of<ThemeProvider>(context);
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardtype,
      textInputAction: textInputAction,
      maxLength: maxlength,
      readOnly: readOnly,
      decoration: InputDecoration(
        counterText: '',
        prefixIcon: picon,
        suffixIcon: sicon,
        hintText: hintText,
        // fillColor: themeChange.darkTheme ? Colors.grey[800] : Colors.grey.shade200,
        filled: true,
        hintStyle: TextStyle(
          // color: themeChange.darkTheme ? Colors.grey[200] : Colors.grey[800],
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
