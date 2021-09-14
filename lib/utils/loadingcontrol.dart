import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../projectcolors.dart';

class LoadingControl {
  static String msg = "Please wait....";
  
  /*static showLoading(){
    EasyLoading.show(status: msg);
  }

  static dismissLoading(){
    EasyLoading.dismiss(animation: true);
  }*/

  static showSnackBar(String title, String msg, Widget icon){
    Get.snackbar(
      title,
      msg,
      backgroundColor: mainColor,
      colorText: Colors.white,
      shouldIconPulse: true,
      icon: icon,
      duration: Duration(seconds: 5),
      snackPosition: SnackPosition.BOTTOM
    );
  }
}

class RoleData {
  String? role;
  bool? selected;

  RoleData({this.role, this.selected = false});
}