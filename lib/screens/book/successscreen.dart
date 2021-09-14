import 'package:dakowabook/screens/landing/landingscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../projectcolors.dart';

class SuccessScreen extends StatefulWidget {
  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: Get.width,
          height: Get.height,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10,),
                child: Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 400,),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text("Your Book Purchase was successful. Open your library to start reading.", style: TextStyle(fontFamily: 'SofiaProMedium', fontSize: 18),),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: SizedBox(
                  width: Get.width,
                  height: 60,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color(0xffe6d0cd)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      )),
                    ),
                    onPressed: () async{
                      Get.offAll(() => LandingScreen(screen: 3,));
                    },
                    child: Text("Go to Library", style: TextStyle( color: mainColor, fontSize: 16, fontFamily: 'SofiaProSemiBold'),),
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
