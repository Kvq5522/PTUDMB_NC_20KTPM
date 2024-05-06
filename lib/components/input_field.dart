import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final bool bigField;
  final TextEditingController controller;
  final FocusNode? focusNode;

  const InputField(
      {Key? key,
      this.hintText = "",
      this.obscureText = false,
      this.bigField = false,
      required this.controller,
      this.focusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200], // Set the background color here
        borderRadius:
            BorderRadius.circular(10), // Optional: Apply border radius
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        maxLines: bigField ? 7 : null,
        keyboardType: bigField ? TextInputType.multiline : TextInputType.text,
        cursorColor: Colors.grey,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText != "" ? hintText : 'Type here...'.tr(),
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
