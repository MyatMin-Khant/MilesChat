import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mileschat/exception/Exception.dart';
import 'package:mileschat/models/usermodel.dart';



class AuthApi {
  Future<UserModel> requestSignUp(String name,String gender,DateTime birthday,String deviceid) async {
    try {

    final response = await http.post(Uri.parse("${dotenv.env["resturl"]}"),
    headers: {
      'Content-Encoding': 'gzip'
    },
    body: GZipCodec().encode(utf8.encode((jsonEncode({
      'name' : name,
      'gender' : gender,
      'deviceid' : deviceid,
      'birthday' : "${birthday.day}-${birthday.month}-${birthday.year}", 
      'requeststatus' : 'signup'
    })))));
  if (response.statusCode != 201) {
    throw(const HttpExceptionRequest(msg: 'Something is  wrong!'));
  }

    
    final UserModel usermodel = UserModel.fromJson(response.body,name,true);

    return usermodel;
  
   

    } on SocketException catch(_) {
       ('Connection Problem');
      throw(const HttpExceptionRequest(msg: 'Connection Problem'));
      
    }
    catch(e) { 
      rethrow;
    } 


  }
  Future<Map<String,dynamic>> requestCheckDeviceId(String deviceid) async {
    try {
   
     
      final response = await http.post(Uri.parse("${dotenv.env["resturl"]}"),
      headers: {'Content-Encoding': 'gzip','Accept-Encoding' : 'gzip'},
      body: GZipCodec().encode(utf8.encode((jsonEncode({
        'requeststatus' : 'checkalreadysignin',
        'deviceid' : deviceid
      }))))
      );
      if (response.statusCode == 201) {
        if (response.headers['content-encoding'] == 'gzip') {
          final jsondata = jsonDecode(utf8.decode(response.bodyBytes));
          return {'status' : 1,'name' : jsondata['clientinfo']['name'],'id' : jsondata['clientinfo']['id'],'paidtimes' : jsondata['clientinfo']['paidtimes']};
          
        }
        else {
 
          return {'status' : 0};
        }
      }
      else if (response.statusCode == 300) {
        return {'status' : 2};
      }
      else {
        
        return {'status' : -1};
      }



    } on SocketException catch(_) {
      throw (const HttpExceptionRequest(msg : 'Connection Problem')); 
    }
    catch(e) {
      rethrow;
    }
  } 
  Future<dynamic> rechackTranscationStatus(String id) async {
    try {
      Map<String, String> parameters = {
    'id': id,
    'requeststatus' : "rechecktranscationstatus",
    };
      final Uri uri = Uri.parse("${dotenv.env["resturl"]}?${_encodeParams(parameters)}");
      final response = await http.get(uri);
      if (response.statusCode == 200) {
          final jsondata = json.decode(response.body);
          return jsondata;
      }
      else {
        return  {'status' : 2};
      }

    } on SocketException catch(_) {
      return {'status' : -1};
    }
    catch (e) {
      return {'status' : 0};
    }
  }
  String _encodeParams(Map<String, String> params) {
  return params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');
}
}