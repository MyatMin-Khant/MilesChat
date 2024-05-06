import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:mileschat/blocs/matchcontroller/match_controller_bloc.dart';
import 'package:mileschat/blocs/preservices/pre_service_bloc.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:msgpack_dart/msgpack_dart.dart' as msg;

class PrcClass {
  static RTCPeerConnection? prc;
  static bool  offerstatus = false; 
  static updatePRC(RTCPeerConnection p) => prc = p;

  static createOffer(PreServiceBloc preservicebloc) async {
    try {
      RTCSessionDescription description =
          await prc!.createOffer({'offerToReceiveVideo': 1});
    prc!.setLocalDescription(description);
    setOfferStatus(true);
     

  
    preservicebloc.add(PreMatchEvent(matchstatus: MatchStatus.sendoffertoremote,
    singalingdata:  msg.serialize(json.encode(parse(description.sdp.toString()))).toList()));
    

    } catch (_) {}
   
       

 
   
  }
  static createAnswer(PreServiceBloc preservicebloc) async {
    try {
      RTCSessionDescription description = await prc!.createAnswer({'offerToReceiveVideo': 1});
     prc!.setLocalDescription(description);
    preservicebloc.add(PreMatchEvent(matchstatus: MatchStatus.sendanswertoremote,singalingdata: msg.serialize(json.encode(parse(description.sdp.toString()))).toList()));
    } catch(_) {}
    


  }
  static setRemoteDescription(PreServiceState state,PreServiceBloc preservicebloc) async {
        try {
          RTCSessionDescription description = 
          RTCSessionDescription(write(jsonDecode(msg.deserialize(Uint8List.fromList(state.recevicesingalingdata))),null),getOfferStatus() ? 'answer' : 'offer');

          prc!.setRemoteDescription(description);
     
      
          getOfferStatus() ?  preservicebloc.add(const PreMatchEvent(matchstatus: MatchStatus.waitcandiate,singalingdata: [])) : 
          preservicebloc.add(const PreMatchEvent(matchstatus: MatchStatus.answertoremote,singalingdata: []));

        } catch(_) {
        }
        

        
        
    }
  static setCandiate(PreServiceState state) async {
    try {
      dynamic sessions = jsonDecode(msg.deserialize(Uint8List.fromList(state.recevicesingalingdata)));
      dynamic candiate =  RTCIceCandidate(
          sessions["candiate"], sessions["sdpMid"], sessions["sdpMidIndex"]);
      prc!.addCandidate(candiate);

    } catch (_) {}
      
         
    }
    
    static getOfferStatus() => offerstatus;
    static setOfferStatus (bool value) => offerstatus = value;  
    static getPrc() => prc;


    static closePrcConnection() async =>  await prc?.close();
    static restartPrcIce() async => await prc?.restartIce();

    
    static disposePrcConnection() async =>  await prc?.dispose();
}