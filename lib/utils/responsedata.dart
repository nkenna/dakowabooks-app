
import 'package:flutter/material.dart';
import 'loadingcontrol.dart';

class ResponseData {


  static bool httpResponse (String message, int statusCode, String respStatus){
    if(statusCode == 422){
      print("error of 422");
      LoadingControl.showSnackBar(
          "Ouchs!!!",
          message,
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );

      return false;
    }
    else if(statusCode == 500){
      print("error of 500");
      LoadingControl.showSnackBar(
          "Ouchs!!!",
          message,
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );

      return false;
    }
    else if(statusCode == 404){
      print("error of 404");
      LoadingControl.showSnackBar(
          "Ouchs!!!",
          message,
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );

      return false;
    }
    else if(statusCode == 401){
      print("error of 401");
      LoadingControl.showSnackBar(
          "Ouchs!!!",
          message,
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );
      return false;
    }
    else if(statusCode == 403){
      print("error of 403");
      LoadingControl.showSnackBar(
          "Ouchs!!!",
          message,
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );
      return false;
    }
    else if(statusCode == 419){
      print("error of 419");
      LoadingControl.showSnackBar(
          "Ouchs!!!",
          message,
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );
      return false;
    }
    else if(statusCode == 423){
      print("error of 423");
      LoadingControl.showSnackBar(
          "Ouchs!!!",
          message,
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );
      return false;
    }
    else {
      LoadingControl.showSnackBar(
          "Ouchs!!!",
          message == null || message.isEmpty ? "Unknown server error occurred. If it persists, please contact support." : message,
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );

      return false;
    }
  }

  static dynamic httpResponseList (String message, int statusCode){
    if(statusCode == 422){
      print("error of 422");
      LoadingControl.showSnackBar(
          "Ouchs!!!",
          message,
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );

      return null;
    }
    else if(statusCode == 500){
      print("error of 500");
      LoadingControl.showSnackBar(
          "Ouchs!!!",
          message,
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );

      return null;
    }
    else if(statusCode == 404){
      print("error of 404");
      LoadingControl.showSnackBar(
          "Ouchs!!!",
          message,
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );

      return null;
    }
    else if(statusCode == 401){
      print("error of 401");
      LoadingControl.showSnackBar(
          "Ouchs!!!",
          message,
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );
      return null;
    }
    else if(statusCode == 403){
      print("error of 403");
      LoadingControl.showSnackBar(
          "Ouchs!!!",
          message,
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );
      return null;
    }
    else if(statusCode == 419){
      print("error of 419");
      LoadingControl.showSnackBar(
          "Ouchs!!!",
          message,
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );
      return null;
    }
    else if(statusCode == 423){
      print("error of 423");
      LoadingControl.showSnackBar(
          "Ouchs!!!",
          message,
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );
      return null;
    }
    else {
      LoadingControl.showSnackBar(
          "Ouchs!!!",
          message == null || message.isEmpty ? "Unknown server error occurred. If it persists, please contact support." : message,
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );

      return null;
    }
  }


}