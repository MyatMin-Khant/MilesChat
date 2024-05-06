import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mileschat/pages/homepage.dart';
import 'package:mileschat/widgets/custompageroute.dart';

Future loadingDialog(BuildContext context)  async {
  return showDialog(
    context: context, 
    barrierDismissible: false,
    builder: (BuildContext context) {
      return 
         Center(
           child: Container(
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.height / 6,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10.0)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 SpinKitFadingCircle(
                    color: Colors.white.withOpacity(0.8),
                    size: MediaQuery.of(context).size.width / 8,
                ),
                Text('MilesChat',style: GoogleFonts.roboto(decoration: TextDecoration.none,color: Colors.white.withOpacity(0.8),fontSize:MediaQuery.of(context).size.width / 18,
                ))
         
              ],
            ),
                 ),
         );
      

    });

}
Future messageDialog(BuildContext context,String title,String content,int redirecthomecon) async {
  return showDialog(context: context, 
  barrierDismissible: false,
  builder: (BuildContext bcontext) {
    return AlertDialog(
      title : Text(title,style: GoogleFonts.padauk(color:  Colors.black,fontSize: MediaQuery.of(context).size.width / 20,
      fontWeight: FontWeight.bold),),
      content: Text(content,style: GoogleFonts.padauk(color:  Colors.black,fontSize: MediaQuery.of(context).size.width / 30,
      fontWeight: FontWeight.bold
      )),
      actions: [
        TextButton(
          
          onPressed: () {
            Navigator.of(context).pop();
            redirecthomecon  == 1 ? Navigator.pushAndRemoveUntil(context, CustomPageRoute(child : const HomePage(), sidepos: -1), (Route<dynamic> route) => false) : 
            redirecthomecon == -1 ? SystemNavigator.pop() : null;
            
          },
        
        child: Text('အိုကေ',style: GoogleFonts.padauk(color: const Color(0xffCF000F),fontSize: MediaQuery.of(context).size.width / 30,fontWeight: FontWeight.bold)))
      ],
    );
  });
}