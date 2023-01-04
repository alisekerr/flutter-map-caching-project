import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'general_event.dart';
part 'general_state.dart';

class GeneralBloc extends Bloc<GeneralEvent, GeneralState> {
  GeneralBloc()
      : super(
          const GeneralState(
            currentStore: '',
          ),
        ) {
    on<CurrentStoreSet>(_onCurrentStoreSet);
  }

  final StreamController<void> resetController = StreamController.broadcast();

  void resetMap() => resetController.add(null);

  void _onCurrentStoreSet(
    CurrentStoreSet event,
    Emitter<GeneralState> emit,
  ) {
    emit(
      state.copyWith(
        currentStore: event.currentStore,
      ),
    );
  }
}
