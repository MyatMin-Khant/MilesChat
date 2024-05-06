
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'userdata_state.dart';

class UserDataCubit extends Cubit<UserDataState> with HydratedMixin {
  UserDataCubit() : super(UserDataState.initial());

  updateUserData(String id,String token,String name,) => emit(state.copyWith(id: id,token:  token,name: name)); 

  updateBonusStatus(int value) => emit(state.copyWith(bonusmatch: value));

  updatePaymentStatus()  {
    state.paymentstatus == 1 ? emit(state.copyWith(paymentstatus: 0)) : emit(state.copyWith(paymentstatus: 1));
    print('updated payment status');
  }

  updateToken(String token) => emit(state.copyWith(token: token)); 

  updateNetworkConnection(int value) => emit(state.copyWith(networkcon: value ));
  updateLoadingCon(int con) => emit(state.copyWith(loadingcon:  con));

  updateFirstTimesPayment(int value) => emit(state.copyWith(firsttimespay: value));
  updateTranscationStatus(String status) => emit(state.copyWith(transcationstatus: status));
  updateCameraPermissionStatus() => emit(state.copyWith(camerapermissionstatus: state.camerapermissionstatus == 1 ?  0 : 1));
  updateMicPermissionStatus() => emit(state.copyWith(micpermissionstatus: state.micpermissionstatus == 1 ?  0 : 1));
  
  @override
  UserDataState? fromJson(Map<String, dynamic> json)  => UserDataState.fromMap(json);
  
  @override
  Map<String, dynamic>? toJson(UserDataState state) => state.toMap();

  
  
 


  
}
