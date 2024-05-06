

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'match_controller_event.dart';
part 'match_controller_state.dart';

class MatchControllerBloc extends Bloc<MatchControllerEvent, MatchControllerState> {
  MatchControllerBloc() : super(MatchControllerState.initial()) {
    on<ChangeMatchControllerEvent>(updateMatch);
  }
  updateMatch(ChangeMatchControllerEvent event,Emitter<MatchControllerState> emit) => emit(state.copyWith(matchstatus: event.events,singalingdata: event.singalingdata));

   
  }
 
  

