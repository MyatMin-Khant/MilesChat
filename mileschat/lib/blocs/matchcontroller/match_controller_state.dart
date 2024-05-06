// ignore_for_file: public_member_api_docs, sort_constructors_first



part of 'match_controller_bloc.dart';

enum MatchStatus {
  initial,
  joinchatroom,
  offertoremote,
  sendoffertoremote,
  waitoffer,
  answertoremote,
  sendanswertoremote,
  sendcandiatetooffer,
  waitcandiate,
  rematch,
  sucessfullyconnectmatch,
  failneworkconnection,
  nextmatch,
  leavechat
}
class MatchControllerState extends Equatable {
  final MatchStatus matchstatus;
  final List<int> singalingdata;
  const MatchControllerState({
    required this.matchstatus,
    required this.singalingdata,
  });
  factory MatchControllerState.initial() => const MatchControllerState(matchstatus: MatchStatus.initial,singalingdata: []);
  
  @override
  List<Object> get props => [matchstatus, singalingdata];

  MatchControllerState copyWith({
    MatchStatus? matchstatus,
    List<int>?  singalingdata,
  }) {
    return MatchControllerState(
      matchstatus: matchstatus ?? this.matchstatus,
      singalingdata: singalingdata ?? this.singalingdata,
    );
  }

  @override
  bool get stringify => true;
}
