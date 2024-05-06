
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mileschat/cubits/userdata/userdata_cubit.dart';

part 'transcation_status_state.dart';

class TranscationStatusCubit extends Cubit<TranscationStatusState> {
  final UserDataCubit userdatacubit;
  TranscationStatusCubit({required this.userdatacubit}) : super(TranscationStatusState.initial());

  updateTranscationStatus(TranscationStatus status) {
    emit(state.copyWith(transcationstatus: status));
    userdatacubit.updateTranscationStatus(status == TranscationStatus.failconnection ? "failconnection" :
    status == TranscationStatus.initialloseconnection ? "initialloseconnection" : 
    status == TranscationStatus.pending  ? "pending" : status == TranscationStatus.transcationfail ? "transcationfail" :
    status == TranscationStatus.transcationsucessully ? "transcationsucessully" : "initial");
  }
}
