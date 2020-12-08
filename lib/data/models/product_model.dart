import 'dart:core';

class ProductModel {
  String id;
  String name;
  String imageUrl;
  int price;
  int oldPrice;
  double rate;
  String daleDate;
  String description;
  String productCode;
  String category;
  String country;
  String material;
  List<String> views;
  List<String> liked;
  List<String> sizeList;
  List<String> colorList;

  bool inFavorite = false;

  ProductModel(
      this.id,
      this.name,
      this.imageUrl,
      this.price,
      this.oldPrice,
      this.rate,
      this.daleDate,
      this.description,
      this.productCode,
      this.category,
      this.country,
      this.material,
      this.views,
      this.liked,
      this.sizeList,
      this.colorList);

  factory ProductModel.fromJson(Map<String, dynamic> map) {
    List<String> likes = map["likes"]
        .toString()
        .substring(1, map["likes"].toString().length - 1)
        .split(",");
    List<String> colorList = map["colorList"]
        .toString()
        .substring(1, map["colorList"].toString().length - 1)
        .split(",");
    List<String> sizeList = map["sizeList"]
        .toString()
        .substring(1, map["sizeList"].toString().length - 1)
        .split(",");
    List<String> viewsList = map["views"]
        .toString()
        .substring(1, map["views"].toString().length - 1)
        .split(",");
    return ProductModel(
        map["id"],
        map["name"],
        map["imageUrl"],
        map["price"],
        map["oldPrice"],
        double.parse(map["rate"].toString()),
        map["daleDate"],
        map["description"],
        map["productCode"],
        map["category"],
        map["country"],
        map["material"],
        viewsList,
        likes,
        sizeList,
        colorList);
  }

  Map<String, dynamic> get toJson => {
        "id": id,
        "name": name,
        "imageUrl": imageUrl,
        "price": price,
        "oldPrice": oldPrice,
        "rate": rate,
        "daleDate": daleDate,
        "description": description,
        "productCode": productCode,
        "category": category,
        "country": country,
        "material": material,
        "views": views,
        "liked": liked,
        "sizeList": sizeList,
        "colorList": colorList
      };
}
