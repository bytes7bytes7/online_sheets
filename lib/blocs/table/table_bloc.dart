import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'table_event.dart';

part 'table_state.dart';

class TableBloc extends Bloc<TableEvent, TableState> {
  TableBloc() : super(TableState(values: HashMap())) {
    on<ConnectEvent>(_connect);
    on<EditCellEvent>(_editCell);
  }

  WebSocketChannel? _channel;

  Future<void> _connect(ConnectEvent event, Emitter<TableState> emit) async {
    final wsUrl = Uri.parse('ws://10.0.2.2:8080');
    final channel = _channel = WebSocketChannel.connect(wsUrl);

    channel.sink.add('hello world');

    channel.stream.listen((message) {
      print('received: $message');
    });
  }

  void _editCell(EditCellEvent event, Emitter<TableState> emit) {
    _channel?.sink.add(event.toString());

    emit(
      state.copyWith(
        values: HashMap.of(state.values)..[event.cellID] = event.value,
      ),
    );
  }
}
