// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'pre_service_bloc.dart';

abstract  class PreServiceEvent extends Equatable {
  const PreServiceEvent();

  @override
  List<Object> get props => [];
}

class PreMatchEvent extends PreServiceEvent {
  final List<int> singalingdata;  
  final MatchStatus matchstatus;
  const PreMatchEvent({
    required this.matchstatus,
    required this.singalingdata,
  });
  @override
  List<Object> get props => [singalingdata,matchstatus];

  @override
  String toString() => 'SingalingMatchEvent(singalingdata: $singalingdata, matchstatus: $matchstatus)';
}
class PreStatusEvent extends  PreServiceEvent {
  final PreStatus prestatus;
  final List<int> recevicesingalingdata;
  const PreStatusEvent({
    required this.recevicesingalingdata,
    required this.prestatus
  });
  

  @override
  String toString() => 'PreStatusEvent(prestatus: $prestatus,singalingdata : $recevicesingalingdata)';

  @override
  List<Object> get props => [prestatus,recevicesingalingdata];
  
}

