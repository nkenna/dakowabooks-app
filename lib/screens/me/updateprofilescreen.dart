import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dakowabook/provider/authprovider.dart';
import 'package:dakowabook/services/authhttpservice.dart';
import 'package:dakowabook/utils/loadingcontrol.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../projectcolors.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  PlatformFile? _file;
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      //print(widget.editLiterature.category!.id);
      var profile = Provider.of<AuthProvider>(context,listen: false).profile;
      firstnameController.text = profile != null ? profile.firstname! : "";
      lastnameController.text = profile != null ? profile.lastname! : "";
      phoneController.text = profile != null ? profile.phone! : "";

      setState(() {});
    }
    );
  }


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


  );





  Widget loginBtn (){
    return SizedBox(
        width: Get.width,
        height: Get.height *0.06,
        child: Consumer<AuthProvider>(
          builder: (context, aProvider, _){
            return ElevatedButton(
              onPressed: () async{
                if(phoneController.text.contains("+") == false && phoneController.text.startsWith("+")){
                  LoadingControl.showSnackBar("Ouchs!!!", "Invalid phone number. Please include your country code", Icon(Icons.error, color: Colors.white,));
                  return;
                }

                final resp = await Provider.of<AuthProvider>(context,listen: false).editProfile(
                    Provider.of<AuthProvider>(context,listen: false).profile!.id!,
                    firstnameController.text,
                    lastnameController.text,
                    phoneController.text
                );

                if(resp){
                  Provider.of<AuthProvider>(context,listen: false).getUserProfile(
                      Provider.of<AuthProvider>(context,listen: false).profile!.id!
                  );
                }


              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xff831608)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ))
              ),
              child: aProvider.dataLoading
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            SizedBox(height: 30,),

            InkWell(
              onTap: () async{
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.image
                );

                if(result != null) {
                  PlatformFile file = result.files.first;
                  _file = file;
                  setState(() {});
                  final resp = await Provider.of<AuthProvider>(context,listen: false).editProfitAvatar(
                      Provider.of<AuthProvider>(context,listen: false).profile!.id!,
                      File(_file!.path)
                  );

                  if(resp){
                    Provider.of<AuthProvider>(context,listen: false).getUserProfile(
                        Provider.of<AuthProvider>(context,listen: false).profile!.id!
                    );
                  }

                } else {
                  // User canceled the picker
                }
              },
              child: _file != null
              ? Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: mainTextColor, width: 2),
                    image: DecorationImage(
                        image: FileImage(File(_file!.path)),
                      fit: BoxFit.cover
                    )
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 9,
                      bottom: 0.5,
                      //alignment: Alignment.center,
                      child: Icon(Icons.camera_alt, size: 42, color: mainColor,),
                    ),

                    Align(
                      alignment: Alignment.center,
                      child: Provider.of<AuthProvider>(context,listen: true).avatarLoading
                      ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator.adaptive(backgroundColor: Colors.white,),
                      )
                      : Container(),
                    )
                  ],
                ),
              )
              : CachedNetworkImage(
                imageUrl: AuthHttpService.baseUrl + "${Provider.of<AuthProvider>(context, listen: false).profile!.avatar}",//"${aProvider.profile!.avatar}",
                imageBuilder: (context, imageProvider) => Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: mainTextColor, width: 2),
                      image: DecorationImage(
                          image: AssetImage("assets/images/logored.png")
                      )
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: 9,
                        bottom: 0.5,
                        //alignment: Alignment.center,
                        child: Icon(Icons.camera_alt, size: 42, color: mainColor,),
                      )
                    ],
                  ),
                ),
                //placeholder: (context, url) => CircularProgressIndicator(),
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) =>
                    Container(
                        width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: mainTextColor, width: 2),
                        image: DecorationImage(
                          image: AssetImage("assets/images/logored.png")
                        )
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 9,
                            bottom: 0.5,
                            //alignment: Alignment.center,
                            child: Icon(Icons.camera_alt, size: 42, color: mainColor,),
                          )
                        ],
                      ),
                    ),


              ),
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
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: loginBtn(),
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
          appBar: AppBar(
            title: Text("Update Profile", style: TextStyle(fontFamily: 'MonumentRegular', fontSize: 14),),
          ),
          body: mainContainer(),
        )
    );
  }
}
