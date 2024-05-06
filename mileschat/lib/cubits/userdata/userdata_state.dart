// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'userdata_cubit.dart';

class UserDataState extends Equatable {
  final int camerapermissionstatus;
  final int micpermissionstatus;
  final String id;
  final String name;
  final String token;
  final int  paymentstatus;
  final int bonusmatch;
  final int networkcon;
  final int  loadingcon;
  final int firsttimespay;
  final String transcationstatus;


  const UserDataState({
    required this.camerapermissionstatus,
    required this.micpermissionstatus,
    required this.id,
    required this.name,
    required this.token,
    required this.paymentstatus,
    required this.bonusmatch,
    this.networkcon = -1,
    this.loadingcon = -1,
    this.firsttimespay = 0,
    required this.transcationstatus,
  });
  factory UserDataState.initial() => const UserDataState(id: '',token: '',paymentstatus: 0,bonusmatch: 10,name: '',firsttimespay: 0,transcationstatus: "initial",camerapermissionstatus: 0,micpermissionstatus: 0);
  

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      camerapermissionstatus,
      micpermissionstatus,
      id,
      name,
      token,
      paymentstatus,
      bonusmatch,
      networkcon,
      loadingcon,
      firsttimespay,
      transcationstatus,
    ];
  }

  UserDataState copyWith({
    int? camerapermissionstatus,
    int? micpermissionstatus,
    String? id,
    String? name,
    String? token,
    int? paymentstatus,
    int? bonusmatch,
    int? networkcon,
    int? loadingcon,
    int? firsttimespay,
    String? transcationstatus,
  }) {
    return UserDataState(
      camerapermissionstatus: camerapermissionstatus ?? this.camerapermissionstatus,
      micpermissionstatus: micpermissionstatus ?? this.micpermissionstatus,
      id: id ?? this.id,
      name: name ?? this.name,
      token: token ?? this.token,
      paymentstatus: paymentstatus ?? this.paymentstatus,
      bonusmatch: bonusmatch ?? this.bonusmatch,
      networkcon: networkcon ?? this.networkcon,
      loadingcon: loadingcon ?? this.loadingcon,
      firsttimespay: firsttimespay ?? this.firsttimespay,
      transcationstatus: transcationstatus ?? this.transcationstatus,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'camerapermissionstatus': camerapermissionstatus,
      'micpermissionstatus': micpermissionstatus,
      'id': id,
      'name': name,
      'token': token,
      'paymentstatus': paymentstatus,
      'bonusmatch': bonusmatch,
      'networkcon': networkcon,
      'loadingcon': loadingcon,
      'firsttimespay': firsttimespay,
      'transcationstatus': transcationstatus,
    };
  }

  factory UserDataState.fromMap(Map<String, dynamic> map) {
    return UserDataState(
      camerapermissionstatus: map['camerapermissionstatus'] as int,
      micpermissionstatus: map['micpermissionstatus'] as int,
      id: map['id'] as String,
      name: map['name'] as String,
      token: map['token'] as String,
      paymentstatus: map['paymentstatus'] as int,
      bonusmatch: map['bonusmatch'] as int,
      networkcon: map['networkcon'] as int,
      loadingcon: map['loadingcon'] as int,
      firsttimespay: map['firsttimespay'] as int,
      transcationstatus: map['transcationstatus'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDataState.fromJson(String source) => UserDataState.fromMap(json.decode(source) as Map<String, dynamic>);
}
