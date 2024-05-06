import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mileschat/cubits/userdata/userdata_cubit.dart';
import 'package:mileschat/pages/homepage.dart';
import 'package:mileschat/pages/paymentprocessingpage.dart';
import 'package:mileschat/provider/providers.dart';
import 'package:mileschat/widgets/custompageroute.dart';
import 'package:provider/provider.dart';

class PaymentOptionPage extends StatefulWidget {
  const PaymentOptionPage({super.key});

  @override
  State<PaymentOptionPage> createState() => _PaymentOptionPageState();
}

class _PaymentOptionPageState extends State<PaymentOptionPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
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
                              return Icon(Icons.account_circle_outlined,size: MediaQuery.of(bcontext).size.width / 15,color: Colors.white);
                              // CircleAvatar(
                              //         backgroundColor:
                              //             const Color.fromARGB(255, 32, 32, 32),
                              //         radius:
                              //             MediaQuery.of(bcontext).size.width / 25,
                              //         backgroundImage: const AssetImage(
                              //             'assets/img/profile_rep_bg_change.png'));
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
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  
                  children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: const BoxDecoration(
                          image: DecorationImage(image: AssetImage('assets/img/bg.jpg'),fit: BoxFit.fill,opacity: 0.7),
                          color: Colors.white,
                        ),
                        
                        child: Column(
                          
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height / 10),
                            
                            //SizedBox(height: MediaQuery.of(context).size.height / 100),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.white.withOpacity(0.3),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start ,
                                  children: [ 
                                    
                                    SizedBox(height: MediaQuery.of(context).size.height / 70),
                                    Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 50),
                                child: IconButton(icon : Icon(Icons.arrow_back,color: Colors.black,size: MediaQuery.of(context).size.width / 13,),
                                onPressed: () => Navigator.pushAndRemoveUntil(context, CustomPageRoute(child : const HomePage(),sidepos: -1), (Route<dynamic> route) => false),
                                          )),
                                    SizedBox(height: MediaQuery.of(context).size.height / 44),
                                    Center(
                                      child: Text('Payment service ကိုရွေးချယ်ပေးပါ။',style: GoogleFonts.roboto(color: Colors.black,fontWeight: FontWeight.bold,
                                      fontSize: MediaQuery.of(context).size.width / 20)),
                                    ),
                                    SizedBox(height: MediaQuery.of(context).size.height / 20),
                                    Center(child:  _paymentCardWidget(context,'kbz')),
                                   
                                    SizedBox(height: MediaQuery.of(context).size.height / 110),
                                    Center(child:  _paymentCardWidget(context,'wave')),
                                    
                                    // SizedBox(height: MediaQuery.of(context).size.height / 110),
                                    // _paymentCardWidget(context,'aya'),
                                    SizedBox(height: MediaQuery.of(context).size.height / 10)
                                    /*SizedBox(height: MediaQuery.of(context).size.height / 110),
                                    _paymentCardWidget(context,'mytel'),
                                    SizedBox(height: MediaQuery.of(context).size.height / 110),
                                    _paymentCardWidget(context,'onepay'),
                                    SizedBox(height: MediaQuery.of(context).size.height / 110),
                                    _paymentCardWidget(context,'mpu'),
                                    SizedBox(height: MediaQuery.of(context).size.height / 110),
                                    _paymentCardWidget(context,'visa'),
                                    SizedBox(height: MediaQuery.of(context).size.height / 110),
                                    _paymentCardWidget(context,'mastercard'), */
              
                                    
                                    
              
                  
                                  ],
                  
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 10,
                color: const Color(0xffE8E3DF),
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.1,
                    height: MediaQuery.of(context).size.height / 20,
                    child: ElevatedButton(
    
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffFF0000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)
                        )
                      ),
                      onPressed: () => Navigator.pushAndRemoveUntil(context, CustomPageRoute(child:  PaymentFormPage(
                        paymenttype: Provider.of<SelectedPaymentService>(context,listen: false).getPaymentService(),
                      ),sidepos: 1), (Route<dynamic> route) => false),
                      child: Text('ရှေသို့',style: GoogleFonts.roboto(color: Colors.white,fontWeight: FontWeight.bold,
                      fontSize: (MediaQuery.of(context).size.height / 10) / 4.5)),
                    ),
                  ),
                ),
                )
            ],
          ),
        ),
      ),
    );
  }
  _paymentCardWidget(BuildContext cardcontext,String paymentname) {
    return InkWell(
      onTap: () => Provider.of<SelectedPaymentService>(cardcontext,listen: false).updatePaymentService(paymentname),
      child: Builder(
        builder: (BuildContext selectedcontext) {
          return Container(
            width: MediaQuery.of(selectedcontext).size.width / 1.4,
            height: MediaQuery.of(selectedcontext).size.height / 14,
            decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              border: Border.all(color: 
              Provider.of<SelectedPaymentService>(selectedcontext,listen: true).getPaymentService() == paymentname ? 
               const Color(0xffFF0000) : 
              const Color(0xff8C8A8A).withOpacity(0.5),
              width: Provider.of<SelectedPaymentService>(selectedcontext,listen: false).getPaymentService() == paymentname ?  1.4 : 1.0)
              
            ),
            child: Row(
           
              children: [
                SizedBox(width: (MediaQuery.of(selectedcontext).size.width / 1.1) / 11),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child:  paymentname == 'onepay' ?  
                  SvgPicture.asset('assets/img/onepay.svg',width:  
                   MediaQuery.of(selectedcontext).size.width / 50,
                  height:  MediaQuery.of(selectedcontext).size.height / 50,fit: BoxFit.fitWidth) : 
                  Image.asset(paymentname == 'kbz' ? 'assets/img/kbzpay.png' : paymentname == 'wave' ? 'assets/img/wavepaylogo.png' : paymentname == 'aya' ? 'assets/img/ayapaylogo.png' :
                   paymentname == 'mytel' ? 'assets/img/mytelpaylogo.png' : paymentname == 'mpu' ? 'assets/img/mpu_logo.png' : paymentname == 'visa' ? 'assets/img/visalogo.png' : paymentname == 'mastercard' ? 
                   'assets/img/mastercardlogo.png' : '',
                   // 5.8,13
                  width:  MediaQuery.of(selectedcontext).size.width / 10,
                  height: (MediaQuery.of(selectedcontext).size.height / 21),fit: BoxFit.fitWidth,),
                ),
                SizedBox(width: (MediaQuery.of(selectedcontext).size.width / 1.1) / 10),
              Text(paymentname == 'kbz' ? 'KBZ Pay' : paymentname == 'wave' ? 'Wave Pay' :  paymentname == 'aya' ? 'AYA Pay' : paymentname == 'mytel' ? 'Mytel Pay' :  paymentname == 'mpu' ? 'MPU' : paymentname == 'visa' ? 'Visa' : 
                paymentname == 'onepay' ? 'OnePay' : paymentname == 'mastercard' ? 'MasterCard' : ''
              ,style: GoogleFonts.roboto(color: Colors.black,fontSize: MediaQuery.of(selectedcontext).size.width / 20))
              ],
            ),
          );
        }
      ),
    );

  }
}