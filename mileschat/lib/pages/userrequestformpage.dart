import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mileschat/cubits/authservice/authservice_cubit.dart';
import 'package:mileschat/pages/permissionrequestpage.dart';
import 'package:mileschat/provider/providers.dart';
import 'package:mileschat/widgets/custompageroute.dart';
import 'package:mileschat/widgets/dialogswidget.dart';
import 'package:provider/provider.dart';
//import 'package:mileschat/logowidget/logo.dart';

class UserRequestForm extends StatefulWidget {
  const UserRequestForm({super.key});

  @override
  State<UserRequestForm> createState() => _UserRequestFormState();
}

class _UserRequestFormState extends State<UserRequestForm>
    with SingleTickerProviderStateMixin {
  bool logoanimationcon = false;
  bool logoparaheight = false;
  bool namesetcontent = false;
  late AnimationController _logotextcontroller;
  late Animation<double> _animation;
  late FocusNode namefocusNode;
  TextEditingController namecontroller = TextEditingController();

  final _foreginKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    namefocusNode = FocusNode();
    _logotextcontroller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation =
        CurvedAnimation(parent: _logotextcontroller, curve: Curves.easeIn);
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        logoanimationcon = true;
      });
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          logoparaheight = true;
        });

        Future.delayed(const Duration(seconds: 1), () {
          _logotextcontroller.forward();

          setState(() {
            namesetcontent = true;
          });
          Future.delayed(const Duration(milliseconds: 700), () {
            namefocusNode.requestFocus();
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              body:  BlocListener<AuthServiceCubit, AuthServiceState>(
                  listener: (context, state) {
                    if (state.servicestatus == AuthServiceStatus.loading) {
                        loadingDialog(context);
             }
                    if(state.servicestatus == AuthServiceStatus.sucessfullysubmit) {
                        Navigator.of(context).pop(); 
                        Navigator.pushAndRemoveUntil(context, CustomPageRoute(child: const PermissionRequestPage(),sidepos: 1), (Route<dynamic> route) => false);
                    }
                    if (state.servicestatus == AuthServiceStatus.error) {
                        Navigator.of(context).pop();
                        messageDialog(context,'အင်တာနက်လှိုင်း (သို့မဟုတ်) တစ်ခုခုပြဿနာရှိနေသည်။','ပြန်လည်ကြိုးစားပေးပါ။',0);
                        context.read<AuthServiceCubit>().updateAuthStatus(AuthServiceStatus.initial);
                      
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                                            height: logoparaheight
                                                ? MediaQuery.of(context).size.height
                                                : null,
                                            decoration: const BoxDecoration(
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
                                                height: logoparaheight
                                                    ? null
                                                    : MediaQuery.of(context).size.height / 2,
                                                child: AnimatedContainer(
                                                    curve: Curves.fastOutSlowIn,
                                                    alignment: logoanimationcon
                                                        ? Alignment.topCenter
                                                        : Alignment.bottomCenter,
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
                                              logoparaheight
                                                  ? Builder(builder: (context) {
                                                      return Center(
                                                          child: FadeTransition(
                                                              opacity: _animation,
                                                              child: Text(
                                                                  'M  I  L  E  S  C  H  A  T',
                                                                  style: GoogleFonts.barlow(
                                                                    color: Colors.black,
                                                                    fontSize:
                                                                        MediaQuery.of(context)
                                                                                .size
                                                                                .width /
                                                                            20,
                                                                  ))));
                                                    })
                                                  : const Text(''),
                                              SizedBox(
                                                  height:
                                                      MediaQuery.of(context).size.height / 20),
                                              SizedBox(
                                            
                                                width: MediaQuery.of(context).size.width,
                                                height:
                                                    MediaQuery.of(context).size.height / 3,
                                                child: Stack(
                                                  children: [
                                                    Builder(builder: (BuildContext bcontext) {
                                                      return AnimatedPositioned(
                                                        duration:
                                                            const Duration(milliseconds: 500),
                                                        curve: Curves.fastOutSlowIn,
                                                        top: 0,
                                                        right: 0,
                                                        left: Provider.of<SubmitData>(bcontext,
                                                                    listen: true)
                                                                .getNameAnimatorCon()
                                                            ? MediaQuery.of(bcontext)
                                                                    .size
                                                                    .width +
                                                                50
                                                            : namesetcontent
                                                                ? 0
                                                                : -MediaQuery.of(bcontext)
                                                                    .size
                                                                    .width -100,
                                                        child: Align(
                                                          alignment: namesetcontent
                                                              ? Alignment.center
                                                              : Alignment.topLeft,
                                                          child: Text(
                                                            'နာမည် (သို့မဟုတ်) နာမည်ပြောင် ကိုရိုက်ရိုက်ထည့်ပေးပါ။',
                                                            style: GoogleFonts.padauk(
                                                                color: Colors.black,
                                                                fontSize:
                                                                    MediaQuery.of(bcontext)
                                                                            .size
                                                                            .width /
                                                                        24,
                                                                fontWeight: FontWeight.w800),
                                                            softWrap: false,
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                    Builder(builder: (BuildContext bcontext) {
                                                      return AnimatedPositioned(
                                                        duration: const Duration(seconds: 1),
                                                        curve: Curves.fastOutSlowIn,
                                                        top: MediaQuery.of(bcontext).size.height / 40,
                                                        right: 0,
                                                        left: Provider.of<SubmitData>(bcontext,
                                                                    listen: false)
                                                                .getDateAnimatorCon()
                                                            ? 10 
                                                            : Provider.of<SubmitData>(bcontext,listen: true).getGenderAnimatorCon() ? MediaQuery.of(bcontext)
                                                                    .size
                                                                    .width +
                                                                50
                                                            : -MediaQuery.of(bcontext)
                                                                    .size
                                                                    .width -
                                                                300,
                                                        child: Align(
                                                          alignment: Provider.of<SubmitData>(
                                                                      context,
                                                                      listen: false)
                                                                  .getDateAnimatorCon()
                                                              ? Alignment.center
                                                              : Alignment.topLeft,
                                                          child: Text(
                                                            'မွေးနေ့ကိုထည့်ပေးပါ။',
                                                            style: GoogleFonts.padauk(
                                                                color: Colors.black,
                                                                fontSize:
                                                                    MediaQuery.of(bcontext)
                                                                            .size
                                                                            .width /
                                                                        18,fontWeight: FontWeight.bold),
                                                            softWrap: false,
                                                            
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                    Builder(builder: (BuildContext bcontext) {
                                                      return AnimatedPositioned(
                                                        duration: const Duration(seconds: 1),
                                                        curve: Curves.fastOutSlowIn,
                                                        top: MediaQuery.of(bcontext).size.height / 40,
                                                        right: 0,
                                                        left: Provider.of<SubmitData>(bcontext,
                                                                    listen: true)
                                                                .getGenderAnimatorCon()
                                                            ? MediaQuery.of(bcontext).size.width / 20
                                                            : -MediaQuery.of(bcontext).size.width,
                                                        child: Align(
                                                          alignment: Provider.of<SubmitData>(
                                                                      context,
                                                                      listen: false)
                                                                  .getGenderAnimatorCon()
                                                              ? Alignment.center
                                                              : Alignment.topLeft,
                                                          child: Text(
                                                            'Gender ရွေးပေးပါ။',
                                                            style: GoogleFonts.roboto(
                                                                color: Colors.black,
                                                                fontSize:
                                                                    MediaQuery.of(bcontext)
                                                                            .size
                                                                            .width /
                                                                        20,fontWeight: FontWeight.bold),
                                                            softWrap: false,
                                                            
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                    Form(
                                                      key: _foreginKey,
                                                      child: Builder(builder: (BuildContext bcontext) {
                                                        return AnimatedPositioned(
                                                          duration:
                                                              const Duration(milliseconds: 500),
                                                          curve: Curves.fastOutSlowIn,
                                                          top: MediaQuery.of(bcontext)
                                                                  .size
                                                                  .height /
                                                              15,
                                                          right: 0,
                                                          left: Provider.of<SubmitData>(bcontext,
                                                                      listen: true)
                                                                  .getNameAnimatorCon()
                                                              ? MediaQuery.of(bcontext)
                                                                      .size
                                                                      .width +
                                                                  50
                                                              : namesetcontent
                                                                  ? 0
                                                                  : -MediaQuery.of(bcontext)
                                                                          .size
                                                                          .width /
                                                                      1.1,
                                                          child: Align(
                                                            alignment: namesetcontent
                                                                ? Alignment.center
                                                                : Alignment.topLeft,
                                                            child: SizedBox(
                                                                width: 
                                                                MediaQuery.of(bcontext)
                                                                        .size
                                                                        .width /
                                                                    1.4,
                                                              
                                                                child: renderTextField(
                                                                    bcontext, 'name')),
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                    Builder(builder: (BuildContext bcontext) {
                                                      return AnimatedPositioned(
                                                        duration: const Duration(seconds: 1),
                                                        curve: Curves.fastOutSlowIn,
                                                        top: MediaQuery.of(bcontext)
                                                                .size
                                                                .height /
                                                            10,
                                                        right: 0,
                                                        left:  Provider.of<SubmitData>(bcontext,
                                                                    listen: false)
                                                                .getDateAnimatorCon()
                                                            ? 10 
                                                            : Provider.of<SubmitData>(bcontext,listen: true).getGenderAnimatorCon() ? MediaQuery.of(bcontext)
                                                                    .size
                                                                    .width +
                                                                50
                                                            : -MediaQuery.of(bcontext)
                                                                    .size
                                                                    .width  / 2 
                                                                ,
                                                        child: Align(
                                                          alignment: Provider.of<SubmitData>(
                                                                      bcontext,
                                                                      listen: false)
                                                                  .getDateAnimatorCon()
                                                              ? Alignment.center
                                                              : Alignment.topLeft,
                                                          child: Column(
                                                            children: [
                                                              InkWell(
                                                                onTap: () => _selectDate(),
                                                                child: Container(
                                                                  width: MediaQuery.of(bcontext)
                                                                          .size
                                                                          .width /
                                                                      2,
                                                                  height:
                                                                      MediaQuery.of(bcontext)
                                                                              .size
                                                                              .height /
                                                                          15,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors.white,
                                                                      border: Border.all(
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              255, 48, 48, 48)),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5.0)),
                                                                  child: 
                                                                  
                                                                      Center(
                                                                        child: Builder(builder:
                                                                            (BuildContext
                                                                                bcontext) {
                                                                          final selectiondate = Provider
                                                                                  .of<DataProperties>(
                                                                                      bcontext,
                                                                                      listen:
                                                                                          true)
                                                                              .getSelectedDate();
                                                                          return Text(
                                                                              '${selectiondate.day}/${selectiondate.month}/${selectiondate.year}',
                                                                              style: GoogleFonts.roboto(
                                                                                  color: Colors
                                                                                      .black,
                                                                                  fontSize: MediaQuery.of(
                                                                                              bcontext)
                                                                                          .size
                                                                                          .width /
                                                                                      20),softWrap: false,);
                                                                        }),
                                                                      ),
                                                                  
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                    Builder(builder: (BuildContext bcontext) {
                                                      return AnimatedPositioned(
                                                        duration: const Duration(seconds: 1),
                                                        curve: Curves.fastOutSlowIn,
                                                        top: MediaQuery.of(bcontext)
                                                                .size
                                                                .height /
                                                            12,
                                                        right: 
                                                            0,
                                                        left: Provider.of<SubmitData>(bcontext,
                                                                    listen: true)
                                                                .getGenderAnimatorCon()
                                                            ? MediaQuery.of(bcontext).size.width / 20
                                                            : -MediaQuery.of(bcontext)
                                                                    .size
                                                                    .width /
                                                                2,
                                                        child: Align(
                                                          alignment: Provider.of<SubmitData>(
                                                                      bcontext,
                                                                      listen: false)
                                                                  .getGenderAnimatorCon()
                                                              ? Alignment.center
                                                              : Alignment.topLeft,
                                                          child:  Container(
                                                          
                                                            width: MediaQuery.of(bcontext).size.width / 2,
                                                            height: MediaQuery.of(bcontext).size.height / 3,
                                                            decoration: BoxDecoration(
                                                              color: Colors.white.withOpacity(0.4),
                                                              borderRadius : BorderRadius.circular(7.0)
                                                              
                                                            ) ,
                                                            child: Builder(
                                                                  builder: (BuildContext bcontext) {
                                                                return Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment.start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment.start,
                                                                    children: [
                                                                      SizedBox(height: MediaQuery.of(bcontext).size.height / 50),
                                                                      ListTile(
                                                                          title:
                                                                              const Text('Female'),
                                                                          leading:
                                                                              Radio<GenderChoice>(
                                                                            value:
                                                                                GenderChoice.female,
                                                                            fillColor: MaterialStateColor
                                                                                .resolveWith((states) =>
                                                                                    const Color(
                                                                                        0xffCF000F)),
                                                                            groupValue: Provider.of<
                                                                                        DataProperties>(
                                                                                    context,
                                                                                    listen: true)
                                                                                .getSelectedGenderChoice(),
                                                                            onChanged:
                                                                                (GenderChoice?
                                                                                    value) {
                                                                              Provider.of<DataProperties>(
                                                                                      context,
                                                                                      listen: false)
                                                                                  .updateSelectedGenderChoice(
                                                                                      value!);
                                                                            },
                                                                          )),
                                                                      ListTile(
                                                                          title: const Text('Male'),
                                                                          leading:
                                                                              Radio<GenderChoice>(
                                                                            value:
                                                                                GenderChoice.male,
                                                                            groupValue: Provider.of<
                                                                                        DataProperties>(
                                                                                    context,
                                                                                    listen: true)
                                                                                .getSelectedGenderChoice(),
                                                                            fillColor: MaterialStateColor
                                                                                .resolveWith((states) =>
                                                                                    const Color(
                                                                                        0xffCF000F)),
                                                                            onChanged:
                                                                                (GenderChoice?
                                                                                    value) {
                                                                              Provider.of<DataProperties>(
                                                                                      context,
                                                                                      listen: false)
                                                                                  .updateSelectedGenderChoice(
                                                                                      value!);
                                                                            },
                                                                          ))
                                                                    ]);
                                                              }),
                                                          ),
                                                          ),
                                                        
                                                      );
                                                    }) 
                                                  ],
                                                ),
                                              ),
                                              
                                          
                                    
                                    
                                
                                ],
                              ),
                ),
            
                                              namesetcontent
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(right: 20.0,left: 20.0,bottom: 50.0),
                                                      child: SizedBox(
                                                          width: MediaQuery.of(context)
                                                                  .size
                                                                  .width,
                                                          height: MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              15,
                                                          child: Builder(
                                                            builder: (BuildContext statuscontext) {
                                                              return ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                  elevation: 0.0,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(20.0)
                                                                  ),
                                                                  backgroundColor: Provider.of<CheckUserInfoStatus>(statuscontext,listen: true).getNameRequestStatus() == 1 ? 
                                                                      Colors.black : Colors.grey,
                                                                ),
                                                                onPressed: () {
                                                                  if (_foreginKey.currentState!
                                                                      .validate()) {
                                                                    FocusScope.of(statuscontext)
                                                                        .unfocus();
                                                                    if (Provider.of<SubmitData>(
                                                                            statuscontext,
                                                                            listen: false)
                                                                        .getGenderAnimatorCon()) {
                                                  
                                                                      statuscontext.read<AuthServiceCubit>().signUpService(namecontroller.text,Provider.of<DataProperties>(statuscontext,listen: false).getSelectedGenderChoice() == GenderChoice.male ? 'male' : 'female',
                                                                      Provider.of<DataProperties>(statuscontext,listen: false).getSelectedDate());
                                                                    } else {
                                                                      if (Provider.of<SubmitData>(statuscontext,listen: false).getDateAnimatorCon()) {
                                                                        Provider.of<SubmitData>(
                                                                              statuscontext,
                                                                              listen: false)
                                                                          .updateDateAnimator();
                                                                        Provider.of<SubmitData>(statuscontext,listen: false).updateGenderAnimator();
                                                                      }
                                                                      else {
                                                                        Provider.of<SubmitData>(
                                                                              statuscontext,
                                                                              listen: false)
                                                                          .updateNameAnimator();
                                                                      Provider.of<SubmitData>(
                                                                              statuscontext,
                                                                              listen: false)
                                                                          .updateDateAnimator();
                                                                      }
                                                                      
                                                                    }
                                                                  }
                                                                },
                                                                child: Text('‌ရှေသို့',
                                                                    style: GoogleFonts.padauk(
                                                                        color: Colors.white,
                                                                        fontSize:
                                                                            MediaQuery.of(statuscontext)
                                                                                    .size
                                                                                    .width /
                                                                                20)),
                                                              );
                                                            }
                                                          ),
                                                        ),
                                                      
                                                    )
                                                  : const Text('')
          
              ],
            ),
          ),
          ),
                  
                
              ),
          ),
          ),
        ),
      
    
  

      
    );
  }

  _selectDate() {
    return showModalBottomSheet<void>(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        context: context,
        builder: (BuildContext bcontext) {
          return SizedBox(
              width: MediaQuery.of(bcontext).size.width,
              height: MediaQuery.of(bcontext).size.height / 3,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: (MediaQuery.of(context).size.height / 3) / 6,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.roboto(
                                  color: const Color(0xff4169e1),
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.normal),
                            ),
                            onPressed: () => Navigator.of(context).pop()),
                        TextButton(
                            child: Text(
                              'Ok',
                              style: GoogleFonts.roboto(
                                  color: const Color(0xff4169e1),
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.normal),
                            ),
                            onPressed: () => Navigator.of(context).pop()),
                      ],
                    ),
                  ),
                  Builder(builder: (BuildContext bcontext1) {
                    return SizedBox(
                      width: MediaQuery.of(bcontext1).size.width,
                      height: (MediaQuery.of(context).size.height / 3) -
                          (MediaQuery.of(context).size.height / 3) / 6,
                      child: CupertinoDatePicker(
                        initialDateTime:
                            Provider.of<DataProperties>(bcontext1, listen: true)
                                .getSelectedDate(),
                        mode: CupertinoDatePickerMode.date,
                        use24hFormat: false,
                        minimumDate: DateTime(1922),
                        maximumDate: DateTime(2008),
                        onDateTimeChanged: (DateTime value) {
                          Provider.of<DataProperties>(bcontext1, listen: false)
                              .updateSelectedDate(value);
                        },
                      ),
                    );
                  }),
                ],
              ));
        });
  }

  renderTextField(BuildContext bcontext, String type) {
    return TextFormField(
      focusNode: namefocusNode,
      keyboardType: TextInputType.text,
      autocorrect: false,
      maxLength: 8,
      textDirection: TextDirection.ltr,
      onChanged: (value) {
        if (value.length == 3) {
          Provider.of<CheckUserInfoStatus>(context,listen: false).updateNameRequestStatus();

        }
        else if (value.length < 3) {
          if (Provider.of<CheckUserInfoStatus>(context,listen: false).getNameRequestStatus() == 1) {
            Provider.of<CheckUserInfoStatus>(context,listen: false).updateNameRequestStatus();
          }
        }

      },
      style: GoogleFonts.roboto(
          color: const Color.fromARGB(255, 34, 34, 34),
          fontSize: MediaQuery.of(bcontext).size.width / 18 ,

          decorationThickness: 0),
      controller: namecontroller,

      decoration:const InputDecoration(
            
          enabledBorder:  UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.5),
          ),
          focusedBorder:  UnderlineInputBorder(
            borderSide: BorderSide(color:  Colors.black, width: 1.5),
          ),
          
          
         
          border:  UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black,width: 1.5))),
      obscureText: false,
      cursorColor: Colors.black,
      
     
    );
  }

  @override
  void dispose() {
    namefocusNode.dispose();
    namecontroller.dispose();
    _logotextcontroller.dispose();
    super.dispose();
  }
}
