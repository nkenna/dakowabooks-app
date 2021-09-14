import 'package:dakowabook/models/profile.dart';

import 'literature.dart';


class WalletTran {
  String? walletRef;
  double? amount;
  double? commission;
  String? status;
  String? channel;
  String? type;
  String? payerEmail;
  String? transId;
  String? literatureId;
  Wallet? wallet;
  User? user;
  Literaturex? literature;
  String? createdAt;
  String? updatedAt;
  String? id;

  WalletTran(
      {this.walletRef,
        this.amount,
        this.commission,
        this.status,
        this.channel,
        this.type,
        this.payerEmail,
        this.transId,
        this.literatureId,
        this.wallet,
        this.user,
        this.literature,
        this.createdAt,
        this.updatedAt,
        this.id});

  WalletTran.fromJson(Map<String, dynamic> json) {
    walletRef = json['walletRef'];
    amount = json['amount'].toDouble();
    commission = json['commission'].toDouble();
    status = json['status'];
    channel = json['channel'];
    type = json['type'];
    payerEmail = json['payerEmail'];
    transId = json['transId'];
    literatureId = json['literatureId'];
    wallet =
    json['wallet'] != null ? new Wallet.fromJson(json['wallet']) : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    literature = json['literature'] != null
        ? new Literaturex.fromJson(json['literature'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['walletRef'] = this.walletRef;
    data['amount'] = this.amount;
    data['commission'] = this.commission;
    data['status'] = this.status;
    data['channel'] = this.channel;
    data['type'] = this.type;
    data['payerEmail'] = this.payerEmail;
    data['transId'] = this.transId;
    data['literatureId'] = this.literatureId;
    if (this.wallet != null) {
      data['wallet'] = this.wallet!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
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

class Literaturex {
  String? title;
  String? author;
  String? sId;

  Literaturex({this.title, this.author, this.sId});

  Literaturex.fromJson(Map<String, dynamic> json) {
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

