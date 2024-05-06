import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Logo extends StatefulWidget {
  final double widthratio;
  final double heightratio;
  final double fontsizeratio;
  const Logo({super.key,required this.widthratio, required this.heightratio,required this.fontsizeratio});

  @override
  State<Logo> createState() => _LogoState();
}

class _LogoState extends State<Logo> {
  
  
  @override
  Widget build(BuildContext context) {
    return  Container(
      width: MediaQuery.of(context).size.width / widget.widthratio,
      height: MediaQuery.of(context).size.height / widget.heightratio,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xffe70505),
            Color(0xff7c0404)
          ],

          ),
          borderRadius: BorderRadius.circular(4.0)
      ),
      child: LayoutBuilder(
        builder:(context, constraints) => 
        Center(child: Text("M",style: GoogleFonts.lilitaOne(color: Colors.white,fontSize:constraints.maxWidth * widget.fontsizeratio))))
    );
  }
}