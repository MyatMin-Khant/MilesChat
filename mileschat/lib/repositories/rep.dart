

import 'package:mileschat/exception/Exception.dart';
import 'package:mileschat/models/usermodel.dart';
import 'package:mileschat/services/authapi.dart';
import 'package:mileschat/services/getdeviceid.dart';


class  AuthRep {
   Future<UserModel> signUp(String name,String gender,DateTime birthday,String deviceid) async {
    try {
      final UserModel model = await AuthApi().requestSignUp(name,gender,birthday,deviceid);
 
      return model;

    } on HttpExceptionRequest catch(_) {
      rethrow;
    }
     catch (e) {
      print('error here rep $e');  
      throw(HttpExceptionRequest(msg : e.toString()));
     }
   }
   Future<UserModel>  requestAuth(String name,String gender,DateTime birthday) async {
    try {
      final String deviceid = await getDeviceID();
      final resultcheckdeviceid = await AuthApi().requestCheckDeviceId(deviceid);
      if (resultcheckdeviceid['status'] == 1) {

        return UserModel(id: resultcheckdeviceid['id'],name: resultcheckdeviceid['name'],token: '',signupcon: false,paidtimes: resultcheckdeviceid['paidtimes']);
      }
      else if (resultcheckdeviceid['status'] == 2) {
          final UserModel model = await signUp(name, gender, birthday, deviceid);
          return model.copyWith(id: model.id,token: model.token,signupcon: model.signupcon,name: model.name);
      }
      else {
          throw(const HttpExceptionRequest(msg : 'Something is Wrong'));
      }
    }on HttpExceptionRequest catch(_) {
      rethrow;

   } catch (e) {
    print('Error rep is ${e}');
    throw(HttpExceptionRequest(msg : e.toString()));
   }

   }}