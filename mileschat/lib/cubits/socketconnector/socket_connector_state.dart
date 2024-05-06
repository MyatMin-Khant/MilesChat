// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'socket_connector_cubit.dart';

class SocketConnectorState extends Equatable {
  final Socket socketio;
  final Socket paymentsocketio;
  final bool tokensetstatus;
  const SocketConnectorState({
    required this.paymentsocketio,
    required this.socketio,
    required this.tokensetstatus,
  });

  factory SocketConnectorState.initial() {
    return SocketConnectorState(socketio: io(
      dotenv.env['singalingurl'],
      OptionBuilder().enableForceNewConnection().setTransports(['websocket']).disableAutoConnect().build()
    ),
    paymentsocketio: io(dotenv.env["callbackurl"],OptionBuilder().enableForceNewConnection().setTransports(['websocket']).disableAutoConnect().build()),
    tokensetstatus: false);
  }
  
  @override
  List<Object> get props => [socketio, paymentsocketio, tokensetstatus];




  @override
  bool get stringify => true;

  SocketConnectorState copyWith({
    Socket? socketio,
    Socket? paymentsocketio,
    bool? tokensetstatus,
  }) {
    return SocketConnectorState(
      socketio: socketio ?? this.socketio,
      paymentsocketio: paymentsocketio ?? this.paymentsocketio,
      tokensetstatus: tokensetstatus ?? this.tokensetstatus,
    );
  }
}
