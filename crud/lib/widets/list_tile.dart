import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final String child;
  const Square({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(title: Text(child)),
    );
  }
}
