import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:transact/AppBar.dart';
import 'package:transact/Buyer/ProductSearch.dart';
import 'package:transact/Buyer/buyerCart.dart';
import 'package:transact/Buyer/itemDetails.dart';
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/Model/marketplacemodel.dart';
import 'package:transact/Supplier/ItemDetails.dart';
import 'package:transact/utils/routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:transact/utils/utils.dart';

class PurchaseProduct extends StatefulWidget {
  @override
  _PurchaseProductState createState() => _PurchaseProductState();
}

class _PurchaseProductState extends State<PurchaseProduct> {
  ProgressDialog pr;
  bool seller = false;
  List<bool> _selection = [true, false];
  bool switchControl = false;
  MarketPlaceModel marketPlaceModel = MarketPlaceModel();
  var favorite = false;
  var textHolder = 'Switch is OFF';
  void toggleSwitch(bool value) {
    if (switchControl == false) {
      setState(() {
        switchControl = true;
        textHolder = 'Switch is ON';
      });
      print('Switch is ON');
      // Put your code here which you want to execute on Switch ON event.

    } else {
      setState(() {
        switchControl = false;
        textHolder = 'Switch is OFF';
      });
      print('Switch is OFF');
      // Put your code here which you want to execute on Switch OFF event.
    }
  }
 getSupplierProd() async {
    
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.get(
      "${API.marketPlaceProducts}?GetSellerMarket=false",
      headers: header,
    );
    print(header);
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == true) {
     
        setState(() {
          marketPlaceModel = MarketPlaceModel();
          User.userData.marketPlaceModel=marketPlaceModel;
        });
        Fluttertoast.showToast(
            msg: "no product found",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      } else {
        //pr.dismiss();
        setState(() {
          marketPlaceModel = MarketPlaceModel.fromJson(Json['Data']);
          User.userData.marketPlaceModel = marketPlaceModel;
        });
      }
    } else {
      //pr.dismiss();
      Fluttertoast.showToast(
          msg: "${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }

  getSupplierProduct() async {
    pr.show();
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.get(
      "${API.marketPlaceProducts}?GetSellerMarket=false",
      headers: header,
    );
    print(header);
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == true) {
        pr.dismiss();
        setState(() {
          marketPlaceModel = MarketPlaceModel();
          User.userData.marketPlaceModel=marketPlaceModel;
        });
        Fluttertoast.showToast(
            msg: "no product found",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      } else {
        pr.dismiss();
        setState(() {
          marketPlaceModel = MarketPlaceModel.fromJson(Json['Data']);
          User.userData.marketPlaceModel = marketPlaceModel;
        });
      }
    } else {
      pr.dismiss();
      Fluttertoast.showToast(
          msg: "${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }

  getSellerProduct() async {
    pr.show();
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    print(header);
    var response = await http.get(
      "${API.marketPlaceProducts}?GetSellerMarket=true",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == true) {
        pr.dismiss();
        setState(() {
          marketPlaceModel = MarketPlaceModel();
          User.userData.marketPlaceModel=marketPlaceModel;
        });
        Fluttertoast.showToast(
            msg: "no product found",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      } else {
        pr.dismiss();
        setState(() {
          marketPlaceModel = MarketPlaceModel.fromJson(Json['Data']);
          User.userData.marketPlaceModel = marketPlaceModel;
          //User.userData.dashBoardResult=marketPlaceModel;
        });
      }
    } else {
      pr.dismiss();
      Fluttertoast.showToast(
          msg: "${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSupplierProd();
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
      message: 'Uploading...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(125.0),
          child: CustomeAppBar(
            homepage: false,
            title: "Marketplace",
             bottomIcon2: "images/cart4.png",
            bottomIcon2OnTap: () {
              AppRoutes.push(context, BuyerCart());
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //_icon("images/applyfilter.png", 1),
                  _textField("Search here"),
                 // _icon("images/cart4.png", 2)
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Column(
              children: <Widget>[
                // Container(
                //     width: double.infinity,
                //     alignment: Alignment.center,
                //     child: _toggleButton()),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  width: MediaQuery.of(context).size.width * .5,
                  height: MediaQuery.of(context).size.height * .08,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.blueGrey),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            getSupplierProduct();
                            setState(() {
                              seller = false;
                              User.userData.getSellerProduct=false;
                            });
                          },
                          child: Container(
                            // margin: EdgeInsets.only(bottom:10),
                            width: MediaQuery.of(context).size.width * .2,
                            height: MediaQuery.of(context).size.height * .06,
                            decoration: BoxDecoration(
                                color: seller == true
                                    ? Colors.white
                                    : HexColor("#3B444B"),
                                border: Border.all(color: Colors.blueGrey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Center(
                              child: Text(
                                "Supplier",
                                style: TextStyle(
                                    color: seller == true
                                        ? HexColor("#3B444B")
                                        : Colors.white,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            getSellerProduct();
                            setState(() {
                              seller = true;
                             User.userData.getSellerProduct=true;
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * .2,
                            height: MediaQuery.of(context).size.height * .06,
                            decoration: BoxDecoration(
                                color: seller == false
                                    ? Colors.white
                                    : HexColor("#3B444B"),
                                border: Border.all(color: Colors.blueGrey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Center(
                              child: Text(
                                "Seller",
                                style: TextStyle(
                                    color: seller == false
                                        ? HexColor("#3B444B")
                                        : Colors.white,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  child: _body(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return Container(
        height: MediaQuery.of(context).size.height * .72,
        child: StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          itemCount: marketPlaceModel.result != null
              ? marketPlaceModel.result.length
              : 0,
          itemBuilder: (BuildContext context, int index) => new Container(
              color: Colors.white,
              child: new Center(child: _itemCardSupplier(index)
                  //: _itemCardSeller(index),
                  )),
          staggeredTileBuilder: (int index) =>
              new StaggeredTile.count(2, index.isEven ? 3 : 2.8),
          mainAxisSpacing: 7.0,
          crossAxisSpacing: 7.0,
        ));
  }

  Widget _toggleButton() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: HexColor("#D2D2D2")),
          color: HexColor("#F5F5F5"),
          borderRadius: BorderRadius.circular(30)),
      child: ToggleButtons(
        borderRadius: BorderRadius.circular(30),
        fillColor: HexColor("#F5F5F5"),
        isSelected: _selection,
        onPressed: (int index) {
          setState(() {
            for (int buttonIndex = 0;
                buttonIndex < _selection.length;
                buttonIndex++) {
              if (buttonIndex == index) {
                setState(() {
                  _selection[buttonIndex] = true;
                  marketPlaceModel = MarketPlaceModel();
                });
                getSupplierProduct();
              } else {
                setState(() {
                  _selection[buttonIndex] = false;
                  marketPlaceModel = MarketPlaceModel();
                });
                getSellerProduct();
              }
            }
          });
        },
        renderBorder: false,
        children: <Widget>[
          AnimatedContainer(
            duration: Duration(microseconds: 10),
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: _selection[0] == true
                    ? HexColor("#3B444B")
                    : Colors.transparent),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                '  Supplier  ',
                style: TextStyle(
                    fontSize: 15,
                    color: _selection[0] == true ? Colors.white : Colors.black),
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(microseconds: 10),
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: _selection[1] == true
                  ? HexColor("#3B444B")
                  : HexColor("#F5F5F5"),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              child: Text(
                '  Seller  ',
                style: TextStyle(
                    fontSize: 15,
                    color: _selection[1] == true ? Colors.white : Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _icon(String image, int id) {
    return GestureDetector(
      onTap: () {
        print("$id");
      },
      child: Container(
        child: Image(
          height: 20,
          width: 22,
          color: Colors.white,
          image: AssetImage("$image"),
        ),
      ),
    );
  }

  Widget _textField(String label) {
    return GestureDetector(
      onTap: () {
        AppRoutes.push(context, ProductSearch());
      },
      child: Container(
          width: MediaQuery.of(context).size.width / 1.5,
          height: 45,
          decoration: BoxDecoration(
            color: HexColor("#FFFFFF"),
          ),
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Center(
            child: Row(
              children: <Widget>[
                Icon(Icons.search),
                SizedBox(
                  width: 30,
                ),
                Text("Search Here"),
              ],
            ),
          )

          // TextFormField(
          //   onTap: ()
          //   {
          //      AppRoutes.push(context, ProductSearch());
          //   },
          //   enabled: false,
          //     onFieldSubmitted: (String text) {
          //       print("$text");
          //     },
          //     decoration: InputDecoration(
          //       isDense: true,
          //       filled: true,
          //       fillColor: HexColor("#FFFFFF"),
          //       hintText: "$label",
          //       hintStyle: TextStyle(fontSize: 14, color: Colors.black54),
          //       border: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(8),
          //           borderSide: BorderSide(color: HexColor("#707070"))),
          //       focusedBorder: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(8),
          //           borderSide: BorderSide(width: 1, color: HexColor("#707070"))),
          //       prefixIcon: Container(
          //           margin: EdgeInsets.symmetric(horizontal: 25),
          //           child: Icon(Icons.search)),
          //     )),

          ),
    );
    //   return Container(
    //     width: MediaQuery.of(context).size.width / 1.5,
    //     height: 45,
    //     margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    //     child: TextFormField(
    //         onFieldSubmitted: (String text) {
    //           print("$text");
    //         },
    //         decoration: InputDecoration(
    //           isDense: true,
    //           filled: true,
    //           fillColor: HexColor("#FFFFFF"),
    //           hintText: "$label",
    //           hintStyle: TextStyle(fontSize: 14, color: Colors.black54),
    //           border: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(8),
    //               borderSide: BorderSide(color: HexColor("#707070"))),
    //           focusedBorder: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(8),
    //               borderSide: BorderSide(width: 1, color: HexColor("#707070"))),
    //           prefixIcon: Container(
    //               margin: EdgeInsets.symmetric(horizontal: 25),
    //               child: Icon(Icons.search)),
    //         )),
    //   );
    // }
  }

  Widget _itemCardSeller(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          User.userData.index = index;
        });
        // AppRoutes.push(context, ItemDetails());
        //AppRoutes.push(context, AllCategories());
        AppRoutes.push(context, ItemDetailsBuyer());
      },
      child: Container(
        //  margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 4),
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  marketPlaceModel.result[index].imagePath == null
                      ? Image.asset("images/shirt.png")
                      : Image.network(
                          "${API.API_URL}${marketPlaceModel.result[index].imagePath}",
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .2,
                        ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "${marketPlaceModel.result[index].name}",
                          style: TextStyle(
                              color: HexColor("#3B444B"),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CaviarDreams'),
                        ),
                        // GestureDetector(
                        //   onTap: () {},
                        //   child: Icon(
                        //     Icons.more_vert,
                        //     color: HexColor('#3B444B'),
                        //     size: 22,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text(
                          "\$${marketPlaceModel.result[index].actualPrice}",
                          style: TextStyle(
                              decoration:
                                  marketPlaceModel.result[index].withDiscount ==
                                          true
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                              color: HexColor("#707070"),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CaviarDreams'),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        marketPlaceModel.result[index].withDiscount == true
                            ? Text(
                                "\$${marketPlaceModel.result[index].salePrice}",
                                style: TextStyle(
                                    color: HexColor("#515C6F"),
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'CaviarDreams'),
                              )
                            : Text(
                                "",
                                style: TextStyle(
                                    color: HexColor("#515C6F"),
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'CaviarDreams'),
                              ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Per Piece",
                          style: TextStyle(
                              color: HexColor("#707070"),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CaviarDreams'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Min Order : (${marketPlaceModel.result[index].minOrder})",
                      style: TextStyle(
                          color: HexColor("#707070"),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'CaviarDreams'),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: HexColor("#EFCE4A"),
                            size: 9,
                          ),
                          Icon(
                            Icons.star,
                            color: HexColor("#EFCE4A"),
                            size: 9,
                          ),
                          Icon(
                            Icons.star,
                            color: HexColor("#EFCE4A"),
                            size: 9,
                          ),
                          Icon(
                            Icons.star,
                            color: HexColor("#EFCE4A"),
                            size: 9,
                          ),
                          Icon(
                            Icons.star,
                            color: HexColor("#EFCE4A"),
                            size: 9,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            "(10)",
                            style: TextStyle(fontSize: 9),
                          ),
                        ],
                      ),
                      Text(
                        "(81/100) IN STOCK",
                        style: TextStyle(
                            color: HexColor("#707070"),
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CaviarDreams'),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Align(
                alignment: Alignment.topRight,
                child: Container(
                    height: 20,
                    width: 35,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/discountTag.png"),
                      ),
                    ),
                    child: Center(
                      child: marketPlaceModel
                                  .result[index].isDiscountPercentage ==
                              true
                          ? Text(
                              "-${marketPlaceModel.result[index].totalDiscount}\$",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 8, color: Colors.white),
                            )
                          : Text(
                              "-${marketPlaceModel.result[index].totalDiscount}%",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 8, color: Colors.white),
                            ),
                    ))),
          ],
        ),
      ),
    );
  }

  Widget _itemCardSupplier(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          User.userData.index = index;
          User.userData.marketPlaceModel=marketPlaceModel;
        });
        print(User.userData.index = index);
        
        AppRoutes.push(context, ItemDetailsBuyer());
      },
      child: Container(
        //margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 4),
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // marketPlaceModel.result[index].imagePath == null
                  //     ? Image.asset("images/shirt.png")
                  //     : Image.network(
                  //         "${API.API_URL}${marketPlaceModel.result[index].imagePath}",
                  //         width: MediaQuery.of(context).size.width,
                  //         height: MediaQuery.of(context).size.height * .2,
                  //       ),
                   Container(
                    
                     width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .2,
                    child: marketPlaceModel.result[index].imagePath == null
                      ? Image.asset("images/shirt.png")
                      : Image.network(
                          "${API.API_URL}${marketPlaceModel.result[index].imagePath}",
                         fit: BoxFit.cover,
                        ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child:Text(
                          "${marketPlaceModel.result[index].name}",
                          style: TextStyle(
                              color: HexColor("#3B444B"),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CaviarDreams'),
                        ),
                        ),
                        // GestureDetector(
                        //   onTap: () {},
                        //   child: Icon(
                        //     Icons.more_vert,
                        //     color: HexColor('#3B444B'),
                        //     size: 22,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text(
                          "\$${marketPlaceModel.result[index].actualPrice}",
                          style: TextStyle(
                              decoration:
                                  marketPlaceModel.result[index].withDiscount ==
                                          true
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                              color: HexColor("#707070"),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CaviarDreams'),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        marketPlaceModel.result[index].withDiscount == true
                            ? Text(
                                "\$${marketPlaceModel.result[index].salePrice}",
                                style: TextStyle(
                                    color: HexColor("#515C6F"),
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'CaviarDreams'),
                              )
                            : Text(
                                "",
                                style: TextStyle(
                                    color: HexColor("#515C6F"),
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'CaviarDreams'),
                              ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Per Piece",
                          style: TextStyle(
                              color: HexColor("#707070"),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CaviarDreams'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () async {
                          pr.show();
                          var header = {
                            "Authorization":
                                AuthenticationUser.getAuthentication(),
                          };
                          var body = {
                            "productId": "${marketPlaceModel.result[index].id}"
                          };
                          var response = await http.post("${API.AddWishList}",
                              headers: header, body: body);
                          var Json = json.decode(response.body);
                          print(Json);
                          if (response.statusCode == 200) {
                            if (Json['Data']['WithError'] == false) {
                              pr.dismiss();
                              Fluttertoast.showToast(
                                  msg: "${Json['Data']['ShortMessage']}",
                                  textColor: Colors.white,
                                  backgroundColor: Colors.blueGrey);
                              if (seller == true) {
                                getSellerProduct();
                              } else {
                                getSupplierProduct();
                              }
                            } else {
                              pr.dismiss();
                              Fluttertoast.showToast(
                                  msg: "${Json['Data']['ShortMessage']}",
                                  textColor: Colors.white,
                                  backgroundColor: Colors.blueGrey);
                            }
                          } else {
                            pr.dismiss();
                            Fluttertoast.showToast(
                                msg: "response status: ${response.statusCode}",
                                textColor: Colors.white,
                                backgroundColor: Colors.blueGrey);
                          }
                        },
                        child: Icon(
                          marketPlaceModel.result[index].isLikeByMe == false
                              ? Icons.favorite_border
                              : Icons.favorite,
                          color:
                              marketPlaceModel.result[index].isLikeByMe == false
                                  ? HexColor('#3B444B')
                                  : Colors.red,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                 marketPlaceModel.result[index].type==0?
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Min Order : (${marketPlaceModel.result[index].minOrder})",
                      style: TextStyle(
                          color: HexColor("#707070"),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'CaviarDreams'),
                    ),
                  ):Text(""),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _fiveStar(marketPlaceModel.result[index].rating),
                      marketPlaceModel.result[index].type==0?
                      marketPlaceModel.result[index].qty<=0?
                      Text(
                        "out of Stock",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CaviarDreams'),
                      ):Text(
                        "IN STOCK",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CaviarDreams'),
                      ):Text(
                        "Bundle",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CaviarDreams'),
                      ),
                    


                    ],
                  ),
                ],
              ),
            ),
                 marketPlaceModel.result[index].withDiscount==true?
            
            Align(
                alignment: Alignment.topRight,
                child: Container(
                    height: 20,
                    width: 35,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/discountTag.png"),
                      ),
                    ),
                    child: Center(
                      child: marketPlaceModel
                                  .result[index].isDiscountPercentage ==
                              true
                          ? Text(
                              "-${marketPlaceModel.result[index].totalDiscount}%",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 8, color: Colors.white),
                            )
                          : Text(
                              "-${marketPlaceModel.result[index].totalDiscount}\$",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 8, color: Colors.white),
                            ),
                    )))
          :Text(""),
          ],
        ),
      ),
    );
  }
   Widget showRating() {
    return Container(
      child: Icon(
        Icons.star,
        color: HexColor("#EFCE4A"),
        size: 9,
      ),
    );
  }
   Widget _fiveStar(var rat) {
    return 
    Container(
        // margin: EdgeInsets.only(
        //   top: id == 1 ? 10 : 0.0,
        //   bottom: 10,
        // ),
        child: 
        RatingBar(
   initialRating: 0,
   direction: Axis.horizontal,
   allowHalfRating: true,
   itemCount: rat,
   itemSize: 20,
   glow: true,
   unratedColor: Colors.amber,
   //itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
   itemBuilder: (context, _) => Icon(
     Icons.star,
     color: Colors.amber,
   ),
   onRatingUpdate: (rating) {
     print(rating);
   },
)
        // SmoothStarRating(
        //   //rating: rat.todouble(),
        //   //rating:rat,
        //   size: 14,
        //   filledIconData: Icons.star,
        //   halfFilledIconData: Icons.star_half,
        //   defaultIconData: Icons.star_border,
        //   color: Colors.yellow[600],
        //   borderColor: Colors.yellow[600],
        //   starCount: rat,
        //   //allowHalfRating: false,
        //   spacing: 0.2,
        //   onRatingChanged: (value) {
        //     setState(() {
        //       //_productRating = value;
        //     });
        //     //print(_productRating);
        //   },
        // )
        );
  }

}
