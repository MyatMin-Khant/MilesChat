import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mileschat/blocs/matchcontroller/match_controller_bloc.dart';
import 'package:mileschat/blocs/preservices/pre_service_bloc.dart';
import 'package:mileschat/blocs/singalingstatus/singaling_status_bloc.dart';
import 'package:mileschat/cubits/authservice/authservice_cubit.dart';
import 'package:mileschat/cubits/camerastatus/camera_status_cubit.dart';
import 'package:mileschat/cubits/clientids/clientids_cubit.dart';
import 'package:mileschat/cubits/matchswipe/match_swip_cubit.dart';
import 'package:mileschat/cubits/socketconnector/socket_connector_cubit.dart';
import 'package:mileschat/cubits/transcation_status/transcation_status_cubit.dart';
import 'package:mileschat/cubits/userdata/userdata_cubit.dart';
import 'package:mileschat/pages/homepage.dart';
import 'package:mileschat/pages/permissionrequestpage.dart';
import 'package:mileschat/pages/userrequestformpage.dart';
import 'package:mileschat/repositories/rep.dart';
import 'package:mileschat/services/checknetwork.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'cubits/remoteclientstatus/remote_client_status_cubit.dart';
import 'provider/providers.dart';


Future<void> main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(storageDirectory : kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory());
  await dotenv.load(fileName: ".env"); 
  runApp(
    //DevicePreview(
    
    //builder: (context) => 
    const MilesChatApp());//enabled: true));//));
} 

class MilesChatApp extends StatelessWidget {
  const MilesChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (BuildContext context) => AuthRep(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<MatchSwipCubit>(create: (context) => MatchSwipCubit()),
          BlocProvider<UserDataCubit>(create: (context) => UserDataCubit()),
          BlocProvider<MatchControllerBloc>(
              create: (context) => MatchControllerBloc()),
          BlocProvider<SocketConnectorCubit>(
              create: (context) => SocketConnectorCubit()),
          BlocProvider<ClientidsCubit>(create: (context) => ClientidsCubit()),
          BlocProvider<RemoteClientStatusCubit>(create: (context) => RemoteClientStatusCubit()),
          BlocProvider<AuthServiceCubit>(create: (context) => AuthServiceCubit(
            authrep: context.read<AuthRep>(),
            userdatacub: context.read<UserDataCubit>())),
          BlocProvider<TranscationStatusCubit>(create: (context) => TranscationStatusCubit(userdatacubit: context.read<UserDataCubit>())),
          BlocProvider<PreServiceBloc>(
              create: (context) => PreServiceBloc(
                  userdatacubit: context.read<UserDataCubit>(),
                  clientstatuscubit: context.read<RemoteClientStatusCubit>(),
                  clientidscub: context.read<ClientidsCubit>(),
                  matchbloc: context.read<MatchControllerBloc>(),
                  matchswipecubit: context.read<MatchSwipCubit>(),
                  socketiocub: context.read<SocketConnectorCubit>())),
                  
          BlocProvider<SingalingStatusBloc>(create: (context) => SingalingStatusBloc(preservicebloc: context.read<PreServiceBloc>()),lazy: false),
          BlocProvider<CameraStatusCubit>(create: (context) => CameraStatusCubit())
        ],
        child: MultiBlocProvider(
          providers: [
            ChangeNotifierProvider<SubmitData>(create: (context) => SubmitData()),
            ChangeNotifierProvider<DataProperties>(create: (context) =>  DataProperties()),
            ChangeNotifierProvider<ShimmerLoadingStatus>(create: (context) =>  ShimmerLoadingStatus()),
            ChangeNotifierProvider<SelectedPaymentService>(create: (context) => SelectedPaymentService()),
            ChangeNotifierProvider<RedirectPaymentGateWayUrl>(create: (context) => RedirectPaymentGateWayUrl()),
            ChangeNotifierProvider<CheckUserInfoStatus>(create: (context) =>  CheckUserInfoStatus()),
            ChangeNotifierProvider<PermissionCheckNextStatus>(create: (context) => PermissionCheckNextStatus())
          ],
          child: MaterialApp(
            theme: ThemeData(scaffoldBackgroundColor: Colors.white),
            
            debugShowCheckedModeBanner: false,
            builder: (BuildContext context,Widget? child) {
              return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.04), 
              child: child!);
            },
            home: const InitializeWidget()
          ),
        ),
      ),
    );
  }
}


class InitializeWidget extends StatefulWidget {
  const InitializeWidget({super.key});

  @override
  State<InitializeWidget> createState() => _InitializeWidgetState();
}

class _InitializeWidgetState extends State<InitializeWidget> {
  @override
  void initState() {
    super.initState();
    startrequestPermission();
    
  }
   startrequestPermission() async => await initialLoading();
  @override
  Widget build(BuildContext context) {  
    return const SafeArea(
      child: Scaffold( 
        backgroundColor: Colors.white,
      ),
    );
  }
  Future<void> initialLoading() async {
   
      if (!mounted) return;
        if (context.read<UserDataCubit>().state.name == '' && context.read<UserDataCubit>().state.token == '') {
          final int checkinternet = await checkInternetConnection();
          if (checkinternet == 1) {
             if (!mounted) return;
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const UserRequestForm()),(Route<dynamic> route) => false);
          }
          else {
            if (!mounted) return;
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const NetWorkFailPage(devicesignstatus: 0)),(Route<dynamic> route) => false);

          }
          
          
        }
        else {
           if (!mounted) return;
          final int checkinternet = await checkInternetConnection();
          if (checkinternet == 1) {
              if (!mounted) return;
              final int permissionstatus = await _checkPermission();
              if (permissionstatus == 1) {
                if (!mounted) return;
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>  const HomePage()),(Route<dynamic> route) => false);
              }
              else {
                if (!mounted) return;
                
                
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>  const PermissionRequestPage()),(Route<dynamic> route) => false);
              }
              
          }
          else {
            if (!mounted) return;
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const NetWorkFailPage(devicesignstatus: 1)),(Route<dynamic> route) => false);
          }  
        }
  }
  Future _checkPermission() async {
    if (await Permission.camera.isGranted && await Permission.microphone.isGranted) {
        return 1;
    }
    else {
      bool  micstatus  = await Permission.microphone.isGranted;

      bool camerastatus  = await Permission.camera.isGranted;
      if (!mounted) return;
      micstatus ? null : context.read<UserDataCubit>().updateMicPermissionStatus();
      camerastatus ? null : context.read<UserDataCubit>().updateCameraPermissionStatus();
      return 0;
    }
  } 
  
}   
class NetWorkFailPage extends StatefulWidget {

  final int devicesignstatus;
  const NetWorkFailPage({super.key,required this.devicesignstatus});
  @override
  State<NetWorkFailPage> createState() => _NetWorkFailPageState();
}

class _NetWorkFailPageState extends State<NetWorkFailPage> {
  int loadingstatus = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children : [
                Text('အင်တာနက်မရပါ။',style: TextStyle(fontSize: MediaQuery.of(context).size.width / 20
                ,color: Colors.black,fontWeight: FontWeight.bold)),
                SizedBox(height: MediaQuery.of(context).size.height / 50),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3.5,
                  height: MediaQuery.of(context).size.height / 20,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: loadingstatus == 1 ? Colors.grey : 
                      const Color(0xffFF0000)
                    ),
                    onPressed: () async  {
                      if (loadingstatus == 0) {
                      setState(() {
                        loadingstatus = 1;
                      });
                      await _recheckInternetStatus(widget.devicesignstatus);
                      }
    
                    },
                    child: const Text('Try again',style: TextStyle(color: Colors.white)),
                  ),
                )
              ]  
          ),
        ),
      ),
    );
  }

  Future<void> _recheckInternetStatus(int devicesignstatus) async {
    final int internetstatus = await checkInternetConnection();
    if (internetstatus == 1 && devicesignstatus == 0) {
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const UserRequestForm()),(Route<dynamic> route) => false);
    }
    else if(internetstatus == 1 && devicesignstatus == 1) {
      if (!mounted) return;
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>  const HomePage()),(Route<dynamic> route) => false);
  }
    else {
      setState(() {
        loadingstatus = 0;
      });
    }
  } 
}


