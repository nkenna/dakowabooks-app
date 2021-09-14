import 'dart:convert';
import 'dart:io';

import 'package:dakowabook/models/profile.dart';
import 'package:dakowabook/screens/auth/verifyscreen.dart';
import 'package:dakowabook/services/authhttpservice.dart';
import 'package:dakowabook/utils/loadingcontrol.dart';
import 'package:dakowabook/utils/responsedata.dart';
import 'package:dakowabook/utils/sharedprefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AuthProvider with ChangeNotifier {
  final AuthHttpService _httpService = AuthHttpService();
  bool _loginLoading = false;
  Profile? _profile;

  bool get loginLoading => _loginLoading;
  Profile? get profile => _profile;

  bool _fundLoading = false;
  bool get fundLoading => _fundLoading;

  bool _reviewLoading = false;
  bool get reviewLoading => _reviewLoading;

  bool _avatarLoading = false;
  bool get avatarLoading => _avatarLoading;

  bool _dataLoading = false;
  bool get dataLoading => _dataLoading;

  setLoginLoading(bool value){
    _loginLoading = value;
    notifyListeners();
  }

  String checkForCountryCode(String phone){

    if(phone.contains("+234")){
      return phone;
    }else if(phone.startsWith("0")){
      phone = "+234" + phone.substring(1);
      return phone;
    }else{
      return "";
    }

  }

  void saveProfile(Profile us){
    SharedPrefs.instance.setUserData(us);
  }

  Future<Profile?> retrieveProfile() async{
    final data = await SharedPrefs.instance.retrieveString("profile");
    if(data != null && data.isNotEmpty){
      //print(data);
      print("usss:: ${data}");
      Profile us = Profile.fromJson(jsonDecode(data));

      if(us != null){
        print("profile should be here:: ${us.email}");
        _profile = us;
      }
      else{
        print("profile usss id null");
      }
      return _profile!;
    }else{
      print("no saved profile");
      return null;
    }

  }


  Future<bool> login (String email, String password) async {
    _loginLoading = true;
    notifyListeners();

    final response = await _httpService.loginRequest(email, password);

    if(response == null){
      _loginLoading = false;
      notifyListeners();
      //LoadingControl.dismissLoading();
      LoadingControl.showSnackBar(
          "Ouchs",
          "It seems you are having network issues. Please check the internet connectivity and try again.",
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );
      return false;
    }

    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    String status = payload['status'] ?? "";

    if (status.toLowerCase() == "success" && statusCode == 200){
      print("the token");
      print(payload['token']);
      print(payload['user']);
      //saveToken(payload['token']);

      SharedPrefs.instance.saveToken("token", payload['token']).then((value) {
        Profile us = Profile.fromJson(payload['user']);
        if(us != null){
          _profile = us;
          saveProfile(us);
        }else{
          print("profile is null");
        }

        _loginLoading = false;
        notifyListeners();
        LoadingControl.showSnackBar(
            "Success",
            "${payload['message']}",
            Icon(Icons.check_box_rounded, color: Colors.green,)
        );

        // Future.delayed(Duration(seconds: 2), () => Get.offAll(() => LandingScreen()));
      });

      return true;

    }
    else if(statusCode == 423){
      _loginLoading = false;
      notifyListeners();
      LoadingControl.showSnackBar(
          "Success",
          "${payload['message']}. Please wait, you will be redirected to account verification screen",
          Icon(Icons.check_box_rounded, color: Colors.green,)
      );

      Future.delayed(Duration(seconds: 5), () => Get.offAll(() => VerifyScreen()));
      return false;
    }
    else{
      _loginLoading = false;
      notifyListeners();
      return ResponseData.httpResponse(payload['message'], statusCode, "");
    }
  }

  Future<bool> signUp (String firstName, String lastName, String password, String email,  String phone) async {
    _loginLoading = true;
    notifyListeners();

    final response = await _httpService.signupRequest(firstName, lastName, password, email, phone);

    if(response == null){
      _loginLoading = false;
      notifyListeners();
      //LoadingControl.dismissLoading();
      LoadingControl.showSnackBar(
          "Ouchs",
          "It seems you are having network issues. Please check the internet connectivity and try again.",
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );
      return false;
    }

    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    String status = payload['status'] ?? "";

    if (status.toLowerCase() == "success" && statusCode == 200){
      _loginLoading = false;
      notifyListeners();
      LoadingControl.showSnackBar(
          "Success",
          "${payload['message']}",
          Icon(Icons.check_box_rounded, color: Colors.green,)
      );

      Future.delayed(Duration(seconds: 3), () => {});

      return true;

    }
    else{
      _loginLoading = false;
      notifyListeners();
      return ResponseData.httpResponse(payload['message'], statusCode, "");
    }
  }

  Future<bool> verifyUser (String code) async {
    _loginLoading = true;
    notifyListeners();

    final response = await _httpService.verifyUserRequest(code);

    if(response == null){
      _loginLoading = false;
      notifyListeners();
      //LoadingControl.dismissLoading();
      LoadingControl.showSnackBar(
          "Ouchs",
          "It seems you are having network issues. Please check the internet connectivity and try again.",
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );
      return false;
    }

    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    String status = payload['status'] ?? "";

    if (status.toLowerCase() == "success" && statusCode == 200){
      _loginLoading = false;
      notifyListeners();
      LoadingControl.showSnackBar(
          "Success",
          "${payload['message']}",
          Icon(Icons.check_box_rounded, color: Colors.green,)
      );

      Future.delayed(Duration(seconds: 2), () => {});

      return true;

    }
    else{
      _loginLoading = false;
      notifyListeners();
      return ResponseData.httpResponse(payload['message'], statusCode, "");
    }
  }

  Future<bool> resendVerificationEmail (String email) async {
    _loginLoading = true;
    notifyListeners();

    final response = await _httpService.resendVerficationEmailRequest(email);

    if(response == null){
      _loginLoading = false;
      notifyListeners();
      //LoadingControl.dismissLoading();
      LoadingControl.showSnackBar(
          "Ouchs",
          "It seems you are having network issues. Please check the internet connectivity and try again.",
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );
      return false;
    }

    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    String status = payload['status'] ?? "";

    if (status.toLowerCase() == "success" && statusCode == 200){
      _loginLoading = false;
      notifyListeners();
      LoadingControl.showSnackBar(
          "Success",
          "${payload['message']}",
          Icon(Icons.check_box_rounded, color: Colors.green,)
      );

      Future.delayed(Duration(seconds: 2), () => {});

      return true;

    }
    else{
      _loginLoading = false;
      notifyListeners();
      return ResponseData.httpResponse(payload['message'], statusCode, "");
    }
  }

  Future<bool> resetPassword (String email) async {
    _loginLoading = true;
    notifyListeners();

    final response = await _httpService.resetPasswordRequest(email);

    if(response == null){
      _loginLoading = false;
      notifyListeners();
      //LoadingControl.dismissLoading();
      LoadingControl.showSnackBar(
          "Ouchs",
          "It seems you are having network issues. Please check the internet connectivity and try again.",
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );
      return false;
    }

    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    String status = payload['status'] ?? "";

    if (status.toLowerCase() == "success" && statusCode == 200){
      _loginLoading = false;
      notifyListeners();
      LoadingControl.showSnackBar(
          "Success",
          "${payload['message']}",
          Icon(Icons.check_box_rounded, color: Colors.green,)
      );

      Future.delayed(Duration(seconds: 2), () => {});

      return true;

    }
    else{
      _loginLoading = false;
      notifyListeners();
      return ResponseData.httpResponse(payload['message'], statusCode, "");
    }
  }

  Future<bool> confirmResetPassword (String password, String code) async {
    _loginLoading = true;
    notifyListeners();

    final response = await _httpService.confirmResetPasswordRequest(password, code);

    if(response == null){
      _loginLoading = false;
      notifyListeners();
      //LoadingControl.dismissLoading();
      LoadingControl.showSnackBar(
          "Ouchs",
          "It seems you are having network issues. Please check the internet connectivity and try again.",
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );
      return false;
    }

    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    String status = payload['status'] ?? "";

    if (status.toLowerCase() == "success" && statusCode == 200){
      _loginLoading = false;
      notifyListeners();
      LoadingControl.showSnackBar(
          "Success",
          "${payload['message']}",
          Icon(Icons.check_box_rounded, color: Colors.green,)
      );

      Future.delayed(Duration(seconds: 2), () => {});

      return true;

    }
    else{
      _loginLoading = false;
      notifyListeners();
      return ResponseData.httpResponse(payload['message'], statusCode, "");
    }
  }

  Future<bool> changePassword (String currentPassword, String newPassword, String userId) async {
    _loginLoading = true;
    notifyListeners();

    final response = await _httpService.changePasswordRequest(currentPassword, newPassword, userId);

    if(response == null){
      _loginLoading = false;
      notifyListeners();
      //LoadingControl.dismissLoading();
      LoadingControl.showSnackBar(
          "Ouchs",
          "It seems you are having network issues. Please check the internet connectivity and try again.",
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );
      return false;
    }

    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    String status = payload['status'] ?? "";

    if (status.toLowerCase() == "success" && statusCode == 200){

      _loginLoading = false;
      notifyListeners();
      LoadingControl.showSnackBar(
          "Success",
          "${payload['message']}",
          Icon(Icons.check_box_rounded, color: Colors.green,)
      );



      return true;

    }
    else{
      _loginLoading = false;
      notifyListeners();
      return ResponseData.httpResponse(payload['message'], statusCode, "");
    }
  }

  Future<bool> getUserProfile (String userId) async {
    //_loginLoading = true;
    //notifyListeners();

    final response = await _httpService.userProfileRequest(userId);

    if(response == null){
      _loginLoading = false;
      notifyListeners();
      //LoadingControl.dismissLoading();
      LoadingControl.showSnackBar(
          "Ouchs",
          "It seems you are having network issues. Please check the internet connectivity and try again.",
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );
      return false;
    }

    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    String status = payload['status'] ?? "";

    if (status.toLowerCase() == "success" && statusCode == 200){
      print("the token");
      print(payload['token']);
      print(payload['user']);

      Profile us = Profile.fromJson(payload['user']);
      if(us != null){
        _profile = us;

        saveProfile(us);
      }else{
        print("profile is null");
      }
      notifyListeners();

      return true;

    }
    else{
      //_loginLoading = false;
      //notifyListeners();
      return ResponseData.httpResponse(payload['message'], statusCode, "");
    }
  }

  Future<bool> fundWallet (String userId, String transId) async {
    _fundLoading = true;
    notifyListeners();

    final response = await _httpService.userFundWalletRequest(userId, transId);

    if(response == null){
      _fundLoading = false;
      notifyListeners();
      //LoadingControl.dismissLoading();
      LoadingControl.showSnackBar(
          "Ouchs",
          "It seems you are having network issues. Please check the internet connectivity and try again.",
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );
      return false;
    }

    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    String status = payload['status'] ?? "";

    if (status.toLowerCase() == "success" && statusCode == 200){
      _fundLoading = false;
      notifyListeners();

      LoadingControl.showSnackBar(
          "Success",
          "${payload['message']}",
          Icon(Icons.check_box_rounded, color: Colors.green,)
      );


      return true;

    }
    else{
      //_loginLoading = false;
      //notifyListeners();
      return ResponseData.httpResponse(payload['message'], statusCode, "");
    }
  }


  Future<bool> addAuthorReview (String title, String content, double rating, String authorId, String userId) async {
    _reviewLoading = true;
    notifyListeners();

    final response = await _httpService.addAuthorReviewRequest(title, content, rating, authorId, userId);

    if(response == null){
      _reviewLoading = false;
      notifyListeners();
      //LoadingControl.dismissLoading();
      LoadingControl.showSnackBar(
          "Ouchs",
          "It seems you are having network issues. Please check the internet connectivity and try again.",
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );
      return false;
    }

    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    String status = payload['status'] ?? "";

    if (status.toLowerCase() == "success" && statusCode == 200){
      _reviewLoading = false;
      notifyListeners();
      Get.back();
      print("ADDED REVIEWWWWWWWWWWWWW");

      LoadingControl.showSnackBar(
          "Success",
          "${payload['message']}",
          Icon(Icons.check_box_rounded, color: Colors.green,)
      );
      return true;

    }
    else{
      _reviewLoading = false;
      notifyListeners();
      return ResponseData.httpResponse(payload['message'], statusCode, "");
    }
  }

  Future<bool> editProfitAvatar(String userId, File file) async {

    _avatarLoading = true;
    notifyListeners();

    final response = await _httpService.editProfileAvatarRequest( userId, file);

    if(response == null){
      _avatarLoading = false;
      notifyListeners();
      //LoadingControl.dismissLoading();
      LoadingControl.showSnackBar(
          "Ouchs",
          "It seems you are having network issues. Please check the internet connectivity and try again.",
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );
      return false;
    }

    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    String status = payload['status'] ?? "";

    if (status.toLowerCase() == "success" && statusCode == 200){

      _avatarLoading = false;
      notifyListeners();

      LoadingControl.showSnackBar(
          "Success",
          "${payload['message']}",
          Icon(Icons.check_box_rounded, color: Colors.green,)
      );


      //Future.delayed(Duration(seconds: 2), () => Get.offAll(() => PublishedBooksScreen()));

      return true;

    }
    else{
      _avatarLoading = false;
      notifyListeners();
      return ResponseData.httpResponse(payload['message'], statusCode, "");
    }
  }

  Future<bool> editProfile(String userId, String firstName, String lastName, String phone) async {

    _dataLoading = true;
    notifyListeners();

    final response = await _httpService.editProfileRequest(userId, firstName, lastName, phone);

    if(response == null){
      _dataLoading = false;
      notifyListeners();
      //LoadingControl.dismissLoading();
      LoadingControl.showSnackBar(
          "Ouchs",
          "It seems you are having network issues. Please check the internet connectivity and try again.",
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );
      return false;
    }

    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    String status = payload['status'] ?? "";

    if (status.toLowerCase() == "success" && statusCode == 200){

      _dataLoading = false;
      notifyListeners();

      LoadingControl.showSnackBar(
          "Success",
          "${payload['message']}",
          Icon(Icons.check_box_rounded, color: Colors.green,)
      );


      //Future.delayed(Duration(seconds: 2), () => Get.offAll(() => PublishedBooksScreen()));

      return true;

    }
    else{
      _dataLoading = false;
      notifyListeners();
      return ResponseData.httpResponse(payload['message'], statusCode, "");
    }
  }

  Future<bool> requestpayout(String userId, double amount) async {

    _dataLoading = true;
    notifyListeners();

    final response = await _httpService.requestPayoutRequest(userId, amount);

    if(response == null){
      _dataLoading = false;
      notifyListeners();
      //LoadingControl.dismissLoading();
      LoadingControl.showSnackBar(
          "Ouchs",
          "It seems you are having network issues. Please check the internet connectivity and try again.",
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );
      return false;
    }

    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    String status = payload['status'] ?? "";

    if (status.toLowerCase() == "success" && statusCode == 200){

      _dataLoading = false;
      notifyListeners();

      LoadingControl.showSnackBar(
          "Success",
          "${payload['message']}",
          Icon(Icons.check_box_rounded, color: Colors.green,)
      );


      //Future.delayed(Duration(seconds: 2), () => Get.offAll(() => PublishedBooksScreen()));

      return true;

    }
    else{
      _dataLoading = false;
      notifyListeners();
      return ResponseData.httpResponse(payload['message'], statusCode, "");
    }
  }

}