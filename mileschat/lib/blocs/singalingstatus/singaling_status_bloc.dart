
import 'dart:async';


import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mileschat/blocs/matchcontroller/match_controller_bloc.dart';
import 'package:mileschat/blocs/preservices/pre_service_bloc.dart';
import 'package:mileschat/prc/prc.dart';


part 'singaling_status_event.dart';
part 'singaling_status_state.dart';

class SingalingStatusBloc extends Bloc<SingalingStatusEvent, SingalingStatusState> {
  final PreServiceBloc preservicebloc;
  late  final StreamSubscription preservicesteam;
  SingalingStatusBloc({required this.preservicebloc}) : super(SingalingStatusStateinitial()) {
  
    preservicesteam = preservicebloc.stream.listen((PreServiceState prestate){
      switch (prestate.prestatus) {
        case PreStatus.failpre:PrcClass.closePrcConnection();PrcClass.setOfferStatus(false);preservicebloc.add(const PreMatchEvent(matchstatus: MatchStatus.failneworkconnection, singalingdata: []));break;
        case PreStatus.initial:
        break;
        case PreStatus.createoffer: 

        PrcClass.createOffer(preservicebloc);break;
        case PreStatus.restart:

        PrcClass.setOfferStatus(false);PrcClass.restartPrcIce();preservicebloc.add(const PreMatchEvent(matchstatus: MatchStatus.rematch,singalingdata: []));break;

        case PreStatus.createanswer: 

        PrcClass.createAnswer(preservicebloc);break;

        case PreStatus.addremotedescription:

        PrcClass.setRemoteDescription(prestate, preservicebloc); break;
        case PreStatus.addCandiate:
        PrcClass.setCandiate(prestate);
        break;
        case PreStatus.nextmatch:
          
        case PreStatus.sucessfullyconnection:
      
        PrcClass.setOfferStatus(false);preservicebloc.add(const PreMatchEvent(matchstatus: MatchStatus.sucessfullyconnectmatch,singalingdata: []));break;
        case PreStatus.leavechat:PrcClass.setOfferStatus(false);preservicebloc.add(const PreMatchEvent(matchstatus: MatchStatus.leavechat, singalingdata: []));break; 
      }
      

    });
      
  
  }
   @override
  Future<void> close() {
    preservicesteam.cancel();
    preservicebloc.close();
    return super.close();
  }

}
