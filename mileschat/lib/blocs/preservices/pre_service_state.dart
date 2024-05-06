// ignore_for_file: public_member_api_docs, sort_constructors_first




part of 'pre_service_bloc.dart';

enum PreStatus {
  restart,
  initial,
  createoffer,
  createanswer,
  addremotedescription,
  addCandiate,
  sucessfullyconnection,
  nextmatch,
  failpre,
  leavechat
  

}
class PreServiceState extends Equatable {

  final PreStatus prestatus;
  final List<int> recevicesingalingdata;
  const PreServiceState({
    this.prestatus = PreStatus.initial,
    required this.recevicesingalingdata,
  });
  factory PreServiceState.initial() {
    return const PreServiceState(recevicesingalingdata: []);
  }
  

  @override
  List<Object> get props => [prestatus, recevicesingalingdata];

  @override
  bool get stringify => true;

  PreServiceState copyWith({
    PreStatus? prestatus,
    List<int>? recevicesingalingdata,
  }) {
    return PreServiceState(
      prestatus: prestatus ?? this.prestatus,
      recevicesingalingdata: recevicesingalingdata ?? this.recevicesingalingdata,
    );
  }
}
