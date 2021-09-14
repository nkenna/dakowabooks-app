import 'dart:io';

import 'package:dakowabook/provider/authprovider.dart';
import 'package:dakowabook/screens/auth/registerscreen.dart';
import 'package:dakowabook/screens/auth/resendemailscreen.dart';
import 'package:dakowabook/screens/landing/landingscreen.dart';
import 'package:dakowabook/utils/loadingcontrol.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../projectcolors.dart';
import 'loginscreen.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  TextEditingController codeController = TextEditingController();

  Widget codeField() => TextFormField(
    onEditingComplete: () => FocusScope.of(context).nextFocus(),
    controller: codeController,
    style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: Colors.black, height: 2.5),
    enableSuggestions: true,
    autocorrect: true,
    keyboardType: TextInputType.emailAddress,
    textInputAction: Platform.isIOS ? TextInputAction.continueAction : TextInputAction.next,
    decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: mainColor, width: 5 ),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: mainColor, width: 2 ),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        //suffixIcon: _validEmail ? Icon(Icons.check, color: Color(0xff02bc4d), size: 16,) : null,
        floatingLabelBehavior: FloatingLabelBehavior.auto,

        labelText: "Code",
        labelStyle: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: Color(0xffa87c91), height: 2.5)
    ),
    onChanged: (value){
      if(value.isNotEmpty){
        if(value.contains("@")){
          print(value.isEmail);
          setState(() {
            // _validEmail = true;
          });
        }else{
          setState(() {
            //_validEmail = false;
          });
        }
      }
    },
    validator: (String? value) {
      if (value!.isEmpty) {
        return 'Please enter phone number';
      }
      return null;
    },

  );



  Widget loginBtn (){
    return SizedBox(
        width: Get.width,
        height: Get.height * 0.06,
        child: Consumer<AuthProvider>(
          builder: (context, aProvider, _){
            return ElevatedButton(
              onPressed: () async{
                if(codeController.text.isEmpty){
                  LoadingControl.showSnackBar("Ouchs!!!", "Please enter valid verification code sent to your email", Icon(Icons.error, color: Colors.white,));
                  return;
                }

                final result = await aProvider.verifyUser(
                    codeController.text
                );

                if(result){
                  Get.to(() => LoginScreen());
                }

              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xff831608)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ))
              ),
              child: aProvider.loginLoading
                  ? CircularProgressIndicator.adaptive(backgroundColor: Colors.white,)
                  : Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text("Submit", style: TextStyle(fontFamily: 'SofiaProMedium', fontSize: 14, color: Colors.white),),
                  ),

                  Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.arrow_forward_rounded, color: Colors.white,)
                  ),

                ],
              ),
            );
          },
        )

    );
  }


  Widget mainContainer(){
    return Container(
        width: Get.width,
        height: Get.height,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: Get.height * 0.06,),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text("Enter your verification code from your email inbox. Check your spam folder before requesting for another code", style: TextStyle(fontFamily: 'MonumentRegular', fontSize: 16, color: Color(0xff831608)),)
            ),
            SizedBox(height: 30,),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: codeField(),
            ),



            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: loginBtn(),
            ),

            Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("No Verification Code? ", style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: mainTextColor),),
                        InkWell(
                            onTap: () => Get.to(() => ResendEmailScreen()),
                            child: Text("Resend Email", style: TextStyle(fontFamily: 'SofiaProSemiBold', fontSize: 14, color: mainTextColor),)),
                      ],
                    ),


                  ],
                )
            ),
          ],
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: mainContainer(),
        )
    );
  }
}
