import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/data/db/cart/cart_database.dart';
import 'package:e_store/data/db/favorite/favorite_db.dart';
import 'package:e_store/data/models/cart_model.dart';
import 'package:e_store/data/models/product_model.dart';
import 'package:e_store/services/server_service.dart';
import 'package:e_store/ui/elements/product_card.dart';
import 'package:e_store/ui/product_details/product_details.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Catalog extends StatefulWidget {
  @override
  _CatalogState createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> {
  final databaseReference = FirebaseDatabase.instance.reference();
  final ServerService _serverService = ServerService();
  final FavoriteDb _favoriteDb = FavoriteDb();
  CartDb _cartDb = CartDb();

  @override
  void initState() {
    //  _serverService.addCollection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 12),
      child: Column(
        children: [
          Container(
            height: 35,
            child: Row(
              children: [
                ImageIcon(
                  AssetImage("assets/drawable/hold.png"),
                  color: Color(0xFFBEBFC4),
                ),
                Container(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    "Tap & hold the product to add to cart",
                    style: GoogleFonts.raleway(
                        fontSize: 12, color: Color(0xFFA3A5AD)),
                  ),
                ),
                Container(
                  child: FlatButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Text(
                          "SORT BY",
                          style: GoogleFonts.roboto(
                              fontSize: 14, color: Color(0xFF1D1F22)),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 6),
                            child:
                                Image.asset("assets/drawable/sort_icon.png")),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 2, right: 22),
            height: 2,
            color: Color(0xFFF1F2F4),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _serverService.catalog.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  List<ProductModel> products = List();
                  snapshot.data.docs.forEach((element) {
                    ProductModel product =
                        ProductModel.fromJson(element.data());
                    products.add(product);
                  });

                  return GridView.builder(
                    itemCount: products.length,
                    scrollDirection: Axis.vertical,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.45,
                        crossAxisSpacing: 10
                        // (orientation == Orientation.portrait) ? 2 : 3),
                        ),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: GestureDetector(
                            onLongPress: () async {
                              bool state = await _cartDb.insertProduct(
                                  CartModel(
                                      products[index].id,
                                      1,
                                      products[index].colorList[0],
                                      products[index].sizeList[0]));
                            },
                            onTap: () {
                              _openAddEntryDialog(products[index]);
                            },
                            child: GridTile(
                                child: ProductCard(
                                    products[index], _onLikePressed))),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error);
                } else
                  return Text("Show logl");
              },
            ),
          )
        ],
      ),
    );
  }

  void _onLikePressed(String id) async {
    int inDb = await _favoriteDb.getCount(id);
    if (inDb > 0) {
      print("Liked -> delete");
      await _favoriteDb.deleteCurrent(id);
    } else {
      print("Liked -> insert");
      await _favoriteDb.insertProduct(id);
    }
  }

  void _openAddEntryDialog(ProductModel productModel) async {
    ProductModel product = await _serverService.addViewNow(productModel.id);
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return ProductDetails(product);
        },
        fullscreenDialog: true));
  }
}
