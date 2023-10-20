import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'game_screen_event.dart';
part 'game_screen_state.dart';

class GameScreenBloc extends Bloc<GameScreenEvent, GameScreenState> {
  GameScreenBloc() : super(GameScreenInitial()) {
    on<GameScreenEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
