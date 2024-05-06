
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'camera_status_state.dart';

class CameraStatusCubit extends Cubit<CameraStatusState> {
  CameraStatusCubit() : super(CameraStatusState.initial());
  
  updateIconCameraStatus() => emit(state.copyWith(iconcamerastatus: state.iconcamerastatus ? false : true));
  updateRenderCameraStatus() => emit(state.copyWith(rendercamerastatus: state.rendercamerastatus ? false : true));
}
