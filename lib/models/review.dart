import 'literature.dart';

class Review {
  String? content;
  double? rating;
  String? title;
  String? authorId;
  String? userId;
  User? user;
  User? author;
  Literature? literature;
  String? createdAt;
  String? updatedAt;
  String? id;

  Review(
      {this.content,
        this.rating,
        this.title,
        this.authorId,
        this.userId,
        this.user,
        this.author,
        this.createdAt,
        this.updatedAt,
        this.literature,
        this.id});

  Review.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    rating = json['rating'].toDouble();
    title = json['title'];
    authorId = json['authorId'];
    userId = json['userId'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    author = json['author'] != null ? new User.fromJson(json['author']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    print(json['literature'].runtimeType);
   /* if(json['literature'].runtimeType == String){
      literature = json['literature'];

    }else{
      literature = json['literature'] != null ? new Literature.fromJson(json['literature']) : null;
    }*/

    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['rating'] = this.rating;
    data['title'] = this.title;
    data['authorId'] = this.authorId;
    data['userId'] = this.userId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.author != null) {
      data['author'] = this.author!.toJson();
    }
    if (this.literature != null) {
      data['literature'] = this.literature!.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    return data;
  }
}

