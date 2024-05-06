// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'match_controller_bloc.dart';

sealed class MatchControllerEvent extends Equatable {
  const MatchControllerEvent();

  @override
  List<Object> get props => [];
}
class ChangeMatchControllerEvent extends MatchControllerEvent {
  final MatchStatus events;
  final List<int>  singalingdata;
  const ChangeMatchControllerEvent({
    required this.singalingdata,
    required this.events,
  });
  
  @override
  List<Object> get props => [events,singalingdata];
  @override
  String toString() => 'ChangeMatchControllerEvent(events: $events,singalingdata : $singalingdata)';
}
