
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mileschat/blocs/matchcontroller/match_controller_bloc.dart';
import 'package:mileschat/cubits/clientids/clientids_cubit.dart';
import 'package:mileschat/cubits/matchswipe/match_swip_cubit.dart';

import 'package:mileschat/cubits/socketconnector/socket_connector_cubit.dart';
import 'package:mileschat/cubits/userdata/userdata_cubit.dart';
import 'package:mileschat/prc/prc.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../cubits/remoteclientstatus/remote_client_status_cubit.dart';




part 'pre_service_event.dart';
part 'pre_service_state.dart';

class PreServiceBloc extends Bloc<PreServiceEvent, PreServiceState> {

  final MatchControllerBloc matchbloc;
  final SocketConnectorCubit socketiocub;
  final ClientidsCubit clientidscub;
  final RemoteClientStatusCubit clientstatuscubit;
  final UserDataCubit userdatacubit;
  final MatchSwipCubit matchswipecubit;
  late final StreamSubscription matchstatusstream;

  static Timer? timer;

  PreServiceBloc({
    required this.userdatacubit,
    required this.clientstatuscubit,
    required this.clientidscub,
    required this.socketiocub,
    required this.matchbloc,
    required this.matchswipecubit
   
    }) : super(PreServiceState.initial()) {
    on<PreStatusEvent>(_updatePreStatus);
    on<PreMatchEvent>(_updateSingalingMatch);
    matchstatusstream = matchbloc.stream.listen((MatchControllerState matchstate) {
     
      switch(matchstate.matchstatus) {
        
        case MatchStatus.initial: break;
        case MatchStatus.joinchatroom:
        

            add(const PreStatusEvent(recevicesingalingdata: [], prestatus: PreStatus.initial));
            userdatacubit.state.token == '' || socketiocub.state.tokensetstatus  ? null :  socketiocub.updateTokenSet(userdatacubit.state.token);
            
            if (socketiocub.state.socketio.disconnected) {
              socketiocub.state.socketio.connect();
              socketiocub.state.socketio.onConnect((_) {
                findClient();

              });
            }
            else {
              findClient();
            }
            break;
        case MatchStatus.rematch:
        clientidscub.clearRoomID();
        clientstatuscubit.updateRemoteClientFoundStatus(false);
        clientstatuscubit.updateClientVideoConnectStatus(false);
        clientstatuscubit.state.clientrenderstatus ? clientstatuscubit.updateClientRenderStatus(false) : null;
        add(const PreMatchEvent(matchstatus: MatchStatus.joinchatroom, singalingdata: []));
        break;
        
        case MatchStatus.offertoremote: 
        _matchConEvent(30);
        print('ofeweewe');
        socketiocub.state.socketio.clearListeners();
        add(const PreStatusEvent(prestatus: PreStatus.createoffer,recevicesingalingdata: [])); break;

        case MatchStatus.sendoffertoremote: 
          print('Start sending/....');
        
            socketiocub.sendPackageToServer(['2',clientidscub.state.remoteclientsid,clientidscub.state.roomid,matchstate.singalingdata,1]);
            
          socketiocub.state.socketio.on('${userdatacubit.state.id} got answer request data',(data) {
       
            
            print('got answer');
            add(PreStatusEvent(prestatus: PreStatus.addremotedescription,recevicesingalingdata: data.cast<int>()));

          });

          

        
        break;
        case MatchStatus.waitoffer:
        _matchConEvent(30);
        socketiocub.state.socketio.on('${userdatacubit.state.id} got offer request data', (data) {
          socketiocub.state.socketio.clearListeners();
          add(PreStatusEvent(prestatus: PreStatus.addremotedescription,recevicesingalingdata: data.cast<int>()));
      });
        break;
        case MatchStatus.answertoremote : 
        
        print('answer to remote');
        add(const PreStatusEvent(prestatus: PreStatus.createanswer,recevicesingalingdata: [])); break;
        case MatchStatus.sendanswertoremote: 
            print('sendanswer');
            socketiocub.sendPackageToServer(['3',clientidscub.state.remoteclientsid,clientidscub.state.roomid,matchstate.singalingdata,1]);
            break;
        case MatchStatus.sendcandiatetooffer:
            print('send candiate to offer'); 
          
            socketiocub.sendPackageToServer(['4',clientidscub.state.remoteclientsid,clientidscub.state.roomid,matchstate.singalingdata,1]);
            
            break;
        case MatchStatus.waitcandiate:
            print('wait candiate');
            socketiocub.state.socketio.on('${userdatacubit.state.id} got candiate', (data) {
              clientstatuscubit.updateRemoteClientFoundStatus(false);
              socketiocub.sendPackageToServer(['-1',clientidscub.state.roomid,1]);
              add(PreStatusEvent(prestatus: PreStatus.addCandiate,recevicesingalingdata: data.cast<int>()));
            });break;
        case MatchStatus.sucessfullyconnectmatch:
            print('sucessully match');
            timer?.cancel();

            socketiocub.state.socketio.clearListeners();
            clientstatuscubit.updateClientVideoConnectStatus(false);
            clientidscub.clearRoomID();
            break;
        case MatchStatus.failneworkconnection:
            closeConnection();
             userdatacubit.updateNetworkConnection(0);
        break;
        case MatchStatus.nextmatch:
              break;
        case MatchStatus.leavechat:
        
          print("${socketiocub.state.socketio.connected} socket connection");
            
          if (socketiocub.state.socketio.connected) {

            socketiocub.sendPackageToServer(['-3',userdatacubit.state.id,clientidscub.state.roomid,'man',1]);
            socketiocub.state.socketio.on('${userdatacubit.state.id} is sucessfully leave',(_) {
              print('sucessfully leave');
              closeConnection();
            }); 
          }
          else { 
            if (userdatacubit.state.paymentstatus == 0) {
        
            matchbloc.add(const ChangeMatchControllerEvent(events: MatchStatus.failneworkconnection, singalingdata: []));}     
            }
            
    break;

        
          
      }
    });

  }
  findClient() {
    _matchConEvent(70);
      
        socketioConStatus();
        
            socketiocub.sendPackageToServer(['1',userdatacubit.state.id,'man',clientidscub.state.remoteclientsid,userdatacubit.state.bonusmatch != 10 ? 1 : 0]);
            socketiocub.state.socketio.on('${userdatacubit.state.id} will offer 1090', (_) => clientstatuscubit.updateRemoteClientFoundStatus(true));
            socketiocub.state.socketio.on('${userdatacubit.state.id} got remoteClient', (id)  {
              timer?.cancel();
              clientstatuscubit.updateClientVideoConnectStatus(true);
              clientstatuscubit.updateClientConnectStatus();
              clientstatuscubit.updateRemoteClientFoundStatus(false);
              PrcClass.setOfferStatus(true);
              fetchRemoteClientInfo(jsonDecode(utf8.decode(GZipCodec().decode(id[1]))),id[0],'roomid${userdatacubit.state.id}'); 
              print('got remote client');
              socketiocub.state.socketio.clearListeners();
              matchbloc.add(const ChangeMatchControllerEvent(events: MatchStatus.offertoremote,singalingdata: []));
              socketiocub.state.socketio.on('${userdatacubit.state.id} Something is wrong',(_)  {
                print('something is wrong for remoteclient ${userdatacubit.state.id}');
                conRestart();
            });

            }); 
      
            socketiocub.state.socketio.on('${userdatacubit.state.id} got offerClient', (data)  {
              timer?.cancel();
              clientstatuscubit.updateClientVideoConnectStatus(true);
              clientstatuscubit.updateClientConnectStatus();
              clientstatuscubit.updateRemoteClientFoundStatus(false);
              fetchRemoteClientInfo(jsonDecode(utf8.decode(GZipCodec().decode(data[2]))),data[0],data[1]); 
              socketiocub.state.socketio.clearListeners();
           
              matchbloc.add(const ChangeMatchControllerEvent(events: MatchStatus.waitoffer,singalingdata: []));
              
            });
            socketiocub.state.socketio.on('${userdatacubit.state.id} Something is wrong',(_)  {
                print('something is wrong ${userdatacubit.state.id}');
                conRestart();
            });
            socketiocub.state.socketio.on('${userdatacubit.state.id} is over subtime', (_){
              timer?.cancel();

              print('Token expire');
              userdatacubit.updatePaymentStatus();
              socketiocub.state.socketio.clearListeners();
              socketiocub.state.socketio.disconnect();
              userdatacubit.state.bonusmatch == 10 ? null : userdatacubit.updateBonusStatus(10);
              userdatacubit.updateToken('');
              matchbloc.add(const ChangeMatchControllerEvent(events: MatchStatus.initial, singalingdata: []));
            });
  }
  fetchRemoteClientInfo(Map<String,dynamic> clientinfo,String id,String roomid) => clientidscub.updateRemoteClientIdAndRoomID(id ,roomid,clientinfo['name']);
         
  closeConnection() {
    timer?.cancel();
    socketiocub.state.socketio.clearListeners();
    socketiocub.state.socketio.disconnect();
    clientstatuscubit.updateRemoteClientFoundStatus(false);
    clientidscub.clearRoomID();

  }
   _matchConEvent(int timerrate) {
    timer = Timer.periodic(const Duration(seconds:  1), (timer) { 
      if (timer.tick == timerrate) {
          conRestart();
         
      }
      else {
      }

    });
 
  }
  socketioConStatus() => socketiocub.state.socketio.onDisconnect((_) {
        if (userdatacubit.state.paymentstatus == 0) {
          if (matchbloc.state.matchstatus != MatchStatus.sucessfullyconnectmatch) {
            print('fail connection in pre bloc');
            failconnection();
      }
        }
     
  });
  conRestart() {
    timer?.cancel();

    print('Work in conrestart');
    
    socketiocub.state.socketio.clearListeners();
    if (state.prestatus == PreStatus.failpre) {
        add(const PreStatusEvent(recevicesingalingdata: [], prestatus: PreStatus.restart));
    }
    else {
       if (socketiocub.state.socketio.connected) {
        print('Connected ');
         matchbloc.state.matchstatus != MatchStatus.joinchatroom && clientidscub.state.roomid != '' ? socketiocub.sendPackageToServer(['-2',clientidscub.state.roomid,userdatacubit.state.id,'man',1]) :
        matchbloc.state.matchstatus == MatchStatus.joinchatroom ?  socketiocub.sendPackageToServer(['-4',userdatacubit.state.id,1]) 
          : null;
      add(const PreStatusEvent(recevicesingalingdata: [], prestatus: PreStatus.restart)); 
    }
    else {
      print('fail connection');
      failconnection();
    }
    }
    
  }
  failconnection() => add(const PreStatusEvent(prestatus: PreStatus.failpre,recevicesingalingdata: []));
  
  _updatePreStatus(PreStatusEvent event,Emitter<PreServiceState> emit) => emit(state.copyWith(prestatus: event.prestatus,recevicesingalingdata: event.recevicesingalingdata));
  _updateSingalingMatch(PreMatchEvent event,Emitter<PreServiceState> emit) => matchbloc.add(ChangeMatchControllerEvent(events: event.matchstatus,singalingdata: event.singalingdata));
  restPaymentMethod() {
      userdatacubit.state.paymentstatus == 1 ? userdatacubit.updatePaymentStatus() : null;
      matchswipecubit.updateWidgetinitalStater(1);
      userdatacubit.state.bonusmatch == 10 ? null : userdatacubit.updateBonusStatus(10);
      userdatacubit.updateFirstTimesPayment(userdatacubit.state.firsttimespay + 1);
  }
  @override
  Future<void> close() {
    timer?.cancel();
    matchstatusstream.cancel();
    clientidscub.close();
    matchbloc.close();
    socketiocub.close();
    socketiocub.state.socketio.clearListeners();
    socketiocub.state.socketio.close();
    return super.close();
  }

}
