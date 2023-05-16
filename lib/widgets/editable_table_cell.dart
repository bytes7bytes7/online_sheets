import 'package:flutter/material.dart';

const _cellHeight = 40.0;

class EditableTableCell extends StatefulWidget {
  const EditableTableCell({
    super.key,
    required this.onChanged,
    String? value,
  }) : value = value ?? '';

  final void Function(String) onChanged;
  final String value;

  @override
  State<EditableTableCell> createState() => _EditableTableCellState();
}

class _EditableTableCellState extends State<EditableTableCell> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(EditableTableCell oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldValue = _controller.text;

    if (oldValue != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: SizedBox(
        height: _cellHeight,
        child: Center(
          child: TextField(
            controller: _controller,
            onChanged: widget.onChanged,
          ),
        ),
      ),
    );
  }
}
