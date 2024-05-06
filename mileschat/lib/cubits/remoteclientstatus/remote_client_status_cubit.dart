
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'remote_client_status_state.dart';

class RemoteClientStatusCubit extends Cubit<RemoteClientStatusState> {
  RemoteClientStatusCubit() : super(RemoteClientStatusState.initial());

  updateRemoteClientFoundStatus(bool value) => emit(state.copyWith(remoteclientoundstatus: value));

  updateClientRenderStatus(bool value) => emit(state.copyWith(clientrenderstatus: value));

  updateClientConnectStatus() => emit(state.copyWith(clientconnectstatus: state.clientconnectstatus ? false : true));
  updateClientVideoConnectStatus(bool value) => emit(state.copyWith(clientvideoconnectstatus: value));

}
