class Profile {
  String? firstname;
  String? lastname;
  String? phone;
  String? email;
  String? avatar;
  bool? status;
  bool? emailNotif;
  bool? verified;
  bool? isAuthor;
  String? walletRef;
  String? walletId;
  List<String>? literatures;
  String? createdAt;
  String? updatedAt;
  Wallet? wallet;
  String? id;
  double? avgRating;
  int? ratingCount;
  double? sumRating;
  List<String>? reviews;


  Profile(
      {
        this.avgRating,
        this.ratingCount,
        this.sumRating,
        this.reviews,
        this.firstname,
        this.lastname,
        this.phone,
        this.email,
        this.avatar,
        this.status,
        this.emailNotif,
        this.verified,
        this.isAuthor,
        this.walletRef,
        this.walletId,
        this.literatures,
        this.createdAt,
        this.updatedAt,
        this.wallet,
        this.id
      });


  Profile.fromJson(Map<String, dynamic> json) {
    reviews = json['reviews'] != null ? json['reviews'].cast<String>() : [];
    avgRating = json['avgRating'] != null ? json['avgRating'].toDouble() : 0.0;
    ratingCount = json['ratingCount'];
    sumRating = json['sumRating'] != null ? json['sumRating'].toDouble() : 0.0;
    firstname = json['firstname'];
    lastname = json['lastname'];
    phone = json['phone'];
    email = json['email'];
    avatar = json['avatar'];
    status = json['status'];
    emailNotif = json['emailNotif'];
    verified = json['verified'];
    isAuthor = json['isAuthor'];
    walletRef = json['walletRef'];
    walletId = json['walletId'];
    literatures = json['literatures'] != null ? json['literatures'].cast<String>() : [];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];

    wallet =
    json['wallet'] != null ? new Wallet.fromJson(json['wallet']) : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avgRating'] = this.avgRating;
    data['ratingCount'] = this.ratingCount;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['status'] = this.status;
    data['emailNotif'] = this.emailNotif;
    data['verified'] = this.verified;
    data['isAuthor'] = this.isAuthor;
    data['walletRef'] = this.walletRef;
    data['walletId'] = this.walletId;
    data['literatures'] = this.literatures;
    data['reviews'] = this.reviews;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.wallet != null) {
      data['wallet'] = this.wallet!.toJson();
    }
    data['id'] = this.id;
    return data;
  }
}

class Wallet {
  String? walletRef;
  double? balance;
  String? userId;
  String? sId;
  String? user;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Wallet(
      {this.walletRef,
        this.balance,
        this.userId,
        this.sId,
        this.user,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Wallet.fromJson(Map<String, dynamic> json) {
    walletRef = json['walletRef'];
    balance = json['balance'].toDouble();
    userId = json['userId'];

    sId = json['_id'];
    user = json['user'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['walletRef'] = this.walletRef;
    data['balance'] = this.balance;
    data['userId'] = this.userId;
    data['_id'] = this.sId;
    data['user'] = this.user;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}