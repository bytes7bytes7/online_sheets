import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/table/table_bloc.dart';

const _horItemCount = 3;
const _verItemCount = 3;
const _cellHeight = 40.0;

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  final _focus = FocusNode();

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TableBloc>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_focus);
      },
      child: BlocBuilder<TableBloc, TableState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Online Sheets'),
            ),
            body: SafeArea(
              child: Table(
                border: TableBorder.all(),
                children: List.generate(
                  _verItemCount,
                  (outerIndex) {
                    return TableRow(
                      children: List.generate(
                        _horItemCount,
                        (innerIndex) {
                          final cellID = '$outerIndex $innerIndex';

                          return EditableTableCell(
                            value: state.values[cellID],
                            onChanged: (v) {
                              bloc.add(
                                EditCellEvent(
                                  cellID: cellID,
                                  value: v,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

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
