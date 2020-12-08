class CartModel {
  String id;
  int count;
  String color;
  String size;

  CartModel(this.id, this.count, this.color, this.size);

  factory CartModel.fromJson(Map<String, dynamic> map) {
    return CartModel(map["id"], map["count"], map["color"], map["size"]);
  }

  Map<String, dynamic> get toJson =>
      {"id": id, "count": count, "color": color, "size": size};
}
