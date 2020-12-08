import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/data/models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gson/gson.dart';

class ServerService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();

  final CollectionReference catalog =
      FirebaseFirestore.instance.collection("catalog");
  String get uid => _auth.currentUser.uid;

  void addToCard(ProductModel productModel) {
    if (!_auth.currentUser.isAnonymous) {
      // final CollectionReference users =
      // FirebaseFirestore.instance.collection("users/${_auth.currentUser.uid}");
      // users.add({
      //   "id": _auth.currentUser.uid,
      //   "email": _auth.currentUser.email,
      //   "cart": []
      //
      // });
    } else {
      print("isAnonymous");
    }
  }

  //CreateUser table
  Future createUserTable() {
    if (!_auth.currentUser.isAnonymous) {
      final userCollection = FirebaseFirestore.instance.collection("users");
      print(userCollection.doc(_auth.currentUser.uid).path);
      userCollection.doc(_auth.currentUser.uid).set(
          {"uid": _auth.currentUser.uid, "email": _auth.currentUser.email});
    }
    return null;
  }

  void addCollection() {
    Future(() {
      for (int i = 0; i < 10; i++) {
        ProductModel productModel = ProductModel(
            "null",
            "Product $i",
            "https://firebasestorage.googleapis.com/v0/b/testproject-47030.appspot.com/o/image.png?alt=media&token=65374d0d-1bed-4a2a-93c2-301d3efac9ab",
            100,
            200,
            8.0,
            i == 0 ? "1608847200000" : "",
            "The Karissa V-Neck Tee features a semi-fitted shape that's flattering for every figure. You can hit the gym with confidence while it hugs curves and hides common \"problem\" areas. Find stunning women's cocktail dresses and party dresses.",
            "testCode_$i",
            "Sherts",
            "Germany",
            "Cotton",
            [],
            ["0", "1", "2"],
            ["small", "medium", "large"],
            ["lightGrey", "lightGreen", "lightRed"]);
        addUser(productModel);
      }
    });
  }

  Future<ProductModel> addViewNow(String id) async {
    String uid = _auth.currentUser.uid;
    ProductModel productModel;
    await catalog.doc(id).get().then((response) {
      productModel = ProductModel.fromJson(response.data());
      if (!productModel.views.contains(uid)) {
        productModel.views.add(uid);
        catalog.doc(id).set(productModel.toJson);
      }
    });
    print("Saved ${productModel.views.length}");
    return productModel;
  }

  Future<ProductModel> setRate(String id, double rate) async {
    String uid = _auth.currentUser.uid;
    ProductModel productModel;
    await catalog.doc(id).get().then((response) {
      productModel = ProductModel.fromJson(response.data());
      productModel.rate += rate;
      catalog.doc(id).set(productModel.toJson);
    });
    print("Saved ${productModel.views.length}");
    return productModel;
  }

  Future<void> addUser(ProductModel productModel) {
    // Call the user's CollectionReference to add a new user
    return catalog.add(productModel.toJson).then((value) {
      productModel.id = value.id;
      value.update(productModel.toJson);
    }).catchError((error) => print("Failed to add user: $error"));
  }
}
