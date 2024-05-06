import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mileschat/cubits/socketconnector/socket_connector_cubit.dart';
import 'package:mileschat/cubits/transcation_status/transcation_status_cubit.dart';
import 'package:mileschat/cubits/userdata/userdata_cubit.dart';
import 'package:mileschat/services/checknetwork.dart'; 
import 'package:socket_io_client/socket_io_client.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PaymentApi  {
  Future<void> connectCallBackTranscationStatus(Socket paymentsocketio,String id,String methodname,String providername,
  String name,String userphonenumber,TranscationStatusCubit transcationcubit,UserDataCubit userdatacubit,
  SocketConnectorCubit socketiocubit) async {

    
    int _checkNetWorkCon = await checkInternetConnection();
    if (_checkNetWorkCon == 1) {

    
    if (paymentsocketio.disconnected) {
      paymentsocketio.connect();
      paymentsocketio.onConnect((_) {
      
        paymentsocketio.emit('transcation_start',[[id,1]]);
        
        paymentsocketio.on('$id updated 2', (_) async {
          transcationcubit.updateTranscationStatus(TranscationStatus.pending);
          final  requestPaymentStatus = await requestPaymentProcessing(methodname, providername, id, name, userphonenumber);
          if (requestPaymentStatus['status'] == 1) {
                //redirecturl.updateredirecturl("${dotenv.env["paymentredirectgateway"]}transactionNo=${requestPaymentStatus["response"]["response"]["transactionNum"]}&formToken=${requestPaymentStatus["response"]["response"]["formToken"]}&merchantOrderId=${requestPaymentStatus["response"]["response"]["merchOrderId"]}");
                //transcationcubit.updateTranscationStatus(TranscationStatus.redirectgatewaystatus);
                redirectPaymentGateway("${dotenv.env["paymentredirectgateway"]}transactionNo=${requestPaymentStatus["response"]["response"]["transactionNum"]}&formToken=${requestPaymentStatus["response"]["response"]["formToken"]}&merchantOrderId=${requestPaymentStatus["response"]["response"]["merchOrderId"]}");

            }
          else if (requestPaymentStatus['status'] == -1) {
            transcationcubit.state.transcationstatus == TranscationStatus.pending ? 
            transcationcubit.updateTranscationStatus(TranscationStatus.failconnection) : transcationcubit.updateTranscationStatus(TranscationStatus.initialloseconnection);
          }
          else if (requestPaymentStatus['status'] == -2) {
            
            transcationcubit.updateTranscationStatus(TranscationStatus.transcationfail);
          }
          
      });
      paymentsocketio.on("$id sucessfully transcation",(token) {
        userdatacubit.updateToken(token[0]);
        socketiocubit.updateTokenSet(token[0]);
        transcationcubit.updateTranscationStatus(TranscationStatus.transcationsucessully);
        paymentsocketio.clearListeners();
        paymentsocketio.close();
      });
      paymentsocketio.on("$id 0", (_) => transcationcubit.updateTranscationStatus(TranscationStatus.transcationfail));

        });
        paymentsocketio.onDisconnect((data) => transcationcubit.state.transcationstatus == TranscationStatus.pending ? 
            transcationcubit.updateTranscationStatus(TranscationStatus.failconnection) : transcationcubit.updateTranscationStatus(TranscationStatus.initialloseconnection));
      }

    }
    else { transcationcubit.updateTranscationStatus(TranscationStatus.failinitialcallbackconnection);}
  }
  

  }
  Future<void> redirectPaymentGateway(String paymenturl) async {
      if (await canLaunchUrl(Uri.parse(paymenturl))) {
          await launchUrl(Uri.parse(paymenturl),mode: LaunchMode.inAppBrowserView);  
     }
     else {
      
     }
  }
  
  Future<dynamic> requestPaymentProcessing(String methodname,String providername,String id,String name,String userphonenumber) async {
    try {
      final response = await http.post(Uri.parse("${dotenv.env["paymenturl"]}"),
      headers: {
      'Content-Encoding': 'gzip'
      },
      body: GZipCodec().encode(utf8.encode((jsonEncode(
        {
          'providername' : providername,
          'methodname' : methodname,
          'id' : id,
          'name' : name,
          'phone' : userphonenumber,
          'requeststatus' : '1'
        }

      ))))
      );
      if (response.statusCode == 200) {
        final responsejsondata = jsonDecode(utf8.decode(response.bodyBytes));
        return {'response' : responsejsondata,'status' : 1};

      }
      if (response.statusCode == 400) {
        return {'status' : 0};
      }
      else {
        
        return {'statuscode' : 0};
      }


    } on SocketException catch(_) {
        return {'status' : -1};
    } catch(e) {
      return {'status' : -2};
    }
  
    
  }
