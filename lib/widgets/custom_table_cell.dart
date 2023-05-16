import 'package:flutter/material.dart';

const cellWidth = 50.0;

class CustomTableCell extends StatelessWidget {
  const CustomTableCell({
    super.key,
    required this.value,
    this.color,
  });

  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cellWidth,
      height: cellWidth,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Colors.black12,
          width: 1.0,
        ),
      ),
      child: Text(
        value,
        style: const TextStyle(fontSize: 16.0),
      ),
    );
  }
}
