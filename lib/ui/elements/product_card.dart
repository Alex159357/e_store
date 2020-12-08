import 'package:e_store/data/app_values/app_values.dart';
import 'package:e_store/data/db/cart/cart_database.dart';
import 'package:e_store/data/db/favorite/favorite_db.dart';
import 'package:e_store/data/models/product_model.dart';
import 'package:e_store/services/server_service.dart';
import 'package:e_store/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCard extends StatefulWidget {
  final ProductModel productModel;
  final Function onLiked;

  ProductCard(this.productModel, this.onLiked);
  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool initialLike = false;
  CartDb _cartDb = CartDb();
  final FavoriteDb _favoriteDb = FavoriteDb();

  @override
  void initState() {
    _favoriteDb.getAll().then((value) {
      initialLike = value
          .where((element) => element["id"] == widget.productModel.id)
          .toList()
          .isNotEmpty;
    }).whenComplete(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(
                widget.productModel.imageUrl,
                fit: BoxFit.contain,
                width: double.infinity,
              ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    widget.onLiked(widget.productModel.id);
                    initialLike = !initialLike;
                    setState(() {});
                  },
                  child: Container(
                      margin: EdgeInsets.only(top: 10, right: 10),
                      child: Image.asset(!initialLike
                          ? AppValues.images.likeUnpressed
                          : AppValues.images.likePressed)),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 6),
            child: Text(
              "${widget.productModel.name}",
              style: GoogleFonts.raleway(fontSize: 16),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 6),
            child: Row(
              children: [
                Text(
                  "\$ ${widget.productModel.price}",
                  style: GoogleFonts.roboto(
                      fontSize: 18, fontWeight: FontWeight.w400),
                ),
                widget.productModel.oldPrice > 0
                    ? Container(
                        margin: EdgeInsets.only(left: 6),
                        child: Text(
                          "\$ ${widget.productModel.oldPrice}",
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.greyLight,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 25),
              child: Row(
                children: [
                  RatingBar.builder(
                    initialRating: _getrate(),
                    itemSize: 16,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: AppTheme.greenColor,
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 6),
                      child: Text("(${_getrate()})"))
                ],
              )),
          widget.productModel.daleDate.length > 0
              ? Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Text(
                    "${AppValues.text.remain}: ${_getSaleEndDate(widget.productModel)}",
                    style: GoogleFonts.roboto(
                        fontSize: 11, color: AppTheme.deepRed),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  String _getSaleEndDate(ProductModel productModel) {
    if (productModel.daleDate.length > 3) {
      DateTime dateTime = DateTime.now();
      DateTime saleDate =
          DateTime.fromMillisecondsSinceEpoch(int.parse(productModel.daleDate));
      int saleDifferentHour = saleDate.difference(dateTime).inMilliseconds;
      DateTime dateFromDifferent =
          DateTime.fromMillisecondsSinceEpoch(saleDifferentHour);

      return "${dateFromDifferent.day} ${AppValues.text.days} ${dateFromDifferent.hour}${AppValues.text.hourShort} : ${dateFromDifferent.minute}${AppValues.text.minuteShort}";
    } else
      return "";
  }

  double _getrate() {
    return widget.productModel.rate > 0
        ? (widget.productModel.rate - widget.productModel.views.length) / 5
        : 0;
  }
}

//
// class ProductCard1 extends StatelessWidget {
//   final ProductModel productModel;
//   final Function onLiked;
//   final bool initialLike;
//
//   ProductCard(this.productModel, this.onLiked, this.initialLike);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Stack(
//             children: [
//               Image.network(productModel.imageUrl),
//               Align(
//                 alignment: Alignment.topRight,
//                 child: InkWell(
//                   onTap: () {
//                     onLiked(productModel.id);
//                     initialLike = true;
//                   },
//                   child: Container(
//                       margin: EdgeInsets.only(top: 10, right: 10),
//                       child: Image.asset(!initialLike
//                           ? AppValues.images.likeUnpressed
//                           : AppValues.images.likePressed)),
//                 ),
//               )
//             ],
//           ),
//           Container(
//             margin: EdgeInsets.only(top: 6),
//             child: Text(
//               "${productModel.name}",
//               style: GoogleFonts.raleway(fontSize: 16),
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.only(top: 6),
//             child: Row(
//               children: [
//                 Text(
//                   "\$ ${productModel.price}",
//                   style: GoogleFonts.roboto(
//                       fontSize: 18, fontWeight: FontWeight.w400),
//                 ),
//                 productModel.oldPrice > 0
//                     ? Container(
//                         margin: EdgeInsets.only(left: 6),
//                         child: Text(
//                           "\$ ${productModel.oldPrice}",
//                           style: GoogleFonts.roboto(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w400,
//                             color: AppTheme.greyLight,
//                             decoration: TextDecoration.lineThrough,
//                           ),
//                         ),
//                       )
//                     : Container(),
//               ],
//             ),
//           ),
//           Container(
//               margin: EdgeInsets.only(top: 25),
//               child: Row(
//                 children: [
//                   RatingBar.builder(
//                     initialRating: _getrate(),
//                     itemSize: 16,
//                     minRating: 1,
//                     direction: Axis.horizontal,
//                     allowHalfRating: true,
//                     itemCount: 5,
//                     itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
//                     itemBuilder: (context, _) => Icon(
//                       Icons.star,
//                       color: AppTheme.greenColor,
//                     ),
//                   ),
//                   Container(
//                       margin: EdgeInsets.only(left: 6),
//                       child: Text("(${_getrate()})"))
//                 ],
//               )),
//           productModel.daleDate.length > 0
//               ? Container(
//                   margin: EdgeInsets.only(top: 15),
//                   child: Text(
//                     "${AppValues.text.remain}: ${_getSaleEndDate(productModel)}",
//                     style: GoogleFonts.roboto(
//                         fontSize: 11, color: AppTheme.deepRed),
//                   ),
//                 )
//               : Container(),
//         ],
//       ),
//     );
//   }
//
//   List<Widget> _getRate(ProductModel productModel) {
//     List<Widget> rates = List();
//     productModel.liked.length;
//     //TODO Set on counter in open product, and check likes with opened
//     return rates;
//   }
//
//   String _getSaleEndDate(ProductModel productModel) {
//     if (productModel.daleDate.length > 3) {
//       DateTime dateTime = DateTime.now();
//       DateTime saleDate =
//           DateTime.fromMillisecondsSinceEpoch(int.parse(productModel.daleDate));
//       int saleDifferentHour = saleDate.difference(dateTime).inMilliseconds;
//       DateTime dateFromDifferent =
//           DateTime.fromMillisecondsSinceEpoch(saleDifferentHour);
//
//       return "${dateFromDifferent.day} ${AppValues.text.days} ${dateFromDifferent.hour}${AppValues.text.hourShort} : ${dateFromDifferent.minute}${AppValues.text.minuteShort}";
//     } else
//       return "";
//   }
//
//   double _getrate() {
//     return productModel.rate > 0
//         ? (productModel.rate - productModel.views.length) / 5
//         : 0;
//   }
// }
