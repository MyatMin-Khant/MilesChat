

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'clientids_state.dart';

class ClientidsCubit extends Cubit<ClientidsState> {
  ClientidsCubit() : super(ClientidsState.initial());

  updateRemoteClientIdAndRoomID(String clientid,String roomid,String name)  => emit(state.copyWith(remoteclientname: name,remoteclientsid: clientid,roomid: roomid));
  

  clearRoomID() => emit(state.copyWith(roomid:  ''));


  
}
