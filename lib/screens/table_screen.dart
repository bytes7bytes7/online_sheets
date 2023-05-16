import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/table/table_bloc.dart';
import '../widgets/widgets.dart';

const _horItemCount = 3;
const _verItemCount = 3;

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
    final theme = Theme.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final bloc = context.read<TableBloc>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_focus);
      },
      child: BlocConsumer<TableBloc, TableState>(
        listener: (context, state) {
          if (state.error.isNotEmpty) {
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text(state.error),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Online Sheets'),
              actions: [
                (state.connection == ConnectionStatus.connecting)
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: CircularProgressIndicator(
                            color: theme.colorScheme.onBackground,
                          ),
                        ),
                      )
                    : state.connection == ConnectionStatus.noConnection
                        ? IconButton(
                            onPressed: () => bloc.add(const ConnectEvent()),
                            icon: const Icon(Icons.refresh),
                          )
                        : const SizedBox.shrink(),
              ],
            ),
            body: GestureDetector(
              onTap: () => bloc.add(const BlockedCellClickedEvent()),
              child: AbsorbPointer(
                absorbing: state.connection != ConnectionStatus.connected,
                child: SafeArea(
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
              ),
            ),
          );
        },
      ),
    );
  }
}
