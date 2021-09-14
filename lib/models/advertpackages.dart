class AdvertPackage {
  int? duration;
  double? price;
  String? name;
  String? createdAt;
  String? updatedAt;
  String? id;

  AdvertPackage(
      {this.duration,
        this.price,
        this.name,
        this.createdAt,
        this.updatedAt,
        this.id});

  AdvertPackage.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    price = json['price'].toDouble();
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['duration'] = this.duration;
    data['price'] = this.price;
    data['name'] = this.name;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    return data;
  }
}