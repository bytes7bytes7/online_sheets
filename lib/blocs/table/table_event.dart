part of 'table_bloc.dart';

abstract class TableEvent extends Equatable {
  const TableEvent();

  @override
  List<Object?> get props => [];
}

class ConnectEvent extends TableEvent {
  const ConnectEvent();
}

class BlockedCellClickedEvent extends TableEvent {
  const BlockedCellClickedEvent();
}

class EditCellEvent extends TableEvent {
  const EditCellEvent({
    required this.cellID,
    required this.value,
  });

  final String cellID;
  final String value;

  @override
  List<Object?> get props => [cellID, value];
}

class _UpdateCellEvent extends TableEvent {
  const _UpdateCellEvent({
    required this.cellID,
    required this.value,
  });

  final String cellID;
  final String value;

  @override
  List<Object?> get props => [cellID, value];
}
