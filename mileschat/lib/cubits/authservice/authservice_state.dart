// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'authservice_cubit.dart';

enum AuthServiceStatus {
  initial,
  error,
  loading,
  sucessfullysubmit
}
class AuthServiceState extends Equatable {
  final AuthServiceStatus servicestatus;
  final HttpExceptionRequest httpexceptmsg;
  const AuthServiceState({
    required this.servicestatus,
    required this.httpexceptmsg,
  });
  factory AuthServiceState.initial() => const AuthServiceState(servicestatus: AuthServiceStatus.initial,httpexceptmsg: HttpExceptionRequest(msg : ''));
  


  @override
  bool get stringify => true;

  @override
  List<Object> get props => [servicestatus, httpexceptmsg];

  AuthServiceState copyWith({
    AuthServiceStatus? servicestatus,
    HttpExceptionRequest? httpexceptmsg,
  }) {
    return AuthServiceState(
      servicestatus: servicestatus ?? this.servicestatus,
      httpexceptmsg: httpexceptmsg ?? this.httpexceptmsg,
    );
  }
}
