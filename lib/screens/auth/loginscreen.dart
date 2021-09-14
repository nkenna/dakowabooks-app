import 'dart:io';

import 'package:dakowabook/provider/authprovider.dart';
import 'package:dakowabook/screens/auth/forgotpasswordscreen.dart';
import 'package:dakowabook/screens/auth/registerscreen.dart';
import 'package:dakowabook/screens/landing/landingscreen.dart';
import 'package:dakowabook/utils/loadingcontrol.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../projectcolors.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _passwObscure = true;

  Widget emailField() => TextFormField(
    onEditingComplete: () => FocusScope.of(context).nextFocus(),
    controller: emailController,
    style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: mainTextColor, height: 2.5),
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

        labelText: "Email",
        labelStyle: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: mainColor, height: 2.5)
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
    style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: mainTextColor, height: 2.5),
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
        labelStyle: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: mainColor, height: 2.5)


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
                if(emailController.text.isEmpty || passwordController.text.isEmpty){
                  LoadingControl.showSnackBar("Ouchs!!!", "Email and password are required", Icon(Icons.error, color: Colors.white,));
                  return;
                }


                //aProvider.setLoading(true);
                final result = await aProvider.login(emailController.text, passwordController.text);

                if(result){
                  print(result);
                  aProvider.retrieveProfile().then((value) => aProvider.getUserProfile(aProvider.profile!.id!));
                  Get.offAll(() => LandingScreen());
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
                    child: Text("Sign In", style: TextStyle(fontFamily: 'JakartaMedium', fontSize: 14, color: Colors.white),),
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: Get.height * 0.06,),
            Image.asset("assets/images/logopurple_cropped.png", width: Get.width * 0.5, height: Get.height * 0.2,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Dakowa Books", style: TextStyle(fontFamily: 'MonumentRegular', fontSize: 20, color: Color(0xff831608)),)
              ],
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Welcome back, Login", style: TextStyle(fontFamily: 'SofiaProSemiBold', fontSize: 24, color: mainTextColor),),
                ],
              )
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: emailField(),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: passwordField(),
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
                      Text("New User? ", style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: mainTextColor),),
                      InkWell(
                          onTap: () => Get.to(() => RegisterScreen()),
                          child: Text("Sign Up", style: TextStyle(fontFamily: 'SofiaProSemiBold', fontSize: 14, color: mainTextColor),)),
                    ],
                  ),


                  InkWell(
                      onTap: () => Get.to(() => ForgotPasswordScreen()),
                      child: Text("Forgot Password", style: TextStyle(fontFamily: 'SofiaProSemiBold', fontSize: 14, color: mainTextColor)))
                ],
              )
            ),
          ],
        ),
      ),
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
