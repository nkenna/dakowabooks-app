class SaleRecord {
  double? amount;
  double? commission;
  String? status;
  String? channel;
  String? transRef;
  String? transDate;
  String? buyerWalletId;
  String? userBuyerId;
  String? authorId;
  String? literatureId;
  String? buyerWallet;
  UserBuyer? userBuyer;
  LiteratureY? literature;
  String? createdAt;
  String? updatedAt;
  String? id;

  SaleRecord(
      {this.amount,
        this.commission,
        this.status,
        this.channel,
        this.transRef,
        this.transDate,
        this.buyerWalletId,
        this.userBuyerId,
        this.authorId,
        this.literatureId,
        this.buyerWallet,
        this.userBuyer,
        this.literature,
        this.createdAt,
        this.updatedAt,
        this.id});

  SaleRecord.fromJson(Map<String, dynamic> json) {
    amount = json['amount'].toDouble();
    commission = json['commission'].toDouble();
    status = json['status'];
    channel = json['channel'];
    transRef = json['transRef'];
    transDate = json['transDate'];
    buyerWalletId = json['buyerWalletId'];
    userBuyerId = json['userBuyerId'];
    authorId = json['authorId'];
    literatureId = json['literatureId'];
    buyerWallet = json['buyerWallet'];
    userBuyer = json['userBuyer'] != null
        ? new UserBuyer.fromJson(json['userBuyer'])
        : null;
    literature = json['literature'] != null
        ? new LiteratureY.fromJson(json['literature'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['commission'] = this.commission;
    data['status'] = this.status;
    data['channel'] = this.channel;
    data['transRef'] = this.transRef;
    data['transDate'] = this.transDate;
    data['buyerWalletId'] = this.buyerWalletId;
    data['userBuyerId'] = this.userBuyerId;
    data['authorId'] = this.authorId;
    data['literatureId'] = this.literatureId;
    data['buyerWallet'] = this.buyerWallet;
    if (this.userBuyer != null) {
      data['userBuyer'] = this.userBuyer!.toJson();
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

class UserBuyer {
  String? firstname;
  String? lastname;
  String? email;
  String? avatar;
  bool? isAuthor;
  String? sId;

  UserBuyer(
      {this.firstname,
        this.lastname,
        this.email,
        this.avatar,
        this.isAuthor,
        this.sId});

  UserBuyer.fromJson(Map<String, dynamic> json) {
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    avatar = json['avatar'];
    isAuthor = json['isAuthor'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['isAuthor'] = this.isAuthor;
    data['_id'] = this.sId;
    return data;
  }
}

class LiteratureY {
  String? title;
  String? author;
  String? sId;

  LiteratureY({this.title, this.author, this.sId});

  LiteratureY.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    author = json['author'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['author'] = this.author;
    data['_id'] = this.sId;
    return data;
  }
}


