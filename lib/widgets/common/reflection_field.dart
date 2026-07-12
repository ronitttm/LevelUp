import 'package:flutter/material.dart';

class ReflectionTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final int maxLines;
  final bool autofocus;

  const ReflectionTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.maxLines = 5,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      maxLines: maxLines,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.multiline,

      decoration: InputDecoration(
        hintText:
            hintText ??
            "How did today's mission go?\n"
                "What did you learn?\n"
                "Anything you'd do differently?",

        filled: true,
        fillColor: Colors.grey.shade100,

        contentPadding: const EdgeInsets.all(16),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.lightBlue, width: 2),
        ),
      ),
    );
  }
}
