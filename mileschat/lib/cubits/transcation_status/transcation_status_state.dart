// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'transcation_status_cubit.dart';

enum TranscationStatus {
  initial,
  initialloseconnection,
  failinitialcallbackconnection,
  pending,
  transcationsucessully,
  transcationfail,
  failconnection,
  

}
class TranscationStatusState extends Equatable {
  final TranscationStatus transcationstatus;
  const TranscationStatusState({
    required this.transcationstatus,
  });

  factory TranscationStatusState.initial() => const TranscationStatusState(transcationstatus: TranscationStatus.initial);
  
  @override
  List<Object?> get props => [transcationstatus];


  @override
  bool get stringify => true;

  TranscationStatusState copyWith({
    TranscationStatus? transcationstatus,
  }) {
    return TranscationStatusState(
      transcationstatus: transcationstatus ?? this.transcationstatus,
    );
  }
}
