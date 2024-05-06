
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mileschat/cubits/userdata/userdata_cubit.dart';
import 'package:mileschat/exception/Exception.dart';
import 'package:mileschat/models/usermodel.dart';
import 'package:mileschat/repositories/rep.dart';

part 'authservice_state.dart';

class AuthServiceCubit extends Cubit<AuthServiceState> {
  final AuthRep authrep;
  final UserDataCubit userdatacub;
  AuthServiceCubit({required this.authrep,required this.userdatacub}) : super(AuthServiceState.initial());

  Future signUpService(String name,String gender,DateTime birthday) async {

    emit(state.copyWith(servicestatus: AuthServiceStatus.loading));
    
    try {
      final UserModel usermodel = await authrep.requestAuth(name, gender,birthday);
        emit(state.copyWith(servicestatus: AuthServiceStatus.sucessfullysubmit,httpexceptmsg: const HttpExceptionRequest(msg: '')));

        userdatacub.updateUserData(usermodel.id, usermodel.token,usermodel.name);
        usermodel.paidtimes == 0 ? userdatacub.updateFirstTimesPayment(1) : userdatacub.updateFirstTimesPayment(usermodel.paidtimes); 
        if (usermodel.signupcon == true) {
            userdatacub.updateBonusStatus(0);
        
        }
        else {
          print('Working in authcubit ${usermodel.signupcon}');
          userdatacub.updatePaymentStatus();userdatacub.updateBonusStatus(10);}
    } on HttpException catch(e) {
      emit(state.copyWith(servicestatus: AuthServiceStatus.error,httpexceptmsg: HttpExceptionRequest(msg: e.message)));
    }
    catch(e) {
      print("Error in cubit is $e");
      emit(state.copyWith(servicestatus: AuthServiceStatus.error,httpexceptmsg: HttpExceptionRequest(msg: e.toString())));}


  }
  updateAuthStatus(AuthServiceStatus status) async => emit(state.copyWith(servicestatus: status));



  
}
