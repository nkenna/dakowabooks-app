import 'dart:io';

import 'package:dakowabook/provider/authprovider.dart';
import 'package:dakowabook/screens/auth/loginscreen.dart';
import 'package:dakowabook/utils/loadingcontrol.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../projectcolors.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController codeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _passwObscure = true;

  Widget codeField() => TextFormField(
    onEditingComplete: () => FocusScope.of(context).nextFocus(),
    controller: codeController,
    style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: mainTextColor, height: 2.5),
    keyboardType: TextInputType.text,
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
        labelStyle: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: mainTextColor, height: 2.5)
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

  TextFormField passwordField() => TextFormField(
    onEditingComplete: () => FocusScope.of(context).unfocus(),
    controller: passwordController,
    style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: Colors.black, height: 2.5),
    enableSuggestions: false,

    keyboardType: TextInputType.text,
    obscureText: _passwObscure,
    textInputAction: TextInputAction.done,
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
        suffixIcon: IconButton(
          icon: Icon(_passwObscure ? Icons.visibility_off : Icons.visibility, color: mainColor, size: 16,),
          onPressed: (){
            print(_passwObscure);
            if(_passwObscure){
              setState(() {
                _passwObscure = false;
              });
            }else{
              setState(() {
                _passwObscure = true;
              });
            }
          },
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        //errorStyle: TextStyle(fontSize: 12, color: errorTextColor),
        labelText: "Password",
        labelStyle: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: Color(0xffa87c91), height: 2.5)


    ),
    validator: (value) {
      if (value!.isEmpty) {
        return 'Please enter password';
      }
      return null;
    },

  );




  Widget loginBtn (){
    return SizedBox(
        width: Get.width,
        height: Get.height *0.06,
        child: Consumer<AuthProvider>(
          builder: (context, aProvider, _){
            return ElevatedButton(
              onPressed: () async{
                if(codeController.text.isEmpty || passwordController.text.isEmail) {
                  LoadingControl.showSnackBar("Ouchs!!!", "Please enter valid password and reset code sent to your email", Icon(Icons.error, color: Colors.white,));
                  return;
                }

                final result = await aProvider.confirmResetPassword(
                    passwordController.text,
                  codeController.text
                );

                if(result){
                  Get.to(() => LoginScreen());
                }


              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(mainColor),
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
                child: Text("Enter your email to receive password reset code", style: TextStyle(fontFamily: 'MonumentRegular', fontSize: 16, color: Color(0xff831608)),)
            ),
            SizedBox(height: 30,),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: codeField(),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: passwordField(),
            ),



            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: loginBtn(),
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
