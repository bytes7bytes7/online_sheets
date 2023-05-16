part of 'table_bloc.dart';

enum ConnectionStatus {
  connecting,
  connected,
  noConnection,
}

class TableState extends Equatable {
  const TableState({
    this.error = '',
    this.connection = ConnectionStatus.noConnection,
    required this.values,
  });

  final String error;
  final ConnectionStatus connection;
  final HashMap<String, String> values;

  TableState copyWith({
    String? error = '',
    ConnectionStatus? connection,
    HashMap<String, String>? values,
  }) {
    return TableState(
      error: error ?? this.error,
      connection: connection ?? this.connection,
      values: values ?? this.values,
    );
  }

  @override
  List<Object?> get props => [
        error,
        connection,
        values,
      ];
}
