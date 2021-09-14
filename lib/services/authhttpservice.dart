import 'dart:convert';
import 'dart:io';
import 'package:dakowabook/utils/sharedprefs.dart';
import 'package:dio/dio.dart';

import 'package:http_parser/http_parser.dart';

class AuthHttpService {
  static String baseUrl = "https://testbook.dakowa.com/";


  Future<dynamic> signupRequest(String firstName, String lastName, String password, String email,  String phone) async {

    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/user/create-user";
    print(url);
    var dio = Dio();
    try {

      var body = jsonEncode(
          <String, dynamic>{
            "firstname": firstName,
            "lastname": lastName,
            "password": password,
            "phone": phone,
            "email": email
          }
      );
      print(body);

      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: 'application/json',
              //HttpHeaders.authorizationHeader: 'Bearer ' + token
            }
        ),
      );
      print("this response");
      print(response.statusCode);
      print(response);
      return response;
    } on DioError catch (e) {
      return e.response != null ? e.response : null;
    }
  }

  Future<dynamic> loginRequest(String email, String password) async {

    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/user/login-user";
    print(url);
    var dio = Dio();
    try {

      var body = jsonEncode(
          <String, dynamic>{
            "password": password,
            "email": email,
          }
      );
      print(body);

      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: 'application/json',
              //HttpHeaders.authorizationHeader: 'Bearer ' + token
            }
        ),
      );
      print("this response");
      print(response.statusCode);
      print(response);
      return response;
    } on DioError catch (e) {
      return e.response != null ? e.response : null;
    }
  }

  Future<dynamic> verifyUserRequest(String code) async {

    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/user/verify-user";
    print(url);
    var dio = Dio();
    try {

      var body = jsonEncode(
          <String, dynamic>{
            "code": code
          }
      );
      print(body);

      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: 'application/json',
              //HttpHeaders.authorizationHeader: 'Bearer ' + token
            }
        ),
      );
      print("this response");
      print(response.statusCode);
      print(response);
      return response;
    } on DioError catch (e) {
      return e.response != null ? e.response : null;
    }
  }

  Future<dynamic> resendVerficationEmailRequest(String email) async {

    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/user/resend-verify-email";
    print(url);
    var dio = Dio();
    try {

      var body = jsonEncode(
          <String, dynamic>{
            "email": email
          }
      );
      print(body);

      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: 'application/json',
              //HttpHeaders.authorizationHeader: 'Bearer ' + token
            }
        ),
      );
      print("this response");
      print(response.statusCode);
      print(response);
      return response;
    } on DioError catch (e) {
      return e.response != null ? e.response : null;
    }
  }

  Future<dynamic> changePasswordRequest(String currentPassword, String newPassword, String userId) async {

    //String? token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/user/change-password";
    print(url);
    var dio = Dio();
    try {

      var body = jsonEncode(
          <String, dynamic>{
            "currentPassword": currentPassword,
            "newPassword": newPassword,
            "userId": userId
          }
      );
      print(body);

      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: 'application/json',
              //HttpHeaders.authorizationHeader: 'Bearer ' + token!
            }
        ),
      );
      print("this response");
      print(response.statusCode);
      print(response);
      return response;
    } on DioError catch (e) {
      return e.response != null ? e.response : null;
    }
  }


  Future<dynamic> resetPasswordRequest(String email) async {

    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/user/send-reset-email";
    print(url);
    var dio = Dio();
    try {

      var body = jsonEncode(
          <String, dynamic>{
            "email": email,
          }
      );
      print(body);

      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: 'application/json',
              //HttpHeaders.authorizationHeader: 'Bearer ' + token
            }
        ),
      );
      print("this response");
      print(response.statusCode);
      print(response);
      return response;
    } on DioError catch (e) {
      return e.response != null ? e.response : null;
    }
  }

  Future<dynamic> confirmResetPasswordRequest(String password, String code) async {

    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/user/reset-password";
    print(url);
    var dio = Dio();
    try {

      var body = jsonEncode(
          <String, dynamic>{
            "password": password,
            "code": code
          }
      );
      print(body);

      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: 'application/json',
              //HttpHeaders.authorizationHeader: 'Bearer ' + token
            }
        ),
      );
      print("this response");
      print(response.statusCode);
      print(response);
      return response;
    } on DioError catch (e) {
      return e.response != null ? e.response : null;
    }
  }

  Future<dynamic> userProfileRequest(String userId) async {

    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/user/user-profile-by-id";
    print(url);
    var dio = Dio();
    try {

      var body = jsonEncode(
          <String, dynamic>{
            "userId": userId
          }
      );
      print(body);

      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: 'application/json',
              //HttpHeaders.authorizationHeader: 'Bearer ' + token
            }
        ),
      );
      print("this response");
      print(response.statusCode);
      print(response);
      return response;
    } on DioError catch (e) {
      return e.response != null ? e.response : null;
    }
  }

  Future<dynamic> userFundWalletRequest(String userId, String transId) async {

    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/user/fund-wallet";
    print(url);
    var dio = Dio();
    try {

      var body = jsonEncode(
          <String, dynamic>{
            "userId": userId,
            "transId": transId
          }
      );
      print(body);

      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: 'application/json',
              //HttpHeaders.authorizationHeader: 'Bearer ' + token
            }
        ),
      );
      print("this response");
      print(response.statusCode);
      print(response);
      return response;
    } on DioError catch (e) {
      return e.response != null ? e.response : null;
    }
  }

  Future<dynamic> updateDeviceRequest(String token, String deviceModel, String os, String userId) async {


    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/user/update-device";
    print(url);
    var dio = Dio();
    try {

      var body = jsonEncode(
          <String, dynamic>{
            "token": token,
            "deviceModel": deviceModel,
            "os": os,
            "userId": userId
          }
      );
      print(body);

      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: 'application/json',
              //HttpHeaders.authorizationHeader: 'Bearer ' + token
            }
        ),
      );
      print("this response");
      print(response.statusCode);
      print(response);
      return response;
    } on DioError catch (e) {
      return e.response != null ? e.response : null;
    }
  }

  Future<dynamic> addAuthorReviewRequest(String title, String content, double rating, String authorId, String userId) async {


    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/user/add-author-review";
    print(url);
    var dio = Dio();
    try {

      var body = jsonEncode(
          <String, dynamic>{
            "title": title,
            "content": content,
            "rating": rating,
            "authorId": authorId,
            "userId": userId
          }
      );
      print(body);

      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: 'application/json',
              //HttpHeaders.authorizationHeader: 'Bearer ' + token
            }
        ),
      );
      print("this response");
      print(response.statusCode);
      print(response);
      return response;
    } on DioError catch (e) {
      return e.response != null ? e.response : null;
    }
  }

  Future<dynamic> editProfileAvatarRequest(String userId, File file) async {
    print("insode http");
    var url = baseUrl + "api/v1/user/edit-profile-avatar";
    print(url);

    var dio = Dio();
    try {

      dio.options.headers = {
        HttpHeaders.acceptHeader: 'multipart/form-data',
        HttpHeaders.contentTypeHeader: 'multipart/form-data'
      };


      FormData formdata;
      formdata = new FormData.fromMap({
        "userId": userId,
        'avatar': await MultipartFile.fromFile(file.path, contentType: MediaType("image", "png"))
      });


      //print(file.path);
      print(formdata.fields);
      print(formdata.files.first.value.contentType);
      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: formdata,
        options: Options(
            contentType: 'multipart/form-data',
            receiveTimeout: 120000,
            sendTimeout: 120000
        ),
      );
      print("this response");
      print(response.statusCode);
      print(response);

      print("this response ends");
      print("");
      print("");
      print(response.data);
      return response;
    } on DioError catch (e) {

      return e.response != null ? e.response : null;
    }
  }

  Future<dynamic> editProfileRequest(String userId, String firstName, String lastName, String phone) async {

    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/user/edit-profile";
    print(url);
    var dio = Dio();
    try {

      var body = jsonEncode(
          <String, dynamic>{
            "userId": userId,
            "firstname": firstName,
            "lastname": lastName,
            "phone": phone
          }
      );
      print(body);

      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: 'application/json',
              //HttpHeaders.authorizationHeader: 'Bearer ' + token
            }
        ),
      );
      print("this response");
      print(response.statusCode);
      print(response);
      return response;
    } on DioError catch (e) {
      return e.response != null ? e.response : null;
    }
  }

  Future<dynamic> requestPayoutRequest(String userId, double amount) async {

    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/literature/request-payout";
    print(url);
    var dio = Dio();
    try {

      var body = jsonEncode(
          <String, dynamic>{
            "userId": userId,
            "amount": amount
          }
      );
      print(body);

      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: 'application/json',
              //HttpHeaders.authorizationHeader: 'Bearer ' + token
            }
        ),
      );
      print("this response");
      print(response.statusCode);
      print(response);
      return response;
    } on DioError catch (e) {
      return e.response != null ? e.response : null;
    }
  }




}