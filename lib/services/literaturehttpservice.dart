import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';

class LiteratureHttpService {
  String baseUrl = "https://testbook.dakowa.com/";

  Future<dynamic> allCategoriesRequest() async {

    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/user/all-categories";
    print(url);
    var dio = Dio();
    try {



      dio.options.connectTimeout = 35000;
      Response response = await dio.get(
        url,
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

  Future<dynamic> allLiteraturesByCategoryRequest(int page, String categoryId) async {

    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/literature/book-by-category?page=" + page.toString() + "&categoryId=" + categoryId;
    print(url);
    var dio = Dio();
    try {



      dio.options.connectTimeout = 35000;
      Response response = await dio.get(
        url,
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

  Future<dynamic> allAuthorsRequest(int page) async {

    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/user/all-authors?page=" + page.toString();
    print(url);
    var dio = Dio();
    try {



      dio.options.connectTimeout = 35000;
      Response response = await dio.get(
        url,
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

  Future<dynamic> allLiteraturesByAuthorRequest(String authorId) async {

    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/literature/books-by-author?authorId=" + authorId;
    print(url);
    var dio = Dio();
    try {



      dio.options.connectTimeout = 35000;
      Response response = await dio.get(
        url,
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

  Future<dynamic> createLiteratureFileRequest(
      String title,
      String bookAuthor,
      String synopsis,
      String content,
      String isbn,
      bool isFree,
      double amount,
      bool isFile,
      bool published,
      String categoryId,
      String userId,
      File file) async {
    print("insode http");
    var url = baseUrl + "api/v1/literature/create-book-file";
    print(url);

    var dio = Dio();
    try {

      dio.options.headers = {
        HttpHeaders.acceptHeader: 'multipart/form-data',
        HttpHeaders.contentTypeHeader: 'multipart/form-data'
      };


      FormData formdata;
      formdata = new FormData.fromMap({
        "title": title,
        "bookAuthor": bookAuthor,
        "isbn": isbn,
        "isFree": isFree,
        "amount": amount,
        "isFile": isFile,
        "published": published,
        "userId": userId,
        "categoryId": categoryId,
        "synopsis": synopsis,
        "content": content,
        'bookFile': await MultipartFile.fromFile(file.path, contentType: MediaType("application", "pdf"))
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


  Future<dynamic> uploadLiteratureCoverRequest(
      String literatureId,
      File file) async {
    print("insode http");
    var url = baseUrl + "api/v1/literature/change-book-cover";
    print(url);

    var dio = Dio();
    try {
      dio.options.headers = {
        HttpHeaders.acceptHeader: 'multipart/form-data',
        HttpHeaders.contentTypeHeader: 'multipart/form-data'
      };


      FormData formdata;
      formdata = new FormData.fromMap({
        "literatureId": literatureId,
        'coverPic': await MultipartFile.fromFile(file.path, contentType: MediaType("image", "png"))
      });


      //print(file.path);
      print(formdata.fields);
      print(formdata.files.first.value.contentType);
      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: formdata,
        options: Options(contentType: 'multipart/form-data'),
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

  Future<dynamic> viewLiteratureRequest(String userViewerId, String literatureViewedId) async {

    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/literature/view-book";
    print(url);
    var dio = Dio();
    try {

      var body = jsonEncode(
          <String, dynamic>{
            "userViewerId": userViewerId,
            "literatureViewedId": literatureViewedId
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

  Future<dynamic> buyBookFreeRequest(String userId, String literatureId) async {

    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/literature/buy-free-book";
    print(url);
    var dio = Dio();
    try {

      var body = jsonEncode(
          <String, dynamic>{
            "userId": userId,
            "literatureId": literatureId
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


  Future<dynamic> buyBookCardRequest(String userId, String literatureId, String transId) async {

    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/literature/buy-book-from-card";
    print(url);
    var dio = Dio();
    try {

      var body = jsonEncode(
          <String, dynamic>{
            "userId": userId,
            "literatureId": literatureId,
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

  Future<dynamic> buyBookWalletRequest(String userId, String literatureId, String walletId, double bookAmount) async {

    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/literature/buy-book-from-wallet";
    print(url);
    var dio = Dio();
    try {

      var body = jsonEncode(
          <String, dynamic>{
            "userId": userId,
            "literatureId": literatureId,
            "walletId": walletId,
            "bookAmount": bookAmount
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

  Future<dynamic> myLibraryRequest(String userId) async {

    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/literature/library-books";
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

  Future<dynamic> allAuthorReviewsRequest(int page, String authorId) async {

    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/user/reviews-by-author?page=" + page.toString() + "&authorId=" + authorId;
    print(url);
    var dio = Dio();
    try {



      dio.options.connectTimeout = 35000;
      Response response = await dio.get(
        url,
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

  Future<dynamic> allLiteratureReviewsRequest(int page, String literatureId) async {

    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/literature/reviews-by-book?page=" + page.toString() + "&literatureId=" + literatureId;
    print(url);
    var dio = Dio();
    try {



      dio.options.connectTimeout = 35000;
      Response response = await dio.get(
        url,
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

  Future<dynamic> addLiteratureReviewRequest(String title, String content, double rating, String literatureId, String userId) async {


    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/literature/add-book-review";
    print(url);
    var dio = Dio();
    try {

      var body = jsonEncode(
          <String, dynamic>{
            "title": title,
            "content": content,
            "rating": rating,
            "literatureId": literatureId,
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

  Future<dynamic> allDashboardDataRequest() async {

    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/literature/dashboard-data";
    print(url);
    var dio = Dio();
    try {



      dio.options.connectTimeout = 35000;
      Response response = await dio.get(
        url,
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



  Future<dynamic> editLiteratureRequest(
      String title,
      String bookAuthor,
      String synopsis,
      String isbn,
      bool isFree,
      double amount,
      String userId,
      bool published,
      String categoryId,
      String literatureId

      ) async {

    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/literature/edit-book";
    print(url);
    var dio = Dio();
    try {

      var body = jsonEncode(
          <String, dynamic>{
            "title": title,
            "bookAuthor": bookAuthor,
            "synopsis": synopsis,
            "isbn": isbn,
            "isFree": isFree,
            "amount": amount,
            "userId": userId,
            "published": published,
            "categoryId": categoryId,
            "literatureId": literatureId
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


  Future<dynamic> editLiteratureFileRequest(String literatureId, String userId, File file) async {
    print("insode http");
    var url = baseUrl + "api/v1/literature/edit-book-file";
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
        "literatureId": literatureId,
        'bookFile': await MultipartFile.fromFile(file.path, contentType: MediaType("application", "pdf"))
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


  Future<dynamic> createPromotionRequest(
      String walletId,
      String packageId,
      String userId,
      String literatureId

      ) async {

    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/literature/create-promotion";
    print(url);
    var dio = Dio();
    try {

      var body = jsonEncode(
          <String, dynamic>{
            "literatureId": literatureId,
            "packageId": packageId,
            "userId": userId,
            "walletId": walletId
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

  Future<dynamic> allAdvertPackagesRequest() async {

    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/literature/all-advert-packages";
    print(url);
    var dio = Dio();
    try {



      dio.options.connectTimeout = 35000;
      Response response = await dio.get(
        url,
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


  Future<dynamic> walletTransByWalletRequest(int page, String walletRef) async {

    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/literature/wallet-trans-by-wallet?page=" + page.toString() + "&walletRef=" + walletRef;
    print(url);
    var dio = Dio();
    try {



      dio.options.connectTimeout = 35000;
      Response response = await dio.get(
        url,
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

  Future<dynamic> salesRecordByAuthorRequest(int page, String authorId) async {

    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/literature/sales-record-by-author?page=" + page.toString() + "&authorId=" + authorId;
    print(url);
    var dio = Dio();
    try {



      dio.options.connectTimeout = 35000;
      Response response = await dio.get(
        url,
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

  Future<dynamic> ordersByUserRequest(int page, String userBuyerId) async {

    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/literature/book-orders-by-user?page=" + page.toString() + "&userBuyerId=" + userBuyerId;
    print(url);
    var dio = Dio();
    try {



      dio.options.connectTimeout = 35000;
      Response response = await dio.get(
        url,
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

  Future<dynamic> searchBooksRequest(String query) async {

    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/literature/search-for-books?query=" + query;
    print(url);
    var dio = Dio();
    try {



      dio.options.connectTimeout = 35000;
      Response response = await dio.get(
        url,
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

  Future<dynamic> searchAuthorsRequest(String query) async {

    //String token = await SharedPrefs.instance.retrieveString("token");
    //print("the token");
    //print(token);

    var url = baseUrl + "api/v1/user/search-for-authors?query=" + query;
    print(url);
    var dio = Dio();
    try {



      dio.options.connectTimeout = 35000;
      Response response = await dio.get(
        url,
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