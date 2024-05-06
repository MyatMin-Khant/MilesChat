import 'package:equatable/equatable.dart';

class HttpExceptionRequest extends Equatable {
  final String msg;
  const HttpExceptionRequest({
    required this.msg,
  });
 
  @override
  bool get stringify => true;

  @override
  List<Object> get props => [msg];
}
