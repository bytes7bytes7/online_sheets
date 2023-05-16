part of 'table_bloc.dart';

class TableState extends Equatable {
  const TableState({
    required this.values,
  });

  final HashMap<String, String> values;

  TableState copyWith({
    HashMap<String, String>? values,
  }) {
    return TableState(
      values: values ?? this.values,
    );
  }

  @override
  List<Object?> get props => [];
}
