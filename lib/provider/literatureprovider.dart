import 'dart:io';

import 'package:dakowabook/models/advertpackages.dart';
import 'package:dakowabook/models/category.dart';
import 'package:dakowabook/models/library.dart';
import 'package:dakowabook/models/literature.dart';
import 'package:dakowabook/models/profile.dart';
import 'package:dakowabook/models/review.dart';
import 'package:dakowabook/models/salerecord.dart';
import 'package:dakowabook/models/wallettran.dart';
import 'package:dakowabook/screens/me/publishedbooksscreen.dart';
import 'package:dakowabook/services/literaturehttpservice.dart';
import 'package:dakowabook/utils/loadingcontrol.dart';
import 'package:dakowabook/utils/responsedata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as fo;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiteratureProvider with ChangeNotifier {
  final LiteratureHttpService _httpService = LiteratureHttpService();
  bool _searchLoading = false;
  bool get searchLoading => _searchLoading;
  List<Literature> _searchLits = [];
  List<Literature> get searchLits => _searchLits;

  List<Profile> _searchAuthors = [];
  List<Profile> get searchAuthors => _searchAuthors;

  bool _categoryLoading = false;
  bool _categoryLiteratureLoading = false;
  int _categoryLiteratureTotalPages = 0;

  List<Literature> _authorLiteratures = [];
  List<Literature> get authorLiteratures => _authorLiteratures;

  List<Literature> _myLiteratures = [];
  List<Literature> get myLiteratures => _myLiteratures;

  List<Category> _categories = [];

  List<Literature> _categoryLiteratures = [];
  Literature? _selectedLiterature;
  Literature? get selectedLiterature => _selectedLiterature;

  Literatures? _selectedLibraryLiterature;
  Literatures? get selectedLibraryLiterature => _selectedLibraryLiterature;

  List<Profile> _authors = [];
  List<Profile> get authors => _authors;
  bool _authorLoading = false;
  bool get authorLoading => _authorLoading;
  int _authorTotalPages = 0;
  int get authorTotalPages => _authorTotalPages;
  Profile? _selectedAuthor;
  Profile? get selectedAuthor => _selectedAuthor;


  bool get categoryLoading => _categoryLoading;
  bool get categoryLiteratureLoading => _categoryLiteratureLoading;

  bool _newBookLoading = false;
  bool get newBookLoading => _newBookLoading;

  bool _buyBookLoading = false;
  bool get buyBookLoading => _buyBookLoading;

  bool _buyBookLoading2 = false;
  bool get buyBookLoading2 => _buyBookLoading2;

  List<Category> get categories => _categories;
  List<Literature> get categoryLiteratures => _categoryLiteratures;

  List<AdvertPackage> _advertPackages = [];
  List<AdvertPackage> get advertPackages => _advertPackages;

  List<WalletTran> _walletTrans = [];
  List<WalletTran> get walletTrans => _walletTrans;

  int get categoryLiteratureTotalPages => _categoryLiteratureTotalPages;



  Library? _myLibrary;
  Library? get myLibrary => _myLibrary;

  bool _libraryLoading = false;
  bool get libraryLoading => _libraryLoading;

  List<Review> _authorReviews = [];
  List<Review> get authorReviews => _authorReviews;

  List<Review> _bookReviews = [];
  List<Review> get bookReviews => _bookReviews;

  bool _reviewLoading = false;
  bool get reviewLoading => _reviewLoading;

  int _authorReviewTotalPages = 0;
  int get authorReviewTotalPages => _authorReviewTotalPages;

  int _walletTransTotalPages = 0;
  int get walletTransTotalPages => _walletTransTotalPages;

  int _salesRecordTotalPages = 0;
  int get salesRecordTotalPages => _salesRecordTotalPages;

  List<SaleRecord> _salesrecords = [];
  List<SaleRecord> get salesrecords => _salesrecords;

  int _ordersTotalPages = 0;
  int get ordersTotalPages => _ordersTotalPages;

  List<SaleRecord> _orders = [];
  List<SaleRecord> get orders => _orders;

  List<Literature> _dashboardPromotedBooks = [];
  List<Literature> _dashboardRecentBooks = [];
  List<Literature> _dashboardBestSellerBooks = [];
  List<Literature> _dashboardFreeBooks = [];
  List<Profile> _dashBoardAuthors = [];
  List<Literature> _dashboardTopRatedBooks = [];
  List<Literature> _dashBoardDakowaBooks = [];

  List<Literature> get dashboardPromotedBooks => _dashboardPromotedBooks;
  List<Literature> get dashboardRecentBooks => _dashboardRecentBooks;
  List<Literature> get dashboardBestSellerBooks => _dashboardBestSellerBooks;
  List<Literature> get dashboardFreeBooks => _dashboardFreeBooks;
  List<Profile> get dashBoardAuthors => _dashBoardAuthors;
  List<Literature> get dashboardTopRatedBooks => _dashboardTopRatedBooks;
  List<Literature> get dashBoardDakowaBooks => _dashBoardDakowaBooks;

  bool _dashboardLoading = false;
  bool get dashboardLoading => _dashboardLoading;

  setSelectedLiterature(Literature lit){
    _selectedLiterature = lit;
    notifyListeners();
  }

  setSelectedLibraryLiterature(Literatures lit){
    _selectedLibraryLiterature = lit;
    notifyListeners();
  }

  setSelectedAuthor(Profile au){
    _selectedAuthor = au;
    notifyListeners();
  }


   allCategories () async {
     _categoryLoading = true;
    notifyListeners();

    final response = await _httpService.allCategoriesRequest();

    if(response == null){
      _categoryLoading = false;
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
      var data = payload['categories'];
      List<Category> cates = [];
      _categories.clear();

      for(var i = 0; i < data.length; i++){
        try{
          Category cate = Category.fromJson(data[i]);
          cates.add(cate);
        }catch(e){
          print(e);
        }
      }

      _categories = cates;
      _categoryLoading = false;
      notifyListeners();
    }
    else{
      _categoryLoading = false;
      notifyListeners();
      return ResponseData.httpResponseList(payload['message'], statusCode);
    }
  }

    Future<dynamic> allLiteraturesByCategory (int page, String categoryId) async {
      print(categoryId);

      final response = await _httpService.allLiteraturesByCategoryRequest(page, categoryId);

      if(response == null){
        //_categoryLoading = false;
        //notifyListeners();
        LoadingControl.showSnackBar(
            "Ouchs",
            "It seems you are having network issues. Please check the internet connectivity and try again.",
            Icon(Icons.warning_rounded, color: Colors.orange,)
        );
        return null;
      }

      int statusCode = response.statusCode;
      var payload = response.data;
      print(response);
      print(payload);

      String status = payload['status'] ?? "";

      if (status.toLowerCase() == "success" && statusCode == 200){
        var data = payload['literatures'];
        List<Literature> cates = [];
        if(page == 1){
          _categoryLiteratures.clear();
        }
        _categoryLiteratureTotalPages = (payload['total']/50).ceil();

        for(var i = 0; i < data.length; i++){
          try{
            Literature cate = Literature.fromJson(data[i]);
            cates.add(cate);
          }catch(e){
            print(e);
          }
        }

        _categoryLiteratures.addAll(cates);
        //_categoryLoading = false;
        //notifyListeners();
        return _categoryLiteratures;
      }
      else{
        //_categoryLoading = false;
        //notifyListeners();
        return ResponseData.httpResponseList(payload['message'], statusCode);
      }
  }

    Future<dynamic> allAuthors (int page) async {
        //_authorLoading = true;
        //notifyListeners();

        final response = await _httpService.allAuthorsRequest(page);

        if(response == null){
          //_authorLoading = false;
          //notifyListeners();
          //LoadingControl.dismissLoading();
          LoadingControl.showSnackBar(
              "Ouchs",
              "It seems you are having network issues. Please check the internet connectivity and try again.",
              Icon(Icons.warning_rounded, color: Colors.orange,)
          );
          return null;
        }

        int statusCode = response.statusCode;
        var payload = response.data;
        print(response);
        print(payload);

        String status = payload['status'] ?? "";

        if (status.toLowerCase() == "success" && statusCode == 200){
          var data = payload['authors'];
          List<Profile> cates = [];
          if(page == 1){
            _authors.clear();
          }
          _authorTotalPages = (payload['total']/50).ceil();

          for(var i = 0; i < data.length; i++){
            //try{
              Profile cate = Profile.fromJson(data[i]);
              cates.add(cate);
            //}catch(e){
              //print(e);
           // }
          }

          _authors.addAll(cates);
          return _authors;
        }
        else{
          return ResponseData.httpResponseList(payload['message'], statusCode);
        }
    }

    allLiteraturesByAuthor (String authorId) async {
      _authorLoading = true;
      notifyListeners();
      print("is it working");

    final response = await _httpService.allLiteraturesByAuthorRequest(authorId);

    if(response == null){
      _authorLoading = false;
      notifyListeners();
      LoadingControl.showSnackBar(
          "Ouchs",
          "It seems you are having network issues. Please check the internet connectivity and try again.",
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );
      return null;
    }

    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    String status = payload['status'] ?? "";

    if (status.toLowerCase() == "success" && statusCode == 200){
      var data = payload['literatures'];
      List<Literature> cates = [];
      _authorLiteratures.clear();

      for(var i = 0; i < data.length; i++){
        try{
          Literature cate = Literature.fromJson(data[i]);
          cates.add(cate);
        }catch(e){
          print(e);
        }
      }

      _authorLiteratures = cates;
      _authorLoading = false;
      notifyListeners();
    }
    else{
      _authorLoading = false;
      notifyListeners();
      return ResponseData.httpResponseList(payload['message'], statusCode);
    }
  }

    allMyLiteratures (String authorId) async {
    _authorLoading = true;
    notifyListeners();
    print("is it working");

    final response = await _httpService.allLiteraturesByAuthorRequest(authorId);

    if(response == null){
      _authorLoading = false;
      notifyListeners();
      LoadingControl.showSnackBar(
          "Ouchs",
          "It seems you are having network issues. Please check the internet connectivity and try again.",
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );
      return null;
    }

    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    String status = payload['status'] ?? "";

    if (status.toLowerCase() == "success" && statusCode == 200){
      var data = payload['literatures'];
      List<Literature> cates = [];
      _myLiteratures.clear();

      for(var i = 0; i < data.length; i++){
        try{
          Literature cate = Literature.fromJson(data[i]);
          cates.add(cate);
        }catch(e){
          print(e);
        }
      }

      _myLiteratures = cates;
      _authorLoading = false;
      notifyListeners();
    }
    else{
      _authorLoading = false;
      notifyListeners();
      return ResponseData.httpResponseList(payload['message'], statusCode);
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
      File file
      ) async {

    _newBookLoading = true;
    notifyListeners();

    final response = await _httpService.createLiteratureFileRequest(title, bookAuthor, synopsis, content, isbn, isFree, amount, isFile, published, categoryId, userId, file);

    if(response == null){
      _newBookLoading = false;
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

      _newBookLoading = false;
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
      _newBookLoading = false;
      notifyListeners();
      return ResponseData.httpResponse(payload['message'], statusCode, "");
    }
  }


  Future<dynamic> uploadLiteratureCoverRequest(String literatureId, File file) async {

    _newBookLoading = true;
    notifyListeners();

    final response = await _httpService.uploadLiteratureCoverRequest(literatureId, file);

    if(response == null){
      _newBookLoading = false;
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

      _newBookLoading = false;
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
      _newBookLoading = false;
      notifyListeners();
      return ResponseData.httpResponse(payload['message'], statusCode, "");
    }
  }


  Future<dynamic> viewLiteratureRequest(String userViewerId, String literatureViewedId) async {

    //_newBookLoading = true;
    //notifyListeners();

    final response = await _httpService.viewLiteratureRequest(userViewerId, literatureViewedId);

    if(response == null){
      //_newBookLoading = false;
      //notifyListeners();
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

      //_newBookLoading = false;
      //notifyListeners();

      //LoadingControl.showSnackBar(
      //    "Success",
      //    "${payload['message']}",
      //    Icon(Icons.check_box_rounded, color: Colors.green,)
      //);


      //Future.delayed(Duration(seconds: 2), () => Get.offAll(() => PublishedBooksScreen()));

      return true;

    }
    else{
      //_newBookLoading = false;
      //notifyListeners();
      return ResponseData.httpResponse(payload['message'], statusCode, "");
    }
  }

  Future<bool> buyBookFree (String userId, String literatureId) async {
    _buyBookLoading = true;
    notifyListeners();

    final response = await _httpService.buyBookFreeRequest(userId, literatureId);

    if(response == null){
      _buyBookLoading = false;
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
      _buyBookLoading = false;
      notifyListeners();

      LoadingControl.showSnackBar(
          "Success",
          "${payload['message']}",
          Icon(Icons.check_box_rounded, color: Colors.green,)
      );


      return true;

    }
    else{
      _buyBookLoading = false;
      notifyListeners();
      return ResponseData.httpResponse(payload['message'], statusCode, "");
    }
  }

  Future<bool> buyBookCard (String userId, String literatureId, String transId) async {
    _buyBookLoading = true;
    notifyListeners();

    final response = await _httpService.buyBookCardRequest(userId, literatureId, transId);

    if(response == null){
      _buyBookLoading = false;
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
      _buyBookLoading = false;
      notifyListeners();

      LoadingControl.showSnackBar(
          "Success",
          "${payload['message']}",
          Icon(Icons.check_box_rounded, color: Colors.green,)
      );


      return true;

    }
    else{
      _buyBookLoading = false;
      notifyListeners();
      return ResponseData.httpResponse(payload['message'], statusCode, "");
    }
  }

  Future<bool> buyBookWallet (String userId, String literatureId, String walletId, double bookAmount) async {
    _buyBookLoading2 = true;
    notifyListeners();

    final response = await _httpService.buyBookWalletRequest(userId, literatureId, walletId, bookAmount);

    if(response == null){
      _buyBookLoading2 = false;
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
      _buyBookLoading2 = false;
      notifyListeners();

      LoadingControl.showSnackBar(
          "Success",
          "${payload['message']}",
          Icon(Icons.check_box_rounded, color: Colors.green,)
      );


      return true;

    }
    else{
      _buyBookLoading2 = false;
      notifyListeners();
      return ResponseData.httpResponse(payload['message'], statusCode, "");
    }
  }

  Future<dynamic> myLibraryRequest(String userId) async {

    _libraryLoading = true;
    notifyListeners();

    final response = await _httpService.myLibraryRequest(userId);

    if(response == null){
      _libraryLoading = false;
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

      _libraryLoading = false;
      notifyListeners();

      //try{
        Library libr = Library.fromJson(payload['libraryData']);
        _myLibrary = libr;
        _myLibrary!.literatures = _myLibrary!.literatures!.reversed.toList();
        notifyListeners();
      //}catch(e){
      //  print(e);
      //}

      return true;

    }
    else{
      _libraryLoading = false;
      notifyListeners();
      return ResponseData.httpResponse(payload['message'], statusCode, "");
    }
  }

  Future<dynamic> allAuthorReviews (int page, String authorId) async {
    //_authorLoading = true;
    //notifyListeners();

    final response = await _httpService.allAuthorReviewsRequest(page, authorId);

    if(response == null){
      //_authorLoading = false;
      //notifyListeners();
      //LoadingControl.dismissLoading();
      LoadingControl.showSnackBar(
          "Ouchs",
          "It seems you are having network issues. Please check the internet connectivity and try again.",
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );
      return null;
    }

    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    String status = payload['status'] ?? "";

    if (status.toLowerCase() == "success" && statusCode == 200){
      var data = payload['reviews'];
      List<Review> cates = [];
      if(page == 1){
        _authorReviews.clear();
      }
      _authorReviewTotalPages = (payload['total']/50).ceil();

      for(var i = 0; i < data.length; i++){
        //try{
        Review cate = Review.fromJson(data[i]);
        cates.add(cate);
        //}catch(e){
        //print(e);
        // }
      }

      _authorReviews.addAll(cates);
      return _authorReviews;
    }
    else{
      return ResponseData.httpResponseList(payload['message'], statusCode);
    }
  }

  Future<dynamic> allBookReviews (int page, String literatureId) async {
    //_authorLoading = true;
    //notifyListeners();

    final response = await _httpService.allLiteratureReviewsRequest(page, literatureId);

    if(response == null){
      //_authorLoading = false;
      //notifyListeners();
      //LoadingControl.dismissLoading();
      LoadingControl.showSnackBar(
          "Ouchs",
          "It seems you are having network issues. Please check the internet connectivity and try again.",
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );
      return null;
    }

    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    String status = payload['status'] ?? "";

    if (status.toLowerCase() == "success" && statusCode == 200){
      var data = payload['reviews'];
      List<Review> cates = [];
      if(page == 1){
        _bookReviews.clear();
      }
      _authorReviewTotalPages = (payload['total']/50).ceil();

      for(var i = 0; i < data.length; i++){
        //try{
        Review cate = Review.fromJson(data[i]);
        cates.add(cate);
        //}catch(e){
        //print(e);
        // }
      }

      _bookReviews.addAll(cates);
      return _bookReviews;
    }
    else{
      return ResponseData.httpResponseList(payload['message'], statusCode);
    }
  }

  Future<bool> addLiteratureReview (String title, String content, double rating, String literatureId, String userId) async {
    _reviewLoading = true;
    notifyListeners();

    final response = await _httpService.addLiteratureReviewRequest(title, content, rating, literatureId, userId);

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

  dashboardData() async{
    _dashboardLoading = true;
    notifyListeners();

    final response = await _httpService.allDashboardDataRequest();
    if(response == null){
      _dashboardLoading = false;
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

    if (payload['status'] == 'success' && statusCode == 200){

      _dashboardPromotedBooks = await computeLiteratureData(payload['promotedBooks']);
      _dashboardRecentBooks = await computeLiteratureData(payload['recentBooks']);
      _dashboardBestSellerBooks = await computeLiteratureData(payload['bestSellerBooks']);
      _dashboardFreeBooks = await computeLiteratureData(payload['freeBooks']);
      _dashBoardAuthors = await computeAuthorData(payload['featuredAuthors']);
      _dashboardTopRatedBooks = await computeLiteratureData(payload['topRatedBooks']);
      _dashBoardDakowaBooks = await computeLiteratureData(payload['dakowaBooks']);

      _dashboardLoading = false;
      notifyListeners();

      return null;


    }
    else{
      _dashboardLoading = false;
      notifyListeners();
      return ResponseData.httpResponse(payload['message'], statusCode, "");
    }

  }


  Future<bool> editLiterature (
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
    _newBookLoading = true;
    notifyListeners();

    final response = await _httpService.editLiteratureRequest(title, bookAuthor, synopsis, isbn, isFree, amount, userId, published, categoryId, literatureId);

    if(response == null){
      _newBookLoading = false;
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
      _newBookLoading = false;
      notifyListeners();

      LoadingControl.showSnackBar(
          "Success",
          "${payload['message']}",
          Icon(Icons.check_box_rounded, color: Colors.green,)
      );


      return true;

    }
    else{
      _newBookLoading = false;
      notifyListeners();
      return ResponseData.httpResponse(payload['message'], statusCode, "");
    }
  }

  Future<dynamic> editLiteratureFile(String literatureId, String userId, File file) async {

    _newBookLoading = true;
    notifyListeners();

    final response = await _httpService.editLiteratureFileRequest(literatureId, userId, file);

    if(response == null){
      _newBookLoading = false;
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

      _newBookLoading = false;
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
      _newBookLoading = false;
      notifyListeners();
      return ResponseData.httpResponse(payload['message'], statusCode, "");
    }
  }

  allAdvertPackages () async {
    _categoryLoading = true;
    notifyListeners();

    final response = await _httpService.allAdvertPackagesRequest();

    if(response == null){
      _categoryLoading = false;
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
      var data = payload['packages'];
      List<AdvertPackage> cates = [];
      _advertPackages.clear();

      for(var i = 0; i < data.length; i++){
        try{
          AdvertPackage cate = AdvertPackage.fromJson(data[i]);
          cates.add(cate);
        }catch(e){
          print(e);
        }
      }

      _advertPackages = cates;
      _categoryLoading = false;
      notifyListeners();
    }
    else{
      _categoryLoading = false;
      notifyListeners();
      return ResponseData.httpResponseList(payload['message'], statusCode);
    }
  }

  Future<bool> createPromotion (
      String walletId,
      String packageId,
      String userId,
      String literatureId
      ) async {
    _newBookLoading = true;
    notifyListeners();

    final response = await _httpService.createPromotionRequest(walletId, packageId, userId, literatureId);

    if(response == null){
      _newBookLoading = false;
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
      _newBookLoading = false;
      notifyListeners();

      LoadingControl.showSnackBar(
          "Success",
          "${payload['message']}",
          Icon(Icons.check_box_rounded, color: Colors.green,)
      );


      return true;

    }
    else{
      _newBookLoading = false;
      notifyListeners();
      return ResponseData.httpResponse(payload['message'], statusCode, "");
    }
  }

  Future<dynamic> allWalletTransByWallet (int page, String walletRef) async {
    //_authorLoading = true;
    //notifyListeners();

    final response = await _httpService.walletTransByWalletRequest(page, walletRef);

    if(response == null){
      //_authorLoading = false;
      //notifyListeners();
      //LoadingControl.dismissLoading();
      LoadingControl.showSnackBar(
          "Ouchs",
          "It seems you are having network issues. Please check the internet connectivity and try again.",
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );
      return null;
    }

    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    String status = payload['status'] ?? "";

    if (status.toLowerCase() == "success" && statusCode == 200){
      var data = payload['walletTrans'];
      List<WalletTran> cates = [];
      if(page == 1){
        _walletTrans.clear();
      }
      _walletTransTotalPages = (payload['total']/50).ceil();

      for(var i = 0; i < data.length; i++){
        //try{
          WalletTran cate = WalletTran.fromJson(data[i]);
          cates.add(cate);
         // }catch(e){
         // print(e);
        // }
        }

      _walletTrans.addAll(cates);
        return _walletTrans;
      }

    else{
      return ResponseData.httpResponseList(payload['message'], statusCode);
    }
  }

  Future<dynamic> salesRecordByAuthor (int page, String authorId) async {
    //_authorLoading = true;
    //notifyListeners();

    final response = await _httpService.salesRecordByAuthorRequest(page, authorId);

    if(response == null){
      //_authorLoading = false;
      //notifyListeners();
      //LoadingControl.dismissLoading();
      LoadingControl.showSnackBar(
          "Ouchs",
          "It seems you are having network issues. Please check the internet connectivity and try again.",
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );
      return null;
    }

    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    String status = payload['status'] ?? "";

    if (status.toLowerCase() == "success" && statusCode == 200){
      var data = payload['saleRecords'];
      List<SaleRecord> cates = [];
      if(page == 1){
        _salesrecords.clear();
      }
      _salesRecordTotalPages = (payload['total']/50).ceil();

      for(var i = 0; i < data.length; i++){
        try{
          SaleRecord cate = SaleRecord.fromJson(data[i]);
          cates.add(cate);
        }catch(e){
         print(e);
        }
      }

      _salesrecords.addAll(cates);
      return _salesrecords;
    }

    else{
      return ResponseData.httpResponseList(payload['message'], statusCode);
    }
  }

  Future<dynamic> ordersByUser(int page, String userBuyerId) async {
    //_authorLoading = true;
    //notifyListeners();

    final response = await _httpService.ordersByUserRequest(page, userBuyerId);

    if(response == null){
      //_authorLoading = false;
      //notifyListeners();
      //LoadingControl.dismissLoading();
      LoadingControl.showSnackBar(
          "Ouchs",
          "It seems you are having network issues. Please check the internet connectivity and try again.",
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );
      return null;
    }

    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    String status = payload['status'] ?? "";

    if (status.toLowerCase() == "success" && statusCode == 200){
      var data = payload['bookOrders'];
      List<SaleRecord> cates = [];
      if(page == 1){
        _orders.clear();
      }
      _ordersTotalPages = (payload['total']/50).ceil();

      for(var i = 0; i < data.length; i++){
        try{
          SaleRecord cate = SaleRecord.fromJson(data[i]);
          cates.add(cate);
         }catch(e){
         print(e);
        }
      }

      _orders.addAll(cates);
      return _orders;
    }

    else{
      return ResponseData.httpResponseList(payload['message'], statusCode);
    }
  }

  Future<dynamic> searchForBooks(String query) async {
    _searchLoading = true;
    notifyListeners();

    final response = await _httpService.searchBooksRequest(query);

    if(response == null){
      _searchLoading = false;
      notifyListeners();
      //LoadingControl.dismissLoading();
      LoadingControl.showSnackBar(
          "Ouchs",
          "It seems you are having network issues. Please check the internet connectivity and try again.",
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );
      return null;
    }

    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    String status = payload['status'] ?? "";

    if (status.toLowerCase() == "success" && statusCode == 200){
      var data = payload['literatures'];
      List<Literature> cates = [];
      _searchLits.clear();


      for(var i = 0; i < data.length; i++){
        try{
          Literature cate = Literature.fromJson(data[i]);
          cates.add(cate);
        }catch(e){
          print(e);
        }
      }

      _searchLits = cates;
      _searchLoading = false;
      notifyListeners();
      return _searchLits;
    }

    else{
      _searchLoading = false;
      notifyListeners();
      return ResponseData.httpResponseList(payload['message'], statusCode);
    }
  }

  Future<dynamic> searchForAuthors(String query) async {
    _searchLoading = true;
    notifyListeners();

    final response = await _httpService.searchAuthorsRequest(query);

    if(response == null){
      _searchLoading = false;
      notifyListeners();
      //LoadingControl.dismissLoading();
      LoadingControl.showSnackBar(
          "Ouchs",
          "It seems you are having network issues. Please check the internet connectivity and try again.",
          Icon(Icons.warning_rounded, color: Colors.orange,)
      );
      return null;
    }

    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    String status = payload['status'] ?? "";

    if (status.toLowerCase() == "success" && statusCode == 200){
      var data = payload['authors'];
      List<Profile> cates = [];
      _searchAuthors.clear();


      for(var i = 0; i < data.length; i++){
        try{
          Profile cate = Profile.fromJson(data[i]);
          cates.add(cate);
        }catch(e){
          print(e);
        }
      }

      _searchAuthors = cates;
      _searchLoading = false;
      notifyListeners();
      return _searchAuthors;
    }

    else{
      _searchLoading = false;
      notifyListeners();
      return ResponseData.httpResponseList(payload['message'], statusCode);
    }
  }

}


Future<List<Literature>> computeLiteratureData(dynamic vidData){
  return fo.compute(parseBookData, vidData);
}

List<Literature> parseBookData(dynamic bookData) {
  List<Literature> vids = [];
  final datas = bookData;


  for(var i = 0; i < datas.length; i++){

    try{
      Literature vd = Literature.fromJson(datas[i]);
      vids.add(vd);
    }catch(e){
      print(e);
    }
  }

  return vids;

}

Future<List<Profile>> computeAuthorData(dynamic vidData){
  return fo.compute(parseAuthorData, vidData);
}

List<Profile> parseAuthorData(dynamic bookData) {
  List<Profile> vids = [];
  final datas = bookData;


  for(var i = 0; i < datas.length; i++){

    try{
      Profile vd = Profile.fromJson(datas[i]);
      vids.add(vd);
    }catch(e){
      print(e);
    }
  }

  return vids;

}




