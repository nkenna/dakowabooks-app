import 'dart:io';

import 'package:dakowabook/provider/authprovider.dart';
import 'package:dakowabook/screens/auth/loginscreen.dart';
import 'package:dakowabook/screens/auth/verifyscreen.dart';
import 'package:dakowabook/utils/loadingcontrol.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../projectcolors.dart';


class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _passwObscure = true;

  Widget fNameField() => TextFormField(
    onEditingComplete: () => FocusScope.of(context).nextFocus(),
    controller: firstnameController,
    style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: Colors.black, height: 2.5),
    enableSuggestions: true,
    autocorrect: true,
    keyboardType: TextInputType.name,
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

        labelText: "First Name",
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

  Widget lNameField() => TextFormField(
    onEditingComplete: () => FocusScope.of(context).nextFocus(),
    controller: lastnameController,
    style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: Colors.black, height: 2.5),
    enableSuggestions: true,
    autocorrect: true,
    keyboardType: TextInputType.name,
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

        labelText: "Last Name",
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

  Widget phoneField() => TextFormField(
    onEditingComplete: () => FocusScope.of(context).nextFocus(),
    controller: phoneController,
    style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: Colors.black, height: 2.5),
    enableSuggestions: true,
    autocorrect: true,
    keyboardType: TextInputType.name,
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

        labelText: "Phone Number",
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

  Widget emailField() => TextFormField(
    onEditingComplete: () => FocusScope.of(context).nextFocus(),
    controller: emailController,
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

        labelText: "Email",
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
                if(firstnameController.text.isEmpty || lastnameController.text.isEmpty){
                  LoadingControl.showSnackBar("Ouchs!!!", "First Name and Last Name are required", Icon(Icons.error, color: Colors.white,));
                  return;
                }

                if(phoneController.text.isEmpty){
                  LoadingControl.showSnackBar("Ouchs!!!", "valid phone number are required", Icon(Icons.error, color: Colors.white,));
                  return;
                }

                if(emailController.text.isEmpty || passwordController.text.isEmpty){
                  LoadingControl.showSnackBar("Ouchs!!!", "Email and password are required", Icon(Icons.error, color: Colors.white,));
                  return;
                }

                if(emailController.text.isEmail == false){
                  LoadingControl.showSnackBar("Ouchs!!!", "Please enter valid email", Icon(Icons.error, color: Colors.white,));
                  return;
                }

                String phone = aProvider.checkForCountryCode(phoneController.text);
                if(phone == null || phone.isEmpty){
                  LoadingControl.showSnackBar("Ouchs!!!", "Phone number is invalid. Provide valid phone number with country code. e.g. +2348130909999", Icon(Icons.error, color: Colors.white,));
                  return;
                }


                //aProvider.setLoading(true);
                final result = await aProvider.signUp(
                    firstnameController.text,
                    lastnameController.text,
                    passwordController.text,
                    emailController.text,
                    phone);

                if(result){
                  Get.to(() => VerifyScreen());
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
                    child: Text("Sign Up", style: TextStyle(fontFamily: 'SofiaProMedium', fontSize: 14, color: Colors.white),),
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
            SizedBox(height: Get.height * 0.05,),
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
                    Text("Create your free account", style: TextStyle(fontFamily: 'SofiaProSemiBold', fontSize: 24, color: mainTextColor),),
                  ],
                )
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: fNameField(),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: lNameField(),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: phoneField(),
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
                        Text("Already have an account? ", style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: mainTextColor),),
                        InkWell(
                            onTap: () => Get.to(() => LoginScreen()),
                            child: Text("Login", style: TextStyle(fontFamily: 'SofiaProSemiBold', fontSize: 14, color: mainTextColor),)),
                      ],
                    ),


                    //Text("Forgot Password", style: TextStyle(fontFamily: 'SofiaProSemiBold', fontSize: 14, color: mainTextColor))
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
