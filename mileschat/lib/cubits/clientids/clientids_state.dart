// ignore_for_file: public_member_api_docs, sort_constructors_first






part of 'clientids_cubit.dart';

class ClientidsState extends Equatable {

  final String remoteclientsid;
  final String roomid;
  final String remoteclientname;
  

  const ClientidsState({
    required this.remoteclientsid,
    required this.roomid,
    required this.remoteclientname,
  });
  factory ClientidsState.initial() {
    return const ClientidsState(remoteclientsid: "",roomid: "",remoteclientname: '');
  }

  @override
  bool get stringify => true;

  ClientidsState copyWith({
    String? remoteclientsid,
    String? roomid,
    String? remoteclientname,
  }) {
    return ClientidsState(
      remoteclientsid: remoteclientsid ?? this.remoteclientsid,
      roomid: roomid ?? this.roomid,
      remoteclientname: remoteclientname ?? this.remoteclientname,
    );
  }
  
  @override
  List<Object> get props => [remoteclientsid, roomid, remoteclientname];
} 
