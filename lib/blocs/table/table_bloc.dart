import 'dart:async';
import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'table_event.dart';

part 'table_state.dart';

class TableBloc extends Bloc<TableEvent, TableState> {
  TableBloc() : super(TableState(values: HashMap())) {
    on<ConnectEvent>(_connect);
    on<BlockedCellClickedEvent>(_showBlockedCellMsg);
    on<EditCellEvent>(_editCell);
  }

  WebSocketChannel? _channel;
  StreamSubscription? _channelSub;

  void dispose() {
    _channelSub?.cancel();
    _channel?.sink.close();
  }

  Future<void> _connect(ConnectEvent event, Emitter<TableState> emit) async {
    emit(
      state.copyWith(
        connection: ConnectionStatus.connecting,
      ),
    );

    try {
      final wsUrl = Uri.parse('ws://10.0.2.2:8080');
      throw 1;
      final channel = _channel = WebSocketChannel.connect(wsUrl);

      emit(
        state.copyWith(
          connection: ConnectionStatus.connected,
        ),
      );

      _channelSub = channel.stream.listen((message) {
        // TODO:
      });
    } catch (e) {
      emit(
        state.copyWith(
          error: 'Не удалось установить соединение',
          connection: ConnectionStatus.noConnection,
        ),
      );

      emit(state.copyWith(error: ''));
    }
  }

  void _showBlockedCellMsg(BlockedCellClickedEvent event, Emitter<TableState> emit) {
    emit(
      state.copyWith(
        error: 'Редактирование невозможно без наличия соединения',
      ),
    );

    emit(state.copyWith(error: ''));
  }

  void _editCell(EditCellEvent event, Emitter<TableState> emit) {
    final channel = _channel;

    if (channel == null) {
      emit(
        state.copyWith(
          error: 'Нет соединения',
        ),
      );

      emit(state.copyWith(error: ''));

      return;
    }

    channel.sink.add(event.toString());

    emit(
      state.copyWith(
        values: HashMap.of(state.values)..[event.cellID] = event.value,
      ),
    );
  }
}
