import 'package:flutter/material.dart';

class TVFrameRender extends StatefulWidget {
  final Widget? childwidget;
  const TVFrameRender({super.key,required this.childwidget});

  @override
  State<TVFrameRender> createState() => _TVFrameRenderState();
}

class _TVFrameRenderState extends State<TVFrameRender> {
  
  @override
  Widget build(BuildContext context) {
    return 
      
      SizedBox(
        width: MediaQuery.of(context).size. width,
                  height: (MediaQuery.of(context). size.height / 2 -
                    MediaQuery.of(context).size.height / 13) +
                    MediaQuery.of(context).size.height / 15,
        child: Stack(
          children: [
           
            Positioned(
              top: 0,
              left: 0,right: 0,
              child: Container(
                width: MediaQuery.of(context).size. width,
                  height: (MediaQuery.of(context). size.height / 2 -
                    MediaQuery.of(context).size.height / 13) +
                    MediaQuery.of(context).size.height / 15,
            
                    decoration: BoxDecoration(
                  
                      color: const Color.fromARGB(255, 31, 31, 31),
                      border: Border(
                        // 
                        top: BorderSide(width: MediaQuery.of(context).size.height / 16,color:const Color.fromARGB(255, 95, 95, 95) ),
                        left: BorderSide(width: MediaQuery.of(context).size.width / 30,color: const Color(0xff464646)),
                        right: BorderSide(width: MediaQuery.of(context).size.width / 30,color: const Color(0xff464646)),
                        bottom: BorderSide(width: MediaQuery.of(context).size.height / 16 ,color: const Color.fromARGB(255, 95, 95, 95))
                      ),
                    
                    ),
                    child:  null
                    
              ),
            ),
             Positioned(
              top: MediaQuery.of(context).size.height / 19,
              left: MediaQuery.of(context).size.width / 38,
              right: MediaQuery.of(context).size.width / 38,
              child:  Container(
                width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width / 60,
                height: ((MediaQuery.of(context). size.height / 2 -
                    MediaQuery.of(context).size.height / 13) +
                    MediaQuery.of(context).size.height / 15) - MediaQuery.of(context).size.height / 10,
                    decoration:  BoxDecoration(
                      color: const Color.fromARGB(255, 31, 31, 31),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width / 60 ,
                        height : ((MediaQuery.of(context). size.height / 2 -
                      MediaQuery.of(context).size.height / 13) +
                      MediaQuery.of(context).size.height / 15) - MediaQuery.of(context).size.height / 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                      
                      ),
                        child: widget.childwidget,
                    ),
                    
                    
                
              ),
            ),
            
            
           
        )]
      )
      );

    
  }
} 