import 'package:dakowabook/models/category.dart';

import 'literature.dart';

class Library {
  List<Literatures>? literatures;
  String? userId;
  String? user;
  String? createdAt;
  String? updatedAt;
  String? id;

  Library(
      {this.literatures,
        this.userId,
        this.user,
        this.createdAt,
        this.updatedAt,
        this.id});

  Library.fromJson(Map<String, dynamic> json) {
    if (json['literatures'] != null) {
      literatures = [];
      json['literatures'].forEach((v) {
        literatures!.add(new Literatures.fromJson(v));
      });
    }
    userId = json['userId'];
    user = json['user'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.literatures != null) {
      data['literatures'] = this.literatures!.map((v) => v.toJson()).toList();
    }
    data['userId'] = this.userId;
    data['user'] = this.user;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    return data;
  }
}

class Literatures {
  String? title;
  String? author;
  String? synopsis;
  String? content;
  String? isbn;
  bool? isFile;
  bool? isFree;
  bool? isPdf;
  String? bookFile;
  String? coverPic;
  double? amount;
  List<String>? chapters;
  List<String>? views;
  String? userId;
  User? user;
  String? categoryId;
  Category? category;
  String? createdAt;
  String? updatedAt;
  String? id;
  double? avgRating;
  int? ratingCount;
  double? sumRating;
  int? saleCount;
  //List<String>? reviews;
  bool? promoted;

  Literatures(
      {
        this.saleCount,
        this.avgRating,
        this.ratingCount,
        this.sumRating,
        //this.reviews,
        this.title,
        this.author,
        this.synopsis,
        this.content,
        this.isbn,
        this.isFile,
        this.promoted,
        this.isFree,
        this.isPdf,
        this.bookFile,
        this.coverPic,
        this.amount,
        this.chapters,
        this.views,
        this.userId,
        this.user,
        this.categoryId,
        this.category,
        this.createdAt,
        this.updatedAt,
        this.id});

  Literatures.fromJson(Map<String, dynamic> json) {
    saleCount = json['saleCount'] != null ? json['saleCount'] : 0;
    //reviews = json['reviews'] != null ? json['reviews'].cast<String>() : [];
    avgRating = json['avgRating'].toDouble();
    ratingCount = json['ratingCount'];
    sumRating = json['sumRating'].toDouble();
    title = json['title'];
    author = json['author'];
    synopsis = json['synopsis'];
    promoted = json['promoted'];
    content = json['content'];
    isbn = json['isbn'];
    isFile = json['isFile'];
    isFree = json['isFree'];
    isPdf = json['isPdf'];
    bookFile = json['bookFile'];
    coverPic = json['coverPic'];
    amount = json['amount'].toDouble();
    chapters = json['chapters'].cast<String>();
    views = json['views'].cast<String>();
    userId = json['userId'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    categoryId = json['categoryId'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['saleCount'] = this.saleCount;
    data['avgRating'] = this.avgRating;
    data['ratingCount'] = this.ratingCount;
    //data['reviews'] = this.reviews;
    data['title'] = this.title;
    data['promoted'] = this.promoted;
    data['author'] = this.author;
    data['synopsis'] = this.synopsis;
    data['content'] = this.content;
    data['isbn'] = this.isbn;
    data['isFile'] = this.isFile;
    data['isFree'] = this.isFree;
    data['isPdf'] = this.isPdf;
    data['bookFile'] = this.bookFile;
    data['amount'] = this.amount;
    data['coverPic'] = this.coverPic;
    data['chapters'] = this.chapters;
    data['userId'] = this.userId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['categoryId'] = this.categoryId;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['_id'] = this.id;
    return data;
  }
}




