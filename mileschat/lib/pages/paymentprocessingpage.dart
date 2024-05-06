import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mileschat/blocs/preservices/pre_service_bloc.dart';
import 'package:mileschat/cubits/socketconnector/socket_connector_cubit.dart';
import 'package:mileschat/cubits/transcation_status/transcation_status_cubit.dart';
import 'package:mileschat/cubits/userdata/userdata_cubit.dart';
import 'package:mileschat/pages/confirmpaymentpage.dart';
import 'package:mileschat/pages/paymentoptionpage.dart';
import 'package:mileschat/provider/providers.dart';
import 'package:mileschat/services/paymentapi.dart';
import 'package:mileschat/widgets/custompageroute.dart';
import 'package:mileschat/widgets/dialogswidget.dart';
import 'package:provider/provider.dart';

class PaymentFormPage extends StatefulWidget {
  final String paymenttype;
  const PaymentFormPage({super.key,required this.paymenttype});

  @override
  State<PaymentFormPage> createState() => _PaymentFormPageState();
}

class _PaymentFormPageState extends State<PaymentFormPage> {
  late FocusNode _phoneFouseNode;
  int buildingwidgetstatus = 0;
  TextEditingController phonecontroller = TextEditingController();
  final _foreginKey = GlobalKey<FormState>();
  @override
  void initState() {
    
    super.initState();
    _phoneFouseNode = FocusNode();
    _startFocusNode();

    
  }

  _startFocusNode() async {
    await Future.delayed(const Duration(microseconds: 1000));
    setState(() {
      buildingwidgetstatus = 1;
    });
    await Future.delayed(const Duration(milliseconds: 700));
    _phoneFouseNode.requestFocus();
    
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()  async  {
        Navigator.pushAndRemoveUntil(context, CustomPageRoute(child : const PaymentOptionPage(),sidepos: -1), (Route<dynamic> route) => false);
        return true;
      },
      
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: BlocListener<TranscationStatusCubit, TranscationStatusState>(
              listener: (context, state) {
                if (state.transcationstatus == TranscationStatus.failconnection || state.transcationstatus == TranscationStatus.initialloseconnection) {
                  Navigator.of(context).pop();
                  messageDialog(context,'အင်တာနက်လှိုင်း (သို့မဟုတ်) တစ်ခုခုပြဿနာရှိနေသည်။','ပြန်လည်ကြိုးစားပေးပါ။',1);



                }
                if (state.transcationstatus == TranscationStatus.failinitialcallbackconnection) {
                  Navigator.of(context).pop();
                  messageDialog(context,'အင်တာနက်လှိုင်းမရပါ။','ပြန်လည်ကြိုးစားပေးပါ။',0);

                }
                if (state.transcationstatus == TranscationStatus.transcationsucessully) {
                  Navigator.of(context).pop();
                  context.read<PreServiceBloc>().restPaymentMethod();  
                  context.read<TranscationStatusCubit>().updateTranscationStatus(TranscationStatus.initial);
                  Navigator.pushAndRemoveUntil(context, CustomPageRoute(child : const ComfirmPaymentpage(paymentcomfirmstatus: 1),sidepos: 1), (Route<dynamic> route) => false);


                }
                if (state.transcationstatus == TranscationStatus.transcationfail) {
                  Navigator.of(context).pop();
                  messageDialog(context,'ပြဿနာတစ်ခုခုရှိနေသည်။','ပြန်လည်ကြိုးစားပေးပါ။',0);

                } 
              
                if (state.transcationstatus == TranscationStatus.pending) {
                  loadingDialog(context);
                }
                
              },
              child: Scaffold(
                          resizeToAvoidBottomInset: false,
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
                                body:  buildingwidgetstatus == 1 ? 
                                Form(
                                  key: _foreginKey,
                                  child: SingleChildScrollView(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.height - Size.fromHeight(MediaQuery.of(context).size.height / 13).height,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        image: DecorationImage(image: AssetImage('assets/img/bg.jpg'),fit: BoxFit.fill,opacity: 0.6)
                                      ),
                                      child: widget.paymenttype == 'wave' || widget.paymenttype == 'kbz' || widget.paymenttype == 'aya'?  
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: MediaQuery.of(context).size.height / 40),
                                          Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 50),
                                          child: IconButton(icon : Icon(Icons.arrow_back,color: Colors.black,size: MediaQuery.of(context).size.width / 13,),
                                          onPressed: () => Navigator.pushAndRemoveUntil(context, CustomPageRoute(child : const PaymentOptionPage(),sidepos: -1), (Route<dynamic> route) => false),
                                          )),
                                          SizedBox(height: MediaQuery.of(context).size.height / 40),
                                          Center(
                                            child: Container(
                                              width: MediaQuery.of(context).size.width / 1.1,
                                              height: MediaQuery.of(context).size.height / 2,
                                              color: Colors.white.withOpacity(0.4),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [ 
                                                  SizedBox(height: MediaQuery.of(context).size.height / 30),
                                                  Padding(
                                                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 27,
                                                    right: MediaQuery.of(context).size.width / 27),
                                                    child: Text( widget.paymenttype == 'kbz' ? 
                                                      'သင်ရဲ့ငွေပေးချေမည့် KBZPay ဖုန်းနံပါတ်ကိုရိုက်ထည့်ပေးပါ။' : 
                                                      'သင်ရဲ့ငွေပေးချေမည့် WavePay ဖုန်းနံပါတ်ကိုရိုက်ထည့်ပေးပါ။'
                                                      ,style: GoogleFonts.roboto(
                                                      fontSize: MediaQuery.of(context).size.width / 25,
                                                      color: Colors.black
                                                    )),
                                                  ),
                                                  SizedBox(height: MediaQuery.of(context).size.height / 27),
                                                  Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 20),
                                                    child: Text('စုစုပေါင်း 4,000KS',style: GoogleFonts.roboto(
                                                      fontSize: MediaQuery.of(context).size.width / 22,fontWeight: FontWeight.bold,
                                                      color: Colors.black 
                                                    ),),
                                                  ),
                                                  SizedBox(height: MediaQuery.of(context).size.height / 30),
                                                  Center(
                                            
                                                    child: SizedBox(
                                                      width: (MediaQuery.of(context).size.width / 1.1) / 1.5 ,
                                                      height: MediaQuery.of(context).size.height < 750 ? 
                                                      MediaQuery.of(context).size.height / 12 : 
                                                      MediaQuery.of(context).size.height / 15,
                                                      child: renderTextField(),
                                                    ),
                                                  ),
                                                  SizedBox(height: MediaQuery.of(context).size.height / 40),
                                                  Center(
                                                    child: SizedBox(
                                                      width:  ((MediaQuery.of(context).size.width / 1.1) / 1.8),
                                                      height:  MediaQuery.of(context).size.height / 18,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: const Color(0xffFF0000),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(7.0)
                                                          )
                                                        ),
                                                        onPressed: () async {
                                                          if (_foreginKey.currentState!.validate()) {
                                                            await requestPaymentProcessing(
                                                              Provider.of<SelectedPaymentService>(context,listen: false).getPaymentService() == 'kbz' ? 'KBZ Pay' :
                                                              Provider.of<SelectedPaymentService>(context,listen: false).getPaymentService() == 'wave' ? 'Wave Pay' : 'AYA pay',
                                                              Provider.of<SelectedPaymentService>(context,listen: false).getPaymentService() == 'kbz' ? 'PWA' :
                                                              Provider.of<SelectedPaymentService>(context,listen: false).getPaymentService() == 'wave' ? 'PIN' : 'PIN',
                                                              phonecontroller.text);
                                                            //   int resultrestpayment = await resetPayment();
                                                            //   if (resultrestpayment == 1) {
                                                            //       if (!mounted) return;
                                                            //       Navigator.pushAndRemoveUntil(context, CustomPageRoute(child : const ComfirmPaymentpage(paymentcomfirmstatus: 1),sidepos: 1), (Route<dynamic> route) => false);
                                                            //   }
                                                            //   else if(resultrestpayment == -1) {
                                                            //     if (!mounted) return;
                                                            //     messageDialog(context,'Network Problem','Connection Error 404');
                                                            //   }
                                                            // else if (resultrestpayment == 0) {  
                                                            //   if (!mounted) return;
                                                            //     Navigator.pushAndRemoveUntil(context, CustomPageRoute(child : const ComfirmPaymentpage(paymentcomfirmstatus: 0),sidepos: 1), (Route<dynamic> route) => false);
                                                            // }
                                                          }
                                                          
                                                        },
                                                        child: Text('ပေးချေမယ်',style: GoogleFonts.roboto(color: Colors.white,fontSize: (MediaQuery.of(context).size.height / 18) / 2.5,
                                                        fontWeight: FontWeight.bold),),
                                                      ),
                                                    
                                                    ),
                                                  )
                                                  
                                                  
                                                ],
                                              ),
                                                  
                                                  
                                            ),
                                          )
                                        ],
                                      ) : null ,
                                    ),
                                  ),
                                )  : null 
                                 
                                
                        ),
            ) ,
          ),
        ),
      ),
    );
  }
  renderTextField() {
    return TextFormField(
      controller: phonecontroller,
      focusNode: _phoneFouseNode,
      autocorrect: false,

      keyboardType: TextInputType.number,
      style: GoogleFonts.roboto(
          //height: 10 / MediaQuery.of(bcontext).size.width / 14,
          color: const Color.fromARGB(255, 34, 34, 34),
          
          fontSize: MediaQuery.of(context).size.height / 40,
          
          //fontWeight: FontWeight.bold,

          decorationThickness: 0),
          obscureText: false,
          cursorColor: const Color.fromARGB(218, 31, 31, 31),
      decoration: InputDecoration (
          fillColor: Colors.white,
          filled: true,
          
          
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.0),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 71, 71, 71), width: 1.5),
          ),
          hintText: 'number',
          hintStyle: GoogleFonts.roboto(color: const Color(0xffA7A7A7),
          fontStyle: FontStyle.italic,fontSize: MediaQuery.of(context).size.height / 40),
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
              


      )
    );

  }
   Future<void>  requestPaymentProcessing(String paymentname,String methodname,String phonenumber) async {
    context.read<SocketConnectorCubit>().state.socketio.disconnect();
    await PaymentApi().connectCallBackTranscationStatus(context.read<SocketConnectorCubit>().state.paymentsocketio,
    context.read<UserDataCubit>().state.id,methodname,paymentname,context.read<UserDataCubit>().state.name,
    phonenumber,context.read<TranscationStatusCubit>(),context.read<UserDataCubit>(),context.read<SocketConnectorCubit>());
    

    /*final requestToken = await AuthApi().getToken(context.read<UserDataCubit>().state.name,
    context.read<UserDataCubit>().state.id);
    if (requestToken['status'] == 1) {
      _resetPaymentStatus(requestToken['token']);
      return 1;
      
    }
    else if (requestToken['status'] == -1) {
      return -1;
    }
    else {
      return 0;

    } */

  }
 
  @override
  void dispose() {
    super.dispose();
    _phoneFouseNode.dispose();
    phonecontroller.dispose();

  }
}