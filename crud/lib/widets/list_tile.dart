import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final String child;
  final bool selected;
  final Function() onTap;
  const Square({
    super.key,
    required this.child,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(child),
        selected: selected,
        onTap: onTap,
        selectedTileColor: Colors.lightGreenAccent,
      ),
    );
  }
}
