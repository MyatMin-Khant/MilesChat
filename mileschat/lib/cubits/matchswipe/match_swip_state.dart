// ignore_for_file: public_member_api_docs, sort_constructors_first





part of 'match_swip_cubit.dart';

class MatchSwipeState extends Equatable {
  final int gestureswipedstatus;
  final int posswipe;
  final int widgetswipeoverstatus;
  final int initialwidgetstarter;
  
  const MatchSwipeState({
    required this.gestureswipedstatus,
    required this.posswipe,
    required this.widgetswipeoverstatus,
    required this.initialwidgetstarter,
  });
  factory MatchSwipeState.initial() => const MatchSwipeState(gestureswipedstatus: 0,posswipe: 0,
  widgetswipeoverstatus: 0,
  initialwidgetstarter: 1);
  
  @override
  bool get stringify => true;

  @override
  List<Object> get props => [gestureswipedstatus, posswipe, widgetswipeoverstatus, initialwidgetstarter];

  MatchSwipeState copyWith({
    int? gestureswipedstatus,
    int? posswipe,
    int? widgetswipeoverstatus,
    int? initialwidgetstarter,
  }) {
    return MatchSwipeState(
      gestureswipedstatus: gestureswipedstatus ?? this.gestureswipedstatus,
      posswipe: posswipe ?? this.posswipe,
      widgetswipeoverstatus: widgetswipeoverstatus ?? this.widgetswipeoverstatus,
      initialwidgetstarter: initialwidgetstarter ?? this.initialwidgetstarter,
    );
  }
}
