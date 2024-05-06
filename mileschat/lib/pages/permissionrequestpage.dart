import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mileschat/cubits/userdata/userdata_cubit.dart';
import 'package:mileschat/pages/homepage.dart';
import 'package:mileschat/provider/providers.dart';
import 'package:mileschat/widgets/custompageroute.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class PermissionRequestPage extends StatefulWidget {
  const PermissionRequestPage({super.key});

  @override
  State<PermissionRequestPage> createState() => _PermissionRequestPageState();
}

class _PermissionRequestPageState extends State<PermissionRequestPage> {
  Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.selected,
        MaterialState.focused,
        MaterialState.pressed,
      };
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false ,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 
                        MediaQuery.of(context).size.height
                        ,
                    decoration: const  BoxDecoration(
                
                        image: DecorationImage(
                      image: AssetImage('assets/img/bg.jpg'),
                      opacity: 0.45,
                      fit: BoxFit.fitHeight,
                    )),
                    child: Column(
                      children: [
                        Expanded(
                               
                          child: ListView(
                                
                                        children: [
                                          
                                                      SizedBox(
                                                          height:
                                                              MediaQuery.of(context).size.height / 20),
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width,
                                                        height: null,
                                                  
                                                          
                                                        child: AnimatedContainer(
                                                            curve: Curves.fastOutSlowIn,
                                                            alignment:
                                                                Alignment.topCenter,
                                                               
                                                            duration:
                                                                const Duration(milliseconds: 1000),
                                                            child: Image.asset(
                                                              MediaQuery.of(context).size.height > 1000
                                                                  ? 'assets/img/logo_large.png'
                                                                  : 'assets/img/logo1.png',
                                                            )),
                                                      ),
                                                      SizedBox(
                                                          height:
                                                              MediaQuery.of(context).size.height / 40),
                                                      
                                                      
                                                          Builder(builder: (context) {
                                                              return Center(
                                                                  child:  Text(
                                                                          'M  I  L  E  S  C  H  A  T',
                                                                          style: GoogleFonts.barlow(
                                                                            color: Colors.black,
                                                                            fontSize:
                                                                                MediaQuery.of(context)
                                                                                        .size
                                                                                        .width /
                                                                                    20,
                                                                          )));
                                                            }),
                                                            SizedBox(
                                                          height:
                                                              MediaQuery.of(context).size.height / 20),
                                                          Center(
                                                            child: Text(
                                                                      'ခွင့်ပြုချက်လိုအပ်သည်။',
                                                                      style: GoogleFonts.padauk(
                                                                          color: Colors.black,
                                                                          fontSize:
                                                                              MediaQuery.of(context)
                                                                                      .size
                                                                                      .width /
                                                                                  24,
                                                                          fontWeight: FontWeight.w800),
                                                                      softWrap: false,
                                                                    ),
                                                          ),
                                                          SizedBox(height: MediaQuery.of(context).size.height / 18),
                                                        
                                                        Center(
                                                          child:
                                                          
                                                            ClipRRect(
                                                              borderRadius: BorderRadius.circular(15),
                                                              child: Material(
                                                                child: InkWell(
                                                                  highlightColor: const Color(0xffCF000F).withOpacity(0.5),
                                                                  onTap: () async => context.read<UserDataCubit>().state.camerapermissionstatus == 1 ? null : await _requestCameraPermission() ,
                                                                  child: Ink(
                                                                    child: Container(
                                                                      width: MediaQuery.of(context).size.width / 2.5,
                                                                      height : MediaQuery.of(context).size.height / 5.7,
                                                                      decoration: BoxDecoration(
                                                                        color: Colors.black.withOpacity(0.13),
                                                                        borderRadius: BorderRadius.circular(15) 
                                                                      ),
                                                                      child: Stack(
                                                                        children: [
                                                                          Positioned(
                                                                            child: Align(
                                                                              alignment: Alignment.center,
                                                                              child: Icon(Icons.camera_alt,color: const Color.fromARGB(255, 49, 49, 49),size: MediaQuery.of(context).size.width / 6),
                                                                            ),
                                                                                                                            
                                                                          ),
                                                                           Align(
                                                                            alignment: Alignment.bottomRight,
                                                                              child:  
                                                                                  Builder(
                                                                                    builder: (BuildContext bcontext) {
                                                                                      return Transform.scale(
                                                                                        scale: 0.9,
                                                                                        child: Checkbox(
                                                                                        value: bcontext.watch<UserDataCubit>().state.camerapermissionstatus == 1 ? true : false,
                                                                                        focusColor: Colors.white,
                                                                                        hoverColor: Colors.white,
                                                                                       
                                                                                        
                                                                                        // Adjust visual density for a disabled appearance
                                                                                        fillColor: MaterialStateProperty.resolveWith<Color?>(
                                                                                        (Set<MaterialState> states) {
                                                                                          // Set different colors for different states
                                                                                          if (states.contains(MaterialState.disabled)) {
                                                                                            return bcontext.read<UserDataCubit>().state.camerapermissionstatus == 1 ?  Colors.green : Colors.white; // Color when the checkbox is disabled
                                                                                          }
                                                                                          return Colors.white; // Color for other states
                                                                                        },
                                                                                      ),                                                                 
                                                                                        onChanged: null,
                                                                                        
                                                                                                                                                      ),
                                                                                      );
                                                                                    }
                                                                                  ),
                                                                                
                                                                              )
                                                                                                                            
                                                                        ],
                                                                        
                                                                    )
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        
                                                        SizedBox(height: MediaQuery.of(context).size.height / 50),
                                                        Center(
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(15),
                                                            child: Material(
                                                              child: InkWell(
                                                                onTap: () async => context.read<UserDataCubit>().state.micpermissionstatus == 1  ? null : await _requestMicPermission(),
                                                                highlightColor: const Color(0xffCF000F).withOpacity(0.5),
                                                                child: Ink(
                                                                  child: Container(
                                                                    width: MediaQuery.of(context).size.width / 2.5,
                                                                    height : MediaQuery.of(context).size.height / 5.7,
                                                                    decoration: BoxDecoration(
                                                                      color: Colors.black.withOpacity(0.13),
                                                                      borderRadius: BorderRadius.circular(15) 
                                                                    ),
                                                                    child: Stack(
                                                                      children: [
                                                                        Positioned(
                                                                          child: Align(
                                                                            alignment: Alignment.center,
                                                                            child: Icon(Icons.mic,color: const Color.fromARGB(255, 49, 49, 49),size: MediaQuery.of(context).size.width / 6),
                                                                          ),
                                                                
                                                                        ),
                                                                         Align(
                                                                          alignment: Alignment.bottomRight,
                                                                            child:  
                                                                                Builder(
                                                                                  builder: (BuildContext bcontext45) {
                                                                                    return Transform.scale(
                                                                                      scale: 0.9,
                                                                                      child: Checkbox(
                                                                                      value: context.watch<UserDataCubit>().state.micpermissionstatus == 1 ? true : false,
                                                                                      focusColor: Colors.white,
                                                                                      hoverColor: Colors.white,
                                                                                     
                                                                                      
                                                                                      // Adjust visual density for a disabled appearance
                                                                                      fillColor: MaterialStateProperty.resolveWith<Color?>(
                                                                                      (Set<MaterialState> states) {
                                                                                        // Set different colors for different states
                                                                                        if (states.contains(MaterialState.disabled)) {
                                                                                          return bcontext45.read<UserDataCubit>().state.micpermissionstatus == 1 ? Colors.green : Colors.white; // Color when the checkbox is disabled
                                                                                        }
                                                                                        return Colors.white; // Color for other states
                                                                                      },
                                                                                    ),                                                                                                                                     
                                                                                      onChanged: null,
                                                                                      
                                                                                                                                                    ),
                                                                                    );
                                                                                  }
                                                                                ),
                                                                              
                                                                            )
                                                                
                                                                      ],
                                                                      
                                                                  )),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height : MediaQuery.of(context).size.height / 10),
                                                        Padding(
                                                          padding: const EdgeInsets.only(left:  20.0,right : 20.0),
                                                          child : SizedBox(
                                                            width: MediaQuery.of(context).size.width,
                                                            height: MediaQuery.of(context).size.height / 15,
                                                            child: Builder(
                                                              builder: (BuildContext bcontext12) {
                                                                return ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor: Provider.of<PermissionCheckNextStatus>(bcontext12,listen: true).getNextStatus() ? Colors.black : 
                                                                    Colors.grey,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(20.0)
                                                                    )
                                                                  ),
                                                                  onPressed: () => Provider.of<PermissionCheckNextStatus>(bcontext12,listen: false).getNextStatus() ? 
                                                                  Navigator.pushAndRemoveUntil(context, CustomPageRoute(child: const HomePage(),sidepos: 1), (Route<dynamic> route) => false) : null,
                                                                  child: Text('‌ရှေသို့',
                                                                                style: GoogleFonts.padauk(
                                                                                    color: Colors.white,
                                                                                    fontSize:
                                                                                        MediaQuery.of(bcontext12)
                                                                                                .size
                                                                                                .width /
                                                                                            20)),
                                                                );
                                                              }
                                                            ),
                                                          ),
                                                        )
                                  
                      
          ]))]) ,
                      )
        ),
      ),
    );
  }

  Future<void> _requestCameraPermission() async {
    PermissionStatus status  = await Permission.camera.request();
    if (status.isGranted) {
      Future.delayed(const Duration(milliseconds:  300),() {
     
        context.read<UserDataCubit>().updateCameraPermissionStatus();
        _checkPermissionSucess();
      });
      
    }

  }
  Future<void> _requestMicPermission() async {
    PermissionStatus status  = await Permission.microphone.request();
    if (status.isGranted) {
      Future.delayed(const Duration(milliseconds:  300),() {
     
        context.read<UserDataCubit>().updateMicPermissionStatus();
        _checkPermissionSucess();
      });
      
    }

  }
  _checkPermissionSucess() {
    if (context.read<UserDataCubit>().state.camerapermissionstatus == 1  && context.read<UserDataCubit>().state.micpermissionstatus == 1) {
      Provider.of<PermissionCheckNextStatus>(context,listen: false).updateNextStatus();
    }
  }
}