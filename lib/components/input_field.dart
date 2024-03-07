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
        maxLines: bigField ? null : 3,
        keyboardType: bigField ? TextInputType.multiline : TextInputType.text,
        decoration: InputDecoration(
          // enabledBorder: OutlineInputBorder(
          //   borderSide: BorderSide(
          //     color: Theme.of(context).colorScheme.tertiary,
          //   ),
          // ),
          // focusedBorder: OutlineInputBorder(
          //   borderSide: BorderSide(
          //     color: Theme.of(context).colorScheme.primary,
          //   ),
          // ),
          filled: true,
          // fillColor: Theme.of(context).colorScheme.secondary,
          hintText: hintText != "" ? hintText : "Type here...",
          // hintStyle: TextStyle(
          //   color: Theme.of(context).colorScheme.primary,
          // ),
        ),
      ),
    );
  }
}
