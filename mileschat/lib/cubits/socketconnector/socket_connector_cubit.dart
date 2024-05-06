
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart';



part 'socket_connector_state.dart';

class SocketConnectorCubit  extends Cubit<SocketConnectorState> {

  SocketConnectorCubit() : super(SocketConnectorState.initial());

  
  sendPackageToServer(List data) => state.socketio.emit('clients_request_precon',[data]);
  



  updateTokenSet(String token) => emit(state.copyWith(socketio: io(
      dotenv.env['singalingurl'], 
      OptionBuilder().
      setTransports(['websocket']).
      enableForceNewConnection().
      setQuery({'X-Access-Token' : token}).
      disableAutoConnect().
      build()
  ),tokensetstatus: state.tokensetstatus ? false : true
  ));



}
  