
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'match_swip_state.dart';

class MatchSwipCubit extends Cubit<MatchSwipeState> {
  MatchSwipCubit() : super(MatchSwipeState.initial());

  updatePosWidgetSwipe(int gestureeventstatus,int poswipe)  =>   
  emit(state.copyWith(gestureswipedstatus: gestureeventstatus,posswipe: poswipe));

  updateWidgetSwipeOverStatus(int value) => emit(state.copyWith(widgetswipeoverstatus: value));

  updateWidgetinitalStater(int value) => emit(state.copyWith(initialwidgetstarter: value));

  
  

  
}
