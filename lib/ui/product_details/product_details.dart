import 'package:e_store/data/db/cart/cart_database.dart';
import 'package:e_store/data/models/cart_model.dart';
import 'package:e_store/data/models/product_model.dart';
import 'package:e_store/services/server_service.dart';
import 'package:e_store/ui/elements/app%20expansion_tile.dart';
import 'package:e_store/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel productModel;

  ProductDetails(this.productModel);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String productColor = "";
  String productSize = "";
  String selectedToCart = "1";
  bool inCart = false;
  CartDb _cartDb = CartDb();
  ServerService _serverService;

  @override
  void initState() {
    _serverService = ServerService();
    productColor = widget.productModel.colorList[0];
    productSize = widget.productModel.sizeList[0];
    _isInDb().then((value) {
      setState(() {
        inCart = value;
      });
    });
    super.initState();
  }

  Future<bool> _isInDb() async {
    List<CartModel> cart = await _cartDb.getById(widget.productModel.id);
    return cart.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Container(
                    child: Image.network(
                      widget.productModel.imageUrl,
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.all(30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              "${widget.productModel.name}",
                              style: GoogleFonts.raleway(
                                color: AppTheme.blackFont,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 25),
                            child: Row(
                              children: [
                                widget.productModel.oldPrice > 0
                                    ? Container(
                                        child: Text(
                                          "\$ ${widget.productModel.oldPrice}",
                                          style: GoogleFonts.roboto(
                                              fontSize: 19,
                                              color: AppTheme.blackFont,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      )
                                    : Container(),
                                Container(
                                  margin: EdgeInsets.only(left: 12),
                                  child: Text(
                                    "\$ ${widget.productModel.price}",
                                    style: GoogleFonts.roboto(
                                        fontSize: 19,
                                        color: AppTheme.blackFont,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 25),
                              child: RatingBar.builder(
                                initialRating: _getrate(),
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: AppTheme.greenColor,
                                ),
                                onRatingUpdate: (rating) {
                                  _serverService.setRate(
                                      widget.productModel.id, rating);
                                },
                              )),
                          Container(
                            margin: EdgeInsets.only(top: 25),
                            decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.greyLight)),
                            child: FlatButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Colot list'),
                                        content: sizeDialog(),
                                      );
                                    });
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Size",
                                      style: GoogleFonts.raleway(
                                          color: AppTheme.blackFont,
                                          fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      productSize,
                                      style: GoogleFonts.raleway(
                                          color: AppTheme.blackFont,
                                          fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    child: Icon(Icons.keyboard_arrow_down),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 25),
                            decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.greyLight)),
                            child: FlatButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Colot list'),
                                        content: colorDialog(),
                                      );
                                    });
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Color",
                                      style: GoogleFonts.raleway(
                                          color: AppTheme.blackFont,
                                          fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    child:
                                        _getColorListItem(productColor, false),
                                  ),
                                  Container(
                                    child: Icon(Icons.keyboard_arrow_down),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 25),
                            child: Row(
                              children: [
                                Expanded(
                                  child: !inCart
                                      ? FlatButton(
                                          color: AppTheme.greenColor,
                                          onPressed: () async {
                                            bool state = await _cartDb
                                                .insertProduct(CartModel(
                                                    widget.productModel.id,
                                                    int.parse(selectedToCart),
                                                    productColor,
                                                    productSize));
                                            setState(() {
                                              inCart = state;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Add to card",
                                              style: GoogleFonts.raleway(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )
                                      : FlatButton(
                                          color: AppTheme.greenColor,
                                          onPressed: () async {
                                            bool state =
                                                await _cartDb.deleteCurrent(
                                                    widget.productModel.id);
                                            setState(() {
                                              if (state) inCart = false;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Delete from cart",
                                              style: GoogleFonts.raleway(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 5),
                                  child: DropdownButton<String>(
                                    value: selectedToCart,
                                    icon: Icon(Icons.keyboard_arrow_down),
                                    iconSize: 24,
                                    underline: Container(
                                      height: 2,
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        selectedToCart = newValue;
                                      });
                                    },
                                    items: <String>['0', '1', '2', '3']
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                )
                              ],
                            ),
                          ),
                          ExpansionTile(
                            initiallyExpanded: true,
                            tilePadding: EdgeInsets.only(left: 0),
                            title: Text(
                              "Description",
                              style: GoogleFonts.raleway(
                                  color: AppTheme.blackFont, fontSize: 16),
                            ),
                            children: [Text(widget.productModel.description)],
                          )
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Text("Product Code:"),
                        Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(widget.productModel.productCode)),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Text("Category:"),
                        Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                              widget.productModel.category,
                              style: GoogleFonts.raleway(
                                color: AppTheme.greenColor,
                                decoration: TextDecoration.underline,
                              ),
                            )),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Text("Material:"),
                        Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(widget.productModel.material)),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Text("Country:"),
                        Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(widget.productModel.country)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getSizeList() {
    List<Widget> sizes = List();
    widget.productModel.sizeList.forEach((element) {
      ListTile listTile = ListTile(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            productSize = element;
          });
        },
        title: Text(
          element.replaceAll(new RegExp(r"\s+"), ""),
          style: GoogleFonts.raleway(color: AppTheme.blackFont, fontSize: 16),
        ),
      );
      sizes.add(listTile);
    });
    return sizes;
  }

  List<Widget> _getColorList() {
    List<Widget> colorsList = List();
    widget.productModel.colorList.forEach((element) {
      colorsList.add(_getColorListItem(element, true));
    });
    return colorsList;
  }

  Widget _getColorListItem(String colorName, bool expanded) {
    if (expanded)
      return ListTile(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            productColor = colorName.replaceAll(new RegExp(r"\s+"), "");
          });
        },
        title: Row(
          children: [
            Expanded(
                child: Text(
              colorName.replaceAll(new RegExp(r"\s+"), ""),
              style:
                  GoogleFonts.raleway(color: AppTheme.blackFont, fontSize: 16),
            )),
            Container(
              width: 24,
              height: 24,
              color: _getColorFromText(colorName),
            )
          ],
        ),
      );
    else
      return Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 6),
            width: 24,
            height: 24,
            color: _getColorFromText(colorName),
          ),
          Text(
            colorName,
            style: GoogleFonts.raleway(color: AppTheme.blackFont, fontSize: 16),
          ),
        ],
      );
  }

  Color _getColorFromText(String colorName) {
    if (colorName.toLowerCase().contains("green"))
      return Colors.lightGreen;
    else if (colorName.toLowerCase().contains("grey"))
      return Colors.grey;
    else if (colorName.toLowerCase().contains("red"))
      return Colors.redAccent;
    else
      return Colors.white;
  }

  double _getrate() {
    return widget.productModel.rate > 0
        ? (widget.productModel.rate - widget.productModel.views.length) / 5
        : 0;
  }

  Widget colorDialog() {
    return Container(
        width: 300.0, // Change as per your requirement
        child: SingleChildScrollView(
          child: Column(
            children: _getColorList(),
          ),
        ));
  }

  Widget sizeDialog() {
    return Container(
        width: 300.0, // Change as per your requirement
        child: SingleChildScrollView(
          child: Column(
            children: _getSizeList(),
          ),
        ));
  }
}
