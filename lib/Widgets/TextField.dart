// ignore: file_names
import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;

  const TextFieldInput({
    super.key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SizedBox(
        height: 70,
        //width: 40,
        child: TextField(
          controller: textEditingController,
          decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.black45),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.grey.withOpacity(0.1),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Color(0xFFFD5530)),
                  borderRadius: BorderRadius.circular(20))),
        ),
      ),
    );
  }
}
