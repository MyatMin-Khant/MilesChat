import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mileschat/cubits/userdata/userdata_cubit.dart';
import 'package:mileschat/pages/homepage.dart';
import 'package:mileschat/pages/paymentoptionpage.dart';
import 'package:mileschat/widgets/custompageroute.dart';

class ComfirmPaymentpage extends StatefulWidget {
  final int paymentcomfirmstatus;
  const ComfirmPaymentpage({super.key,required this.paymentcomfirmstatus});

  @override
  State<ComfirmPaymentpage> createState() => _ComfirmPaymentpageState();
}

class _ComfirmPaymentpageState extends State<ComfirmPaymentpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              return CircleAvatar(
                                      backgroundColor:
                                          const Color.fromARGB(255, 32, 32, 32),
                                      radius:
                                          MediaQuery.of(bcontext).size.width / 25,
                                      backgroundImage: const AssetImage(
                                          'assets/img/profile_rep_bg_change.png'));
                            }),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width / 2 / 20),
                           Text(context.read<UserDataCubit>().state.name,
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
              body: Container( 
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(image: AssetImage('assets/img/bg.jpg'),fit: BoxFit.fill,opacity: 0.6)
                  
                ),
                child: Column(
                  children: [ 
                    SizedBox(height:  MediaQuery.of(context).size.height / 20),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        height: MediaQuery.of(context).size.height / 2,
                        color: Colors.white.withOpacity(0.4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text( widget.paymentcomfirmstatus == 1 ? 
                              'သင်ရဲ့ငွေပေးချေမည့်အောင်မြင်ပါသည်။' : 'သင်ရဲ့ငွေပေးချေမည့် မအောင်မြင်ပါ။',style: GoogleFonts.roboto(
                                color: widget.paymentcomfirmstatus == 1 ? 
                                Colors.black : Colors.red,fontSize: MediaQuery.of(context).size.width / 20,fontWeight: FontWeight.bold)), 
                            SizedBox(height: MediaQuery.of(context).size.height / 50),
                            SizedBox(
                                width:  ((MediaQuery.of(context).size.width / 1.1) / 2),
                                height:  MediaQuery.of(context).size.height / 18,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffFF0000),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7.0)
                                    )
                                  ),
                                  onPressed: () {
                                    if (widget.paymentcomfirmstatus == 1) {
                                      
                                      Navigator.pushAndRemoveUntil(context, CustomPageRoute(child : const HomePage(),sidepos: -1), (Route<dynamic> route) => false);
                                    }
                                    else {
                                      Navigator.pushAndRemoveUntil(context, CustomPageRoute(child : const PaymentOptionPage(),sidepos: -1), (Route<dynamic> route) => false);
                                    }
                                  },
                                  child: Text( widget.paymentcomfirmstatus == 1 ?
                                    'အိမ်သို့' : 'ပြန်ကြိုးစားပါ',style: GoogleFonts.roboto(color: Colors.white,fontSize: (MediaQuery.of(context).size.height / 18) / 2.5,
                                  fontWeight: FontWeight.bold)),
                                ),
                              
                              ),


                          ],
                        )

                      ))
                  ],
                ),
              ),

    );
    
  }
  
  
}