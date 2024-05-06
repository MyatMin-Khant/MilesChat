import 'dart:convert';

//import 'dart:html';
import 'package:awesome_ripple_animation/awesome_ripple_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mileschat/blocs/matchcontroller/match_controller_bloc.dart';
import 'package:mileschat/blocs/preservices/pre_service_bloc.dart';
import 'package:mileschat/cubits/matchswipe/match_swip_cubit.dart';
import 'package:mileschat/cubits/remoteclientstatus/remote_client_status_cubit.dart';
import 'package:mileschat/cubits/socketconnector/socket_connector_cubit.dart';
import 'package:mileschat/cubits/userdata/userdata_cubit.dart';
import 'package:mileschat/pages/paymentoptionpage.dart';
import 'package:mileschat/prc/prc.dart';
import 'package:mileschat/constraints/constraints.dart';
import 'package:mileschat/services/authapi.dart';
import 'package:mileschat/services/checknetwork.dart';
import 'package:mileschat/widgets/custompageroute.dart';
import 'package:mileschat/widgets/dialogswidget.dart';
import 'package:msgpack_dart/msgpack_dart.dart' as msg;
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final _localVideoRender = RTCVideoRenderer();
  final _remoteVideoRender = RTCVideoRenderer();
  bool _cameramirrorstatus = true;
  bool _shimstatus = true;
  MediaStream? _localMediaStream;

  int widgetkeyval = 0;
  late AnimationController _movecontroller;
  late AnimationController _rotatecontroller;
  late Animation<double> _animation;
  late AnimationController _floatingbtncontroller;
  late Animation<double> _floatinganimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _floatingbtncontroller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _floatinganimation = Tween<double>(begin: -10.0, end: -7.0).animate(                                   
      CurvedAnimation(
        parent: _floatingbtncontroller,
        curve: Curves.easeInOut,
      ));

    _movecontroller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _rotatecontroller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _animation =
        CurvedAnimation(parent: _rotatecontroller, curve: Curves.easeInOut);
    
    _initizeVideoRender();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _createPreConnection().then((createdpre) {
        PrcClass.updatePRC(createdpre);

        _shimstatus ? setState(() => _shimstatus = false) : null;
      });
    });
    _movecontroller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextFrameSwipe();
      }
    });
    _floatingbtncontroller.repeat(reverse: true);
   
    
    _checkTranscationStatus();

  }
  _checkTranscationStatus() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    if (context.read<UserDataCubit>().state.transcationstatus == "failconnection" ||
      context.read<UserDataCubit>().state.transcationstatus == "pending") {
        final requestCheckTranscationStatus = await AuthApi().rechackTranscationStatus(context.read<UserDataCubit>().state.id);
        if (requestCheckTranscationStatus['status'] == 1) {
          if (!mounted) return;
          context.read<UserDataCubit>().updateToken(requestCheckTranscationStatus["token"]);
          context.read<SocketConnectorCubit>().updateTokenSet(requestCheckTranscationStatus["token"]);
          context.read<PreServiceBloc>().restPaymentMethod();
          context.read<UserDataCubit>().updateTranscationStatus("initial");
     
        }
        if (requestCheckTranscationStatus['status'] == -1) {
            if (!mounted) return;
            messageDialog(context,'အင်တာနက်လှိုင်း ပြဿနာရှိနေသည်။ပြန်ထွက်ပြီးပြန်ဝင်ပေးပါ။','အိုကေ',-1);

        }
        else {
          if (!mounted) return;
            context.read<UserDataCubit>().updateTranscationStatus("initial");
            
            

        }
      }
      else {
      
      }
  }

  _initizeVideoRender() async {
    await _localVideoRender.initialize();
    await _remoteVideoRender.initialize();
  }

  Future<MediaStream> _enableUserMedia() async {
    final Map<String, dynamic> mediaconstraints = {
      //width : MediaQuery.of(context).size.width.toInt()
      //height : MediaQuery.of(context).size.height  ~/ 2) - MediaQuery.of(context).size.height  ~/ 13
      'audio': true,
      'video': {
        "mandatory": {
          "width": MediaQuery.of(context).size.width.toInt(),
          "height": (MediaQuery.of(context).size.height ~/ 2) -
              MediaQuery.of(context).size.height ~/ 13
        },
        "facingMode": _cameramirrorstatus ? "user" : "environment",
        "optional": [],
      }
    };
    MediaStream stream =
        await navigator.mediaDevices.getUserMedia(mediaconstraints);
    _localVideoRender.srcObject = stream;
    return stream;
  }

  _createPreConnection() async {
    if (context.read<MatchSwipCubit>().state.posswipe == 0) {
      _localMediaStream = await _enableUserMedia();
    }

    RTCPeerConnection pre =
        await createPeerConnection(stunserverhost, offersdpConstraints);

    _localMediaStream?.getTracks().forEach((track) {
      pre.addTrack(track, _localMediaStream!);
    });

    pre.onIceCandidate = (e) {
      if (PrcClass.getOfferStatus() == false &&
          context.read<PreServiceBloc>().state.prestatus ==
              PreStatus.createanswer &&
          context.read<MatchControllerBloc>().state.matchstatus !=
              MatchStatus.sendcandiatetooffer) {
        context.read<PreServiceBloc>().add(PreMatchEvent(
            matchstatus: MatchStatus.sendcandiatetooffer,
            singalingdata: msg
                .serialize(json.encode({
                  "candiate": e.candidate.toString(),
                  "sdpMid": e.sdpMid.toString(),
                  "sdpMlineIndex": e.sdpMLineIndex
                }))
                .toList()));
      }
    };
    pre.onIceConnectionState = (state) {
      if (state == RTCIceConnectionState.RTCIceConnectionStateConnected) {
        context.read<PreServiceBloc>().add(const PreStatusEvent(
            recevicesingalingdata: [],
            prestatus: PreStatus.sucessfullyconnection));
      }

      if (state == RTCIceConnectionState.RTCIceConnectionStateDisconnected) {
        print('dc in pre');
        if (context.read<SocketConnectorCubit>().state.socketio.connected !=
            true) {
          print('fail connection');
          context.read<RemoteClientStatusCubit>().state.clientvideoconnectstatus
              ? context
                  .read<RemoteClientStatusCubit>()
                  .updateClientVideoConnectStatus(false)
              : null;
          context.read<RemoteClientStatusCubit>().state.clientconnectstatus
              ? context
                  .read<RemoteClientStatusCubit>()
                  .updateClientConnectStatus()
              : null;
          _resetPrcAndClose('close');
          context.read<PreServiceBloc>().failconnection();
          context.read<UserDataCubit>().updateNetworkConnection(0);
        } else {
          context.read<RemoteClientStatusCubit>().state.clientvideoconnectstatus
              ? context
                  .read<RemoteClientStatusCubit>()
                  .updateClientVideoConnectStatus(false)
              : null;
          context.read<RemoteClientStatusCubit>().state.clientconnectstatus
              ? context
                  .read<RemoteClientStatusCubit>()
                  .updateClientConnectStatus()
              : null;
          context
              .read<RemoteClientStatusCubit>()
              .updateClientRenderStatus(false);
          _resetPrcAndClose('dc');
        }
      }
      if (state == RTCIceConnectionState.RTCIceConnectionStateFailed) {
        print('fail connection in ice');
      }
    };

    pre.onAddStream = (stream) {
      _remoteVideoRender.srcObject = stream;
      context.read<RemoteClientStatusCubit>().updateClientRenderStatus(true);
      context.read<UserDataCubit>().state.bonusmatch == 10
          ? null
          : context.read<UserDataCubit>().state.bonusmatch == 5
              ? updateBonuseEnd()
              : context.read<UserDataCubit>().updateBonusStatus(
                  context.read<UserDataCubit>().state.bonusmatch + 1);
    };

    return pre;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: context.read<UserDataCubit>().state.transcationstatus == "failconnection" || context.read<UserDataCubit>().state.transcationstatus == "pending" 
         ? 
        Container(
          color: Colors.black,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: const Center(
            child: Center(
              child: CircularProgressIndicator(color: Colors.red),
            ),
          ),
        ) : 
        Scaffold(
            backgroundColor: Colors.black,
            appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height / 13),
              child: AppBar(
                backgroundColor: Colors.black,
                automaticallyImplyLeading: false,
                title: Row(
                  children: [
                    Image.asset(
                        MediaQuery.of(context).size.height > 1000
                            ? 'assets/img/logo_large.png'
                            : 'assets/img/logo1.png',
                        width: MediaQuery.of(context).size.width / 13,
                        height: MediaQuery.of(context).size.height / 13),
                    const Spacer(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height / 13,
                      child: Row(
                        children: [
                          const Spacer(),
                          Builder(builder: (BuildContext bcontext) {
                            return _shimstatus
                                ? Shimmer.fromColors(
                                    baseColor:
                                        const Color.fromARGB(255, 92, 92, 92),
                                    highlightColor: const Color.fromARGB(
                                        255, 138, 138, 138),
                                    enabled: true,
                                    child: CircleAvatar(
                                      backgroundColor:
                                          const Color.fromARGB(255, 32, 32, 32),
                                      radius:
                                          MediaQuery.of(bcontext).size.width /
                                              25,
                                    ))
                                : Icon(Icons.account_circle_outlined,size: MediaQuery.of(bcontext).size.width / 15,color: Colors.white)
                                /*CircleAvatar(
                                    backgroundColor:
                                        const Color.fromARGB(255, 32, 32, 32),
                                    radius:
                                        MediaQuery.of(bcontext).size.width / 25,
                                    backgroundImage: const AssetImage(
                                        'assets/img/profile_rep_bg_change.png')) */;
                          }),
                          SizedBox(
                              width:
                                  MediaQuery.of(context).size.width / 2 / 20),
                          _shimstatus
                              ? Shimmer.fromColors(
                                  baseColor:
                                      const Color.fromARGB(255, 92, 92, 92),
                                  highlightColor:
                                      const Color.fromARGB(255, 138, 138, 138),
                                  enabled: true,
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 20,
                                    height:
                                        (MediaQuery.of(context).size.height /
                                                13) /
                                            3,
                                  ),
                                )
                              : Text(context.read<UserDataCubit>().state.name,
                                  style: GoogleFonts.raleway(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              26,
                                      fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: BlocListener<MatchControllerBloc, MatchControllerState>(
              listener: (context, state) {
                 if (state.matchstatus == MatchStatus.failneworkconnection) {
                    messageDialog(context,'အင်တာနက်လှိုင်း (သို့မဟုတ်) တစ်ခုခုပြဿနာရှိနေသည်။','ပြန်လည်ကြိုးစားပေးပါ။',0);

                 }
              },
              child: Center(
                  child: Column(
                children: [
                  Builder(builder: (BuildContext bcontext3) {
                    return bcontext3
                                .watch<RemoteClientStatusCubit>()
                                .state
                                .clientvideoconnectstatus &&
                            bcontext3
                                    .watch<MatchControllerBloc>()
                                    .state
                                    .matchstatus !=
                                MatchStatus.sucessfullyconnectmatch
                        ? bcontext3.watch<UserDataCubit>().state.networkcon == 0 ? 
                        _internetConnectionMessageContent(bcontext3) : 
                        Container(
                            width: MediaQuery.of(bcontext3).size.width,
                            height: (MediaQuery.of(bcontext3).size.height / 2 -
                                    MediaQuery.of(bcontext3).size.height / 13) +
                                MediaQuery.of(bcontext3).size.height / 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: const Color.fromARGB(255, 70, 70, 70),
                              ),
                            
                            child: 
                             Stack(
                                children: [
                                  AnimatedBuilder(
                                    animation: _movecontroller,
                                    builder: (BuildContext b12context, child) {
                                      return AnimatedPositioned(
                                          top: 0,
                                          left: b12context
                                                      .watch<MatchSwipCubit>()
                                                      .state
                                                      .posswipe ==
                                                  2
                                              ? MediaQuery.of(b12context)
                                                      .size
                                                      .width +
                                                  MediaQuery.of(b12context)
                                                      .size
                                                      .width
                                              : b12context
                                                          .watch<MatchSwipCubit>()
                                                          .state
                                                          .posswipe ==
                                                      1
                                                  ? -MediaQuery.of(b12context)
                                                      .size
                                                      .width
                                                  : 0,
                                          bottom: 0,
                                          duration:
                                              const Duration(milliseconds: 250),
                                          child: Shimmer.fromColors(
                                            baseColor: const Color.fromARGB(
                                                255, 92, 92, 92),
                                            highlightColor: const Color.fromARGB(
                                                255, 138, 138, 138),
                                            enabled: true,
                                            child: Container(
                                                  width: MediaQuery.of(b12context)
                                                      .size
                                                      .width,
                                                  height: (MediaQuery.of(
                                                                      b12context)
                                                                  .size
                                                                  .height /
                                                              2 -
                                                          MediaQuery.of(
                                                                      b12context)
                                                                  .size
                                                                  .height /
                                                              13) +
                                                      MediaQuery.of(b12context)
                                                              .size
                                                              .height /
                                                          30,
                                                  
                                                  decoration:  BoxDecoration(
                                                    color: const Color.fromARGB(
                                                      255, 70, 70, 70),
                                                      borderRadius: BorderRadius.circular(15.0)
                                                  ),),
                                            
                                          ));
                                    },
                                  ),
                                ],
                              ),
                            )
                          
                        : Padding(
                          padding: const EdgeInsets.only(left: 5.0,right: 5.0,bottom: 5.0),
                          child:  Container(
                           
                                width: MediaQuery.of(context).size.width,
                                height: (MediaQuery.of(context).size.height / 2 -
                                        MediaQuery.of(context).size.height / 13) +
                                    MediaQuery.of(context).size.height / 10,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: const Color.fromARGB(255, 70, 70, 70)
                                ),
                                
                               
                                child: 
                                Stack(children: [
                                    Builder(builder: (BuildContext bgcontext){
                                
                                      return bgcontext.watch<MatchSwipCubit>().state.initialwidgetstarter == 1 ? 
                                      _showBgCover(bgcontext) : const Text('');
                                    })
                                    ,
                                    Builder(builder: (BuildContext bcontextx) {
                                      return bcontextx
                                                  .watch<MatchSwipCubit>()
                                                  .state
                                                  .widgetswipeoverstatus ==
                                              0
                                          ? AnimatedBuilder(
                                              animation: _movecontroller,
                                              builder: (bcontextx, child) {
                                                return AnimatedPositioned(
                                                  top: 0,
                                                  right: 0,
                                                  left: bcontextx
                                                              .watch<MatchSwipCubit>()
                                                              .state
                                                              .posswipe ==
                                                          2
                                                      ? MediaQuery.of(bcontextx)
                                                              .size
                                                              .width +
                                                          MediaQuery.of(bcontextx)
                                                              .size
                                                              .width
                                                      : bcontextx
                                                                  .watch<
                                                                      MatchSwipCubit>()
                                                                  .state
                                                                  .posswipe ==
                                                              1
                                                          ? -MediaQuery.of(bcontextx)
                                                              .size
                                                              .width
                                                          : 0,
                                                  bottom: 0,
                                                  duration: const Duration(
                                                      milliseconds: 250),
                                                  child: /* GestureDetector(
စစ်ထုတ်မှုနှင့် အကြောင်းအရာများ
အားလုံး
ဗီဒီယို
ပုံ
ဈေးဝယ်ရန်
စာအုပ်
နောက်ထပ်
ကိရိယာများ
Review
App Academy Open vs
FreeCodeCamp vs
GitHub
How hard is the
JavaScript
Login
Notion
Vs Full Stack Open
SafeSearch
ရလဒ်များ ရှာပါ
ဝဘ်ဆိုက်လင့်ခ်များနှင့် ဝဘ်ရလဒ်များ

                                                          0) {
                                                        _frameSwipeStarter(1);
                                                      }
                                                    },
                                                    child: */RotationTransition(
                                                      turns:
                                                          Tween(begin: 0.0, end: 0.3)
                                                              .animate(_animation),
                                                      child: SizedBox(
                                                        //color: const Color.fromARGB(
                                                            //255, 27, 27, 27),
                                                        width : MediaQuery.of(bcontextx).size.width,
                                                        height:
                                                            MediaQuery.of(bcontextx)
                                                                    .size
                                                                    .height /
                                                                2,
                                                        
                                                        child: Builder(builder:
                                                            (BuildContext
                                                                b1xcontext) {
                                                          return b1xcontext.watch<MatchSwipCubit>().state.initialwidgetstarter == 1 ? 
                                                          const Text('') : 
                                                          /*Image.asset('assets/img/oldman.jpeg',fit: BoxFit.fill,)  */
                                                              b1xcontext
                                                                              .watch<
                                                                                  UserDataCubit>()
                                                                              .state
                                                                              .paymentstatus ==
                                                                          1 
                                                                    
                                                                           || 
                                                                      b1xcontext
                                                                              .watch<
                                                                                  UserDataCubit>()
                                                                              .state
                                                                              .token ==
                                                                          ''
                                                                  ? paidContentWidget(b1xcontext)
                                                                  : b1xcontext
                                                                              .watch<
                                                                                  UserDataCubit>()
                                                                              .state
                                                                              .networkcon ==
                                                                          0
                                                                      ?  _internetConnectionMessageContent(b1xcontext)
                                                                      : b1xcontext
                                                                                  .watch<RemoteClientStatusCubit>()
                                                                                  .state
                                                                                  .clientrenderstatus ==
                                                                              true
                                                                          ? SizedBox(
                                                                              width:
                                                                                  1600,
                                                                              height:
                                                                                  1080,
                                                                              child: RTCVideoView(
                                                                                  _remoteVideoRender,
                                                                                  objectFit:
                                                                                      RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
                                                                            )
                                                                              :   SizedBox(
                                                                                      child: Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: [
                                                                                          Icon(Icons.person,color: const Color.fromARGB(255, 228, 228, 228),size: MediaQuery.of(b1xcontext).size.width / 10),
                                                                                          SizedBox(height: MediaQuery.of(b1xcontext).size.height / 80),
                                                                                          SpinKitCircle(
                                                                                            color: const Color.fromARGB(255, 228, 228, 228),
                                                                                            size: MediaQuery.of(b1xcontext).size.width / 15,
                                                                                          ),
                                                                                          SizedBox(height: MediaQuery.of(b1xcontext).size.height / 80),
                                                                                          Text('လူရှာနေသည်။',style: GoogleFonts.roboto(color: const Color.fromARGB(255, 228, 228, 228), 
                                                                                          fontSize: MediaQuery.of(b1xcontext).size.width / 35))
                                                                                    
                                                                                        ],
                                                                                      )); 
                                                                               
                                                        }),
                                                      ),
                                                    ),
                                                  
                                                );
                                              })
                                          : Container();
                                          
                                       
                                      
                                    }),
                                    
                                   
                                
                                    // Positioned(
                                    //   left: 0,
                                    //   child: Builder(
                                    //     builder: (BuildContext fadecontext) {
                                    //       return fadecontext.watch<UserDataCubit>().state.paymentstatus != 1 ? 
                                    //       Container(
                                    //         width: MediaQuery.of(context).size.width,
                                    //         height: (MediaQuery.of(context).size.height / 2 -
                                    //         MediaQuery.of(context).size.height / 13) +
                                    //         MediaQuery.of(context).size.height / 10,
                                    //         decoration:  BoxDecoration(
                                    //           borderRadius: BorderRadius.circular(15.0),
                                    //           gradient: LinearGradient(
                                    //           begin: Alignment.topLeft, end: Alignment.bottomLeft,
                                    //           colors: [Colors.transparent, const Color(0xffFF6347).withOpacity(0.6)],
                                    //           stops: const [.57, .9]
                                    //         )
                                    //       ),
                                    //       ) : const Text('');
                                    //     }
                                    //   ),
                                    // ), 
                                    Positioned(
                                      top: 0,
                                      
                                        child: GestureDetector(
                                          behavior:
                                                      HitTestBehavior.translucent,
                                                      onPanUpdate: (details) {
                                                        if (details.delta.dx > 0) {
                                                          _frameSwipeStarter(2);
                                                        } else if (details.delta.dx <
                                                            0) {
                                                          _frameSwipeStarter(1);
                                                        }
                                                      },
                                            child: SizedBox(
                                        width: MediaQuery.of(context).size.width,
                                        height: (MediaQuery.of(context).size.height / 2 -
                                            MediaQuery.of(context).size.height / 13) +
                                            MediaQuery.of(context).size.height / 10,
                                        ),
                                      ),
                                    ),
                                    
                                    Positioned(
                                      left: MediaQuery.of(context).size.width / 2.7,
                                      bottom:
                                          (MediaQuery.of(context).size.height / 2) /
                                              30,
                                      child: Builder(
                                          builder: (BuildContext colorcontext) {
                                        return colorcontext.watch<UserDataCubit>().state.paymentstatus == 1 
                                        || colorcontext.watch<MatchSwipCubit>().state.initialwidgetstarter == 1 ? 
                                        const Text('') :  
                                        SizedBox(
                                          width:
                                              MediaQuery.of(colorcontext).size.width /
                                                  9,
                                          height: MediaQuery.of(colorcontext)
                                                  .size
                                                  .width /
                                              9,
                                          child: ClipOval(
                                              child:  Material(
                                                color:  Colors.white,
                                                child: InkWell(
                                                  splashColor: const Color.fromARGB(255, 255, 107, 70).withOpacity(0.5),
                                                  onTap: ()=> _frameSwipeStarter(2),
                                                  child: Center(
                                                    child: 
                                                      Icon(Icons.close,color: colorcontext.watch<UserDataCubit>().state.loadingcon == 1 ? const Color(0xff9f9f9f) : 
                                                      const Color(0xffCF000F),size: MediaQuery.of(context).size.width / 13)),
                                                  
                                                ),
                                              ),
                                            )
                                          // ElevatedButton(
                                          //   onPressed: () => _frameSwipeStarter(2),
                                          //   style: ElevatedButton.styleFrom(
                                          //       backgroundColor: const Color.fromARGB(255, 41, 41, 41),
                                          //       shape: const CircleBorder(),
                                                
                                          //       ),
                                          //   child: Center(
                                          //       child: Icon(Icons.close_rounded,color:  colorcontext.watch<UserDataCubit>().state.loadingcon == 1
                                          //           ? const Color(0xff9f9f9f)
                                                        
                                          //           : const Color(0xffBD3B1B),
                                          //       size: MediaQuery.of(context).size.width / 7)
                                          //       /*Text('ရပ်',
                                          //           style: GoogleFonts.roboto(
                                          //               color: Colors.white,
                                          //               fontSize: MediaQuery.of(
                                          //                           colorcontext)
                                          //                       .size
                                          //                       .width /
                                          //                   25,
                                          //               fontWeight:
                                          //                   FontWeight.bold)) */ 
                                          //                   ),
                                          // ),
                                        );
                                      }),
                                    ), 
                                    Builder(
                                      builder: (BuildContext poscontext) {
                                        return Positioned(
                                          right: poscontext.watch<MatchSwipCubit>().state.initialwidgetstarter == 1 ? 30 : 
                                           MediaQuery.of(poscontext).size.width / 2.7,
                                          bottom:
                                              (MediaQuery.of(poscontext).size.height / 2) /
                                                  30,
                                          child: SizedBox(
                                            width: MediaQuery.of(poscontext).size.width / 9,
                                            height:
                                                MediaQuery.of(poscontext).size.width / 9,
                                            child: Builder(
                                              builder: (BuildContext loadingnetworkcon) {
                                                return loadingnetworkcon.watch<UserDataCubit>().state.paymentstatus == 1  &&
                                                loadingnetworkcon.watch<MatchSwipCubit>().state.initialwidgetstarter == 0 ? const Text('') : 
                                                loadingnetworkcon.watch<MatchSwipCubit>().state.initialwidgetstarter == 1 ? 
                                                AnimatedBuilder(
                                                    animation: _floatinganimation,
                                                  builder : (BuildContext floatingcontext,child) {
                                                    return  Transform.translate(
                                                      offset: Offset(0,_floatinganimation.value),
                                                      child: RippleAnimation(
                                                      size: const Size(10, 10),
                                                      minRadius: 30,
                                                      duration: const Duration(seconds: 1),
                                                      color: Colors.white,
                                                      repeat: true,
                                                      ripplesCount: 1,
                                                      child: ClipOval(
                                                        child:  Material(
                                                          color:  Colors.white,
                                                          child: InkWell(
                                                            splashColor: Colors.lightBlue.withOpacity(0.5),
                                                            onTap: () =>_frameSwipeStarter(1),
                                                            child: Center(
                                                              child: 
                                                                Icon(Icons.arrow_forward,color: floatingcontext.watch<UserDataCubit>().state.loadingcon == 1 ? const Color(0xff9f9f9f) : 
                                                                Colors.lightBlue,size: MediaQuery.of(context).size.width / 14)),
                                                            
                                                          ),
                                                        ),
                                                      ),
                                                                                                      ),
                                                    );
                                                  }
                                                 
                                                ): ClipOval(
                                                    child:  Material(
                                                      color:  Colors.white,
                                                      child: InkWell(
                                                        splashColor: Colors.lightBlue.withOpacity(0.5),
                                                        onTap: () =>_frameSwipeStarter(1),
                                                        child: Center(
                                                          child: 
                                                            Icon(Icons.arrow_forward,color: loadingnetworkcon.watch<UserDataCubit>().state.loadingcon == 1 ? const Color(0xff9f9f9f) : 
                                                            Colors.lightBlue,size: MediaQuery.of(context).size.width / 10)),
                                                        
                                                      ),
                                                    ),
                                                  );
                                                //  ElevatedButton(
                                                //     onPressed: () => _frameSwipeStarter(1),
                                                //     style: ElevatedButton.styleFrom(
                                                //         backgroundColor: Colors.white,
                                                //         shape:const CircleBorder()),
                                                //     child: Center(
                                                //         child: Icon(Icons.arrow_forward,
                                                //             color: loadingnetworkcon.watch<UserDataCubit>().state.loadingcon == 1 ? const Color(0xff9f9f9f)
                                                //              : 
                                                //             const Color(0xffB9D870),
                                                //             size: MediaQuery.of(loadingnetworkcon)
                                                //                     .size
                                                //                     .width /
                                                //                 8)));
                                              }
                                            ),
                                          ),
                                        );
                                      }
                                    ) 
                                  ]),
                                ),
                          
                        );
                  }),
       
                 
                  _shimstatus
                      ? Expanded(
                            child: Shimmer.fromColors(
                            baseColor: const Color.fromARGB(255, 92, 92, 92),
                            highlightColor:
                                const Color.fromARGB(255, 138, 138, 138),
                            enabled: true,
                            child: Container(
                                color: Colors.black,
                                width: MediaQuery.of(context).size.width,
                                height: (MediaQuery.of(context).size.height / 2 -
                                    MediaQuery.of(context).size.height / 13),
                                child: null),
                          )
                      )
                      : Expanded(
                          child:
                         
                             
                               Container(
                                height: (MediaQuery.of(context).size.height / 2 -
                                    MediaQuery.of(context).size.height / 13),
                                    color: Colors.black,
                                
                                child: Builder(builder: (BuildContext bcontext12x) {
                                  return SizedBox(
                                      width: 1600,
                                      height: 1080,
                                      child: Stack(
                                        children: [
                                          RTCVideoView(_localVideoRender,
                                              mirror: _cameramirrorstatus,
                                              objectFit: RTCVideoViewObjectFit
                                                  .RTCVideoViewObjectFitCover),
                                          Positioned(
                                              bottom: (MediaQuery.of(bcontext12x)
                                                              .size
                                                              .height /
                                                          2 -
                                                      MediaQuery.of(bcontext12x)
                                                              .size
                                                              .height /
                                                          13) /
                                                  20,
                                              right: MediaQuery.of(bcontext12x)
                                                      .size
                                                      .width /
                                                  25,
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                      height:
                                                          MediaQuery.of(bcontext12x)
                                                                  .size
                                                                  .height /
                                                              80),
                                                  InkWell(
                                                    onTap: () => _switchCamera(),
                                                    child: Builder(
                                                      builder: (BuildContext loadingwhilecon) {
                                                        return CircleAvatar(
                                                          backgroundColor: loadingwhilecon.watch<UserDataCubit>().state.loadingcon == 1 ? 
                                                          const Color(0xff9f9f9f)
                                                      .withOpacity(0.6) : 
                                                          Colors.black
                                                              .withOpacity(0.7),
                                                          radius:
                                                              MediaQuery.of(loadingwhilecon)
                                                                      .size
                                                                      .width /
                                                                  17,
                                                          child: const Icon(
                                                              Icons.cameraswitch,
                                                              color: Colors.white),
                                                        );
                                                      }
                                                    ),
                                                  ),
                                                ],
                                              )),
                                                
                                            
                                        ],
                                      ));
                                }),
                                                         ),
                             ),
                          
                        
                ],
              )),
            )));
  }
  paidContentWidget(BuildContext paidcontext) {
   
    return
       ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
         child: Container(
          width: MediaQuery.of(paidcontext).size.width,
          height: (MediaQuery.of(paidcontext).size.height / 2 -
                  MediaQuery.of(paidcontext).size.height / 13) +
              MediaQuery.of(paidcontext).size.height / 30,
           
          decoration:  const BoxDecoration(
            
            image: DecorationImage(image: AssetImage('assets/img/bg.jpg'),opacity: 0.4,fit: BoxFit.fill),
            color: Colors.white,
           
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            
            children: [
              Container(
                width: MediaQuery.of(paidcontext).size.width - 10,
                height: ((MediaQuery.of(paidcontext).size.height / 2 -
                  MediaQuery.of(paidcontext).size.height / 13) +
              MediaQuery.of(paidcontext).size.height / 30) / 2.5,
              
              decoration:  BoxDecoration(
                color: const Color(0xffCACACA).withOpacity(0.5),
                borderRadius: BorderRadius.circular(15.0)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(paidcontext.read<UserDataCubit>().state.firsttimespay != 1 ?  'သင်သည်ရက်သုံးဆယ်ကိုကျော်လွန်သွားပါပြီ။' : 'သင်သည် free-plan ကိုကျော်လွန်သွားပါပြီ။',
                  style: GoogleFonts.roboto(color: Colors.black,fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(paidcontext).size.width / 22)),
                  Center(child: Text('တစ်လစာအတွက်',style: GoogleFonts.roboto(color: Colors.black,fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(paidcontext).size.height / 30))),
                  Expanded(
                    child: Center(child: Text('only 4,000 KS',style: TextStyle(color: const Color.fromARGB(255, 98, 194, 2),fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(paidcontext).size.height / 35))),
                  )
           
                ],
              ),
           
              ),
              SizedBox(height: ((MediaQuery.of(paidcontext).size.height / 2 -
                  MediaQuery.of(paidcontext).size.height / 13) +
              MediaQuery.of(paidcontext).size.height / 30) / 20),
              SizedBox(
                width:  MediaQuery.of(paidcontext).size.width / 1.5,
                height: MediaQuery.of(paidcontext).size.height / 17,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(context, CustomPageRoute(child : const PaymentOptionPage(),sidepos: 1), (Route<dynamic> route) => false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffFF0000),
                  ),
                  child: Text('Paid',style: GoogleFonts.roboto(fontWeight: FontWeight.bold,color: Colors.white,
                  fontSize: MediaQuery.of(paidcontext).size.width / 20)),
           
                ))
           
            ],
          ),
             ),
       );
    
  }
  
  _showBgCover(BuildContext initialcontext) {
    return Positioned(
            top: 0,right: 0,left:  0,bottom: 0,
            child: 
                
                Container(
                  //width: MediaQuery.of(initialcontext).size.width,
              height: (MediaQuery.of(initialcontext).size.height / 2 -
                    MediaQuery.of(initialcontext).size.height / 13) +
                MediaQuery.of(initialcontext).size.height / 30,
                decoration:  BoxDecoration(
                  
                  borderRadius: BorderRadius.circular(15.0),
                  image:  const DecorationImage(image:  AssetImage('assets/img/bg_cover.png'),fit: BoxFit.fill,
                  )
                ),
                 
                ));
  }
  _internetConnectionMessageContent(BuildContext b1xcontext) {

    return Stack(
      children: [
        _showBgCover(b1xcontext),
        Positioned(child : _internetConnectionMessage(b1xcontext))

        
        

      ],
    );
  }
  _internetConnectionMessage(BuildContext b1xcontext) {
    return Center(
        child: Column(
        
          children: [
            SizedBox(height: MediaQuery.of(b1xcontext).size.height / 25),
            Icon(Icons.emoji_emotions_sharp,color: Colors.white,size: MediaQuery.of(b1xcontext).size.width / 5),
            SizedBox(height: MediaQuery.of(b1xcontext).size.height / 30,),
            Text('အင်တာနက်လှိုင်းပြဿနာရှိနေသည်။',style: GoogleFonts.roboto(color: Colors.white,fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(b1xcontext).size.width / 20)),
            SizedBox(height: MediaQuery.of(b1xcontext).size.height / 30,),
            SizedBox(
              width: MediaQuery.of(b1xcontext).size.width / 3,
              height: MediaQuery.of(b1xcontext).size.height / 17,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffFF0000)
                ),
                onPressed: () async => await _reloadInternetConnection(),
                child: 
                Center(child: 
                Builder(
                  builder: (BuildContext loadingnetcon) {
                    return loadingnetcon.watch<UserDataCubit>().state.loadingcon == 1 ? 
                    
                    const CircularProgressIndicator(color: Colors.white) : 
                    Text('ပြန်ကြိုးစားပါ',style: GoogleFonts.roboto(color: Colors.white,fontWeight: FontWeight.bold,fontSize: MediaQuery.of(loadingnetcon).size.width / 28),);
                  }
                )),
              ),
            )
          ],
        ));
  }
  _reloadInternetConnection() async {
    context.read<UserDataCubit>().updateLoadingCon(1);
    final netstatus = await checkInternetConnection();
    if (netstatus == 1) {
      if (!mounted) return;
      context.read<UserDataCubit>().updateLoadingCon(0);
      context.read<UserDataCubit>().updateNetworkConnection(1);
      _frameSwipeStarter(1);

      

    }
    else if (netstatus == 0) {
      if (!mounted) return;
      context.read<UserDataCubit>().updateLoadingCon(0);
    }
  }

  _frameSwipeStarter(int frameswipestatus) {
    
    if (context.read<UserDataCubit>().state.networkcon != 0) {
      if (context
              .read<RemoteClientStatusCubit>()
              .state
              .clientvideoconnectstatus &&
          context.read<MatchControllerBloc>().state.matchstatus !=
              MatchStatus.sucessfullyconnectmatch) {
        if (frameswipestatus == 2) {
          if (context.read<MatchSwipCubit>().state.initialwidgetstarter == 0) {
            
            _frameStartSwipe(2);
    
            
          }
        } else {
          _frameStartSwipe(1);
  
          
        }
      } else {
        if ((context.read<UserDataCubit>().state.bonusmatch < 6 ||
                context.read<UserDataCubit>().state.token != '') ||
            (context.read<UserDataCubit>().state.paymentstatus == 0 ||
                context.read<MatchSwipCubit>().state.initialwidgetstarter ==
                    1)) {
          if (context.read<MatchSwipCubit>().state.gestureswipedstatus != 1) {
            if (frameswipestatus == 2) {
              if (context.read<MatchSwipCubit>().state.initialwidgetstarter ==
                  0) {
                _frameStartSwipe(2);
                
              }
            } else {
              _frameStartSwipe(1);
           
            }
          }
        }
      }
    }
    
  }

  _switchCamera() {
    _cameramirrorstatus = !_cameramirrorstatus;
    _localMediaStream!.getVideoTracks().forEach((track) {
      Helper.switchCamera(track);
    });
    setState(() {});
  }

  _frameStartSwipe(int posstatus) {
    context.read<MatchSwipCubit>().updatePosWidgetSwipe(1, posstatus);
    _movecontroller.forward();
    _rotatecontroller.repeat(reverse: true);
  }

  _nextFrameSwipe() async {

    context.read<RemoteClientStatusCubit>().state.clientvideoconnectstatus
        ? context
            .read<RemoteClientStatusCubit>()
            .updateClientVideoConnectStatus(false)
        : null;
    context.read<RemoteClientStatusCubit>().state.clientconnectstatus
        ? context.read<RemoteClientStatusCubit>().updateClientConnectStatus()
        : null;
    _resetController();
    if (context.read<MatchSwipCubit>().state.posswipe == 1) {
      

      if ((context.read<UserDataCubit>().state.bonusmatch < 6 || context.read<UserDataCubit>().state.bonusmatch == 10) && 
          context.read<UserDataCubit>().state.paymentstatus == 0) {
        if (context
                .read<RemoteClientStatusCubit>()
                .state
                .remoteclientoundstatus ==
            false) {
          print('Working reset');
          context.read<MatchSwipCubit>().updateWidgetSwipeOverStatus(1);  
          context.read<MatchSwipCubit>().state.initialwidgetstarter == 1
              ? _startFindMatch()
              : _resetPrcAndClose('reset');
          await Future.delayed(const Duration(milliseconds: 120));
          if (!mounted) return;
          context.read<MatchSwipCubit>().updatePosWidgetSwipe(0, 0);
          context.read<MatchSwipCubit>().updateWidgetSwipeOverStatus(0);
        } else {
          context.read<MatchSwipCubit>().updateWidgetSwipeOverStatus(1);
          await Future.delayed(const Duration(milliseconds: 120));
          if (!mounted) return;
          context.read<MatchSwipCubit>().updatePosWidgetSwipe(0, 0);
          context.read<MatchSwipCubit>().updateWidgetSwipeOverStatus(0);
        }
      } else {
     
          context.read<MatchSwipCubit>().updateWidgetSwipeOverStatus(1);
          _resetPrcAndClose('close');
          await Future.delayed(const Duration(milliseconds: 120));
          if (!mounted) return;
          context.read<MatchSwipCubit>().updateWidgetinitalStater(0);
          context.read<UserDataCubit>().state.paymentstatus == 1 ? null : context.read<UserDataCubit>().updatePaymentStatus();
          context.read<MatchSwipCubit>().updatePosWidgetSwipe(0, 0);
          context.read<MatchSwipCubit>().updateWidgetSwipeOverStatus(0);
          context.read<MatchControllerBloc>().state.matchstatus  != MatchStatus.initial  && 
          context.read<SocketConnectorCubit>().state.socketio.connected ?  
          context.read<PreServiceBloc>().add(const PreStatusEvent(
              recevicesingalingdata: [], prestatus: PreStatus.leavechat)) : null;
      }
    } else if (context.read<MatchSwipCubit>().state.posswipe == 2) {
      context.read<MatchSwipCubit>().updateWidgetSwipeOverStatus(1);
      await Future.delayed(const Duration(milliseconds: 120));
      if (!mounted) return;
      _resetPrcAndClose('close');
      context.read<MatchSwipCubit>().updatePosWidgetSwipe(0, 0);
      context.read<MatchSwipCubit>().updateWidgetinitalStater(1);
      context.read<MatchSwipCubit>().updateWidgetSwipeOverStatus(0);
      
          context.read<SocketConnectorCubit>().state.socketio.connected ?  
          context.read<PreServiceBloc>().add(const PreStatusEvent(
              recevicesingalingdata: [], prestatus: PreStatus.leavechat)) : null;
    }
  }
  updateBonuseEnd() {
    context.read<UserDataCubit>().updatePaymentStatus(); 
    context.read<UserDataCubit>().updateBonusStatus(10);
    context.read<UserDataCubit>().updateToken('');
    context.read<UserDataCubit>().updateFirstTimesPayment(1);
  }

  _startFindMatch() {
    context.read<MatchSwipCubit>().updateWidgetinitalStater(0);
    context.read<PreServiceBloc>().add(const PreMatchEvent(
        matchstatus: MatchStatus.joinchatroom, singalingdata: []));
  }

  _resetPrcAndClose(String status) {
    context.read<RemoteClientStatusCubit>().updateClientRenderStatus(false);
    status == 'close'
        ? PrcClass.closePrcConnection()
        : status == 'reset'
            ? PrcClass.closePrcConnection()
            : null;
    _createPreConnection().then((P) {
      PrcClass.updatePRC(P);
      status == 'close'
          ? setState(() {})
          : context.read<PreServiceBloc>().conRestart();
    });
  }

  _resetController() {
    _movecontroller.reset();
    _rotatecontroller.repeat(reverse: false);
    _rotatecontroller.reset();
  }

  @override
  void dispose() {
    _localMediaStream?.dispose();
    _localVideoRender.dispose();
    _floatingbtncontroller.dispose();
    _remoteVideoRender.dispose();
    _movecontroller.dispose();
    _rotatecontroller.dispose();

    PrcClass.disposePrcConnection();
    super.dispose();
  }
}
