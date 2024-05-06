// ignore_for_file: public_member_api_docs, sort_constructors_first


part of 'camera_status_cubit.dart';

class CameraStatusState extends Equatable {
  final bool iconcamerastatus;
  final bool rendercamerastatus; 
  const CameraStatusState({
    required this.iconcamerastatus,
    required this.rendercamerastatus,
  });
  factory CameraStatusState.initial() => const CameraStatusState(iconcamerastatus: true, rendercamerastatus: true);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [iconcamerastatus, rendercamerastatus];

  CameraStatusState copyWith({
    bool? iconcamerastatus,
    bool? rendercamerastatus,
  }) {
    return CameraStatusState(
      iconcamerastatus: iconcamerastatus ?? this.iconcamerastatus,
      rendercamerastatus: rendercamerastatus ?? this.rendercamerastatus,
    );
  }
}
