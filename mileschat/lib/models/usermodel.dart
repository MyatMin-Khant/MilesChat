// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String token;
  final String name;
  final bool signupcon;
  final int paidtimes;

  const UserModel({
    required this.id,
    required this.token,
    required this.name,
    required this.signupcon,
    required this.paidtimes

  });
  


  @override
  List<Object> get props {
    return [
      id,
      token,
      name,
      signupcon,
      paidtimes,
    ];
  }

  @override
  bool get stringify => true;

  UserModel copyWith({
    String? id,
    String? token,
    String? name,
    bool? signupcon,
    int? paidtimes,
  }) {
    return UserModel(
      id: id ?? this.id,
      token: token ?? this.token,
      name: name ?? this.name,
      signupcon: signupcon ?? this.signupcon,
      paidtimes: paidtimes ?? this.paidtimes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'paidtimes' : paidtimes,
      'token': token,
      'name': name,
      'signupcon' : signupcon
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map,String username,bool signupcon) {
    return UserModel(
      paidtimes: 0,
      signupcon:  signupcon,
      id: map['id'] as String,
      token: map['token'] as String,
      name: username,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source,String username,bool signupcon) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>,username,signupcon);
  
}
