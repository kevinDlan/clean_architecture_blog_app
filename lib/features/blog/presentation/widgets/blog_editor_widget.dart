import 'package:flutter/material.dart';

class BlogEditorWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  const BlogEditorWidget({
    super.key,
    required this.textEditingController,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(hintText: hintText),
      maxLines: null,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "$hintText is required";
        }
        return null;
      },
    );
  }
}
