import 'package:flutter/material.dart';

class MyTextFieldWidget extends StatelessWidget {
  const MyTextFieldWidget({
    super.key,
    required this.controller,
    required this.nameOfField,
    required this.portionWidth,
  });

  final TextEditingController controller;
  final String nameOfField;
  final double portionWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraint) {
          return getMyTextField(
            constraint,
            controller,
            nameOfField,
            portionWidth,
          );
        },
      ),
    );
  }
}

SizedBox getMyTextField(
  BoxConstraints constraint,
  TextEditingController controller,
  String nameOfField,
  double portionWidth,
) {
  return SizedBox(
    width: constraint.maxWidth / portionWidth,
    child: Row(
      children: [
        SizedBox(width: 75, child: Text(nameOfField)),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(border: OutlineInputBorder()),
            onChanged: (String value) {},
          ),
        ),
      ],
    ),
  );
}
