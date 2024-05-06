// ignore_for_file: public_member_api_docs, sort_constructors_first









part of 'remote_client_status_cubit.dart';

class RemoteClientStatusState extends Equatable {
  final bool remoteclientoundstatus;
  final bool clientrenderstatus;
  final bool clientconnectstatus;
  final bool clientvideoconnectstatus;
  
  const RemoteClientStatusState({
    required this.remoteclientoundstatus,
    required this.clientrenderstatus,
    required this.clientconnectstatus,
    required this.clientvideoconnectstatus,
  });
  
  factory RemoteClientStatusState.initial() => const RemoteClientStatusState(remoteclientoundstatus: false,clientrenderstatus: false,clientconnectstatus: false,
  clientvideoconnectstatus: false);

  @override
  bool get stringify => true;
  
  @override
  List<Object> get props => [remoteclientoundstatus, clientrenderstatus, clientconnectstatus, clientvideoconnectstatus];

  RemoteClientStatusState copyWith({
    bool? remoteclientoundstatus,
    bool? clientrenderstatus,
    bool? clientconnectstatus,
    bool? clientvideoconnectstatus,
  }) {
    return RemoteClientStatusState(
      remoteclientoundstatus: remoteclientoundstatus ?? this.remoteclientoundstatus,
      clientrenderstatus: clientrenderstatus ?? this.clientrenderstatus,
      clientconnectstatus: clientconnectstatus ?? this.clientconnectstatus,
      clientvideoconnectstatus: clientvideoconnectstatus ?? this.clientvideoconnectstatus,
    );
  }
}
