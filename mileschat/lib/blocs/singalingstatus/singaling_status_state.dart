// ignore_for_file: public_member_api_docs, sort_constructors_first


part of 'singaling_status_bloc.dart';

sealed class SingalingStatusState extends Equatable {
  const SingalingStatusState();
  
  @override
  List<Object> get props => [];
}

final class SingalingStatusStateinitial extends SingalingStatusState {}
