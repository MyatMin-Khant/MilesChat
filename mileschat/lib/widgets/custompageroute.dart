import 'package:flutter/material.dart';


class CustomPageRoute extends PageRouteBuilder {
  final Widget child;
  final double sidepos;
  CustomPageRoute({required this.child,required this.sidepos}): super(
    transitionDuration:  const Duration(milliseconds:  300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    pageBuilder : (context,animation,secondaryAnimation) => child
  );
  @override
  Widget buildTransitions(BuildContext context,Animation<double> animation,
  Animation<double> secondaryAnimation,Widget child) => SlideTransition(position: Tween<Offset>(
    begin: Offset(sidepos,0),
    end: Offset.zero

  ).animate(animation) ,
  child: child);

}

