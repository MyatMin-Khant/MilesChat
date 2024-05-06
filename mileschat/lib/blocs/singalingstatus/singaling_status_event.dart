// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'singaling_status_bloc.dart';

sealed class SingalingStatusEvent extends Equatable {
  const SingalingStatusEvent();

  @override
  List<Object> get props => [];
}

class SdpEvent extends SingalingStatusEvent {}
