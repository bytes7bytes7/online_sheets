import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_sheets/dto/cell_event_dto.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'table_event.dart';

part 'table_state.dart';

const _uri = 'ws://10.0.2.2:8080';
// const _uri = 'ws://localhost:8080';

class TableBloc extends Bloc<TableEvent, TableState> {
  TableBloc() : super(TableState(values: HashMap())) {
    on<ConnectEvent>(_connect);
    on<BlockedCellClickedEvent>(_showBlockedCellMsg);
    on<EditCellEvent>(_editCell);

    on<_UpdateCellEvent>(_updateCell);
  }

  WebSocketChannel? _channel;
  StreamSubscription? _channelSub;
  final _jsonCodec = const JsonCodec();

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
      final wsUrl = Uri.parse(_uri);
      final channel = _channel = WebSocketChannel.connect(wsUrl);

      emit(
        state.copyWith(
          connection: ConnectionStatus.connected,
        ),
      );

      _channelSub = channel.stream.listen((message) {
        final jsonData = _jsonCodec.decode(message);
        final dto = CellEventDTO.fromJson(jsonData);

        add(
          _UpdateCellEvent(
            cellID: dto.cellID,
            value: dto.value,
          ),
        );
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

  void _showBlockedCellMsg(
      BlockedCellClickedEvent event, Emitter<TableState> emit) {
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

    final dto = CellEventDTO(
      cellID: event.cellID,
      value: event.value,
    );

    final jsonData = _jsonCodec.encode(dto.toJson());

    channel.sink.add(jsonData);

    emit(
      state.copyWith(
        values: HashMap.of(state.values)..[event.cellID] = event.value,
      ),
    );
  }

  void _updateCell(_UpdateCellEvent event, Emitter<TableState> emit) {
    emit(
      state.copyWith(
        values: HashMap.of(state.values)..[event.cellID] = event.value,
      ),
    );
  }
}
