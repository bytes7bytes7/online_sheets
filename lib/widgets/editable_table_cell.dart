import 'package:flutter/material.dart';

const _cellHeight = 40.0;

class EditableTableCell extends StatelessWidget {
  const EditableTableCell({
    super.key,
    required this.onChanged,
    String? value,
  }) : value = value ?? '';

  final void Function(String) onChanged;
  final String value;

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: SizedBox(
        height: _cellHeight,
        child: Center(
          child: TextFormField(
            initialValue: value,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
