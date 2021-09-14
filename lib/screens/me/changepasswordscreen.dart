import 'package:dakowabook/provider/authprovider.dart';
import 'package:dakowabook/screens/auth/loginscreen.dart';
import 'package:dakowabook/utils/loadingcontrol.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../projectcolors.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController verifyPasswordController = TextEditingController();
  bool _currentPasswObscure = true;
  bool _newPasswObscure = true;
  bool _verifyPasswObscure = true;

  TextFormField currentPasswordField() => TextFormField(
    onEditingComplete: () => FocusScope.of(context).unfocus(),
    controller: currentPasswordController,
    style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: mainTextColor, height: 2.5),
    enableSuggestions: false,

    keyboardType: TextInputType.text,
    obscureText: _currentPasswObscure,
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
          icon: Icon(_currentPasswObscure ? Icons.visibility_off : Icons.visibility, color: mainColor, size: 16,),
          onPressed: (){
            print(_currentPasswObscure);
            if(_currentPasswObscure){
              setState(() {
                _currentPasswObscure = false;
              });
            }else{
              setState(() {
                _currentPasswObscure = true;
              });
            }
          },
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        //errorStyle: TextStyle(fontSize: 12, color: errorTextColor),
        labelText: "Old Password",
        labelStyle: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: mainColor, height: 2.5)


    ),
    validator: (value) {
      if (value!.isEmpty) {
        return 'Please enter password';
      }
      return null;
    },

  );

  TextFormField newPasswordField() => TextFormField(
    onEditingComplete: () => FocusScope.of(context).unfocus(),
    controller: newPasswordController,
    style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: mainTextColor, height: 2.5),
    enableSuggestions: false,

    keyboardType: TextInputType.text,
    obscureText: _newPasswObscure,
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
          icon: Icon(_newPasswObscure ? Icons.visibility_off : Icons.visibility, color: mainColor, size: 16,),
          onPressed: (){
            print(_newPasswObscure);
            if(_newPasswObscure){
              setState(() {
                _newPasswObscure = false;
              });
            }else{
              setState(() {
                _newPasswObscure = true;
              });
            }
          },
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        //errorStyle: TextStyle(fontSize: 12, color: errorTextColor),
        labelText: "New Password",
        labelStyle: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: mainColor, height: 2.5)


    ),
    validator: (value) {
      if (value!.isEmpty) {
        return 'Please enter password';
      }
      return null;
    },

  );

  TextFormField verifyPasswordField() => TextFormField(
    onEditingComplete: () => FocusScope.of(context).unfocus(),
    controller: verifyPasswordController,
    style: TextStyle(fontFamily: 'SofiaProRegular', fontSize: 14, color: mainTextColor, height: 2.5),
    enableSuggestions: false,

    keyboardType: TextInputType.text,
    obscureText: _verifyPasswObscure,
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
          icon: Icon(_verifyPasswObscure ? Icons.visibility_off : Icons.visibility, color: mainColor, size: 16,),
          onPressed: (){
            print(_verifyPasswObscure);
            if(_verifyPasswObscure){
              setState(() {
                _verifyPasswObscure = false;
              });
            }else{
              setState(() {
                _verifyPasswObscure = true;
              });
            }
          },
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        //errorStyle: TextStyle(fontSize: 12, color: errorTextColor),
        labelText: "Verify Password",
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
                if(currentPasswordController.text.isEmpty){
                  LoadingControl.showSnackBar("Ouchs!!!", "Your current password is needed", Icon(Icons.error, color: Colors.white,));
                  return;
                }

                if(newPasswordController.text != verifyPasswordController.text){
                  LoadingControl.showSnackBar("Ouchs!!!", "Password mismatch", Icon(Icons.error, color: Colors.white,));
                  return;
                }
                
                final resp = await aProvider.changePassword(currentPasswordController.text, newPasswordController.text, aProvider.profile!.id!);

                if(resp){
                  Future.delayed(Duration(seconds: 2), (){});
                  Get.offAll(() => LoginScreen());
                }
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xff831608)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ))
              ),
              child: false//aProvider.loading
                  ? CircularProgressIndicator.adaptive(backgroundColor: Colors.white,)
                  : Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text("Save", style: TextStyle(fontFamily: 'JakartaMedium', fontSize: 14, color: Colors.white),),
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
                child: Text("Change Password", style: TextStyle(fontFamily: 'MonumentRegular', fontSize: 16, color: Color(0xff831608)),)
            ),
            SizedBox(height: 30,),


            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: currentPasswordField(),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: newPasswordField(),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: verifyPasswordField(),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: loginBtn(),
            ),


          ],
        ),

    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Change Password", style: TextStyle(fontFamily: 'MonumentRegular', fontSize: 14),),
          ),
          body: mainContainer(),
        )
    );
  }
}
