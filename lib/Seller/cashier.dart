import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:transact/AppBar.dart';
import 'package:http/http.dart'as http;
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/Model/marketplacemodel.dart';
import 'dart:convert';
import 'package:transact/Seller/drawer.dart';
import 'package:transact/Seller/mycart.dart';

import 'package:transact/Supplier/ItemDetails.dart';
import 'package:transact/utils/bottomButton.dart';
import 'package:transact/utils/cashierproductdetail.dart';

import 'package:transact/utils/routes.dart';
import 'package:transact/utils/utils.dart';

class Cashier extends StatefulWidget {
  @override
  _CashierState createState() => _CashierState();
}

class _CashierState extends State<Cashier> {
  int counter = 1;
  Map map = Map();
  ProgressDialog pr;
   MarketPlaceModel marketPlaceModel = MarketPlaceModel();
  int counter1 = 1;
  int counter2 = 1;
  int counter3 = 1;
  int counter4 = 1;
  int counter5 = 1;

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool switchbuttton1 = true;
  final Color primary = Colors.white;
  final Color active = Colors.grey.shade800;
  final Color divider = Colors.transparent;
  bool switchControl = false;
  TextEditingController pin=TextEditingController();
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
    addToCart(int c,int i) async {
      print(c);
    // print(User.userData.marketPlaceModel
    //                       .result[User.userData.index].qty);
    //                   print(User.userData.marketPlaceModel
    //                       .result[User.userData.index].minOrder);
    //                       print(counter);
    //                       print(counter <
    //         User.userData.marketPlaceModel.result[User.userData.index]
    //             .minOrder);
    //             print(c >=
    //         User.userData.marketPlaceModel.result[User.userData.index].qty);
    if (
        c <
            marketPlaceModel.result[i]
                .minOrder) {
      Fluttertoast.showToast(
          msg: "not allowed less than min-Order",
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.blueGrey);
    } 
    else if(c >
            marketPlaceModel.result[i].qty)
            {
              Fluttertoast.showToast(
          msg: "not more than quantity",
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.blueGrey);
            }
    else {
      pr.show();
      double lineTotal = 0.0;
      lineTotal = c *
          marketPlaceModel.result[i]
              .actualPrice;
      var header = {
        "Authorization": AuthenticationUser.getAuthentication(),
      };
      var body = {
        "Qty": "$c",
        "Price":"${marketPlaceModel.result[i].actualPrice}",
        "LineTotal": "$lineTotal",
        "ProductId": "${marketPlaceModel.result[i].id}",
        "pin":"${User.userData.pin}",
      };
      var response = await http.post(
        "${API.cashierAddToCart}",
        headers: header,
        body: body,
      );
      var Json = json.decode(response.body);
      print(json.decode(response.body));
      if (response.statusCode == 200) {
        if (Json['Data']['WithError'] == false) {
          pr.dismiss();
          // if (buyerCheck == true) {
          //   setState(() {
          //     User.userData.totalCart=counter *
          // User.userData.marketPlaceModel.result[User.userData.index]
          //     .salePrice;
          //   });
          //   AppRoutes.push(context, BuyerAdress());
          // } else {
          //   AppRoutes.push(context, BuyerCart());
          // }

          Fluttertoast.showToast(
              msg: "${Json['Data']['ShortMessage']}",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
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
            msg: "Status Code: ${response.statusCode}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      }
    }
  }


void _incrementAmount(String productId) {
    if (map.containsKey("$productId")) {
      int value = map["$productId"];
      print(map);
      if (value < 30) {
        setState(() {
          map.addAll({"$productId": value + 1});
        });
      }
    } else {
      setState(() {
        map.addAll({"$productId": 1});
      });
    }
  }

  void _decrementAmount(String productId) {
    if (map.containsKey("$productId")) {
      int value = map["$productId"];

      if (value > 1) {
        setState(() {
          map.addAll({"$productId": value - 1});
        });
      }
    } else {
      setState(() {
        map.addAll({"$productId": 1});
      });
    }
    print(map);
  }

    getSupplierProduct() async {
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.get(
      "${API.SupplierDashboardProduct}",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == true) {
        setState(() {
          marketPlaceModel=MarketPlaceModel();
        });
        Fluttertoast.showToast(
            msg: "no product found",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      } else {
        setState(() {
          marketPlaceModel = MarketPlaceModel.fromJson(Json['Data']);
          User.userData.marketPlaceModel = marketPlaceModel;
        });
      }
    } else {
      Fluttertoast.showToast(
          msg: "${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }
  void _showDialog() {
    showDialog(
        context: context,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: MediaQuery.of(context).size.width / 1.2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                    alignment: Alignment.center,
                    child: Container(
                        child: Text(
                      "enter your pin",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ))),
                //_textField('${User.userData.drawerItem}', moduleName),
                _textField("Pin", pin),
                GestureDetector(
                  onTap: () {
                    if (pin.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Pin not entered",
                          textColor: Colors.white,
                          backgroundColor: Colors.blueGrey);
                    } else {
                      //navigatorChecker();
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * .055,
                    decoration: BoxDecoration(
                      color: HexColor("#3B444B"),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0)),
                    ),
                    child: Center(
                      child: Text(
                        "set",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSupplierProduct();
  }
  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
      message: 'Loading...',
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
          backgroundColor: Color(0xffF5F7FA),
          body: _sellerHome(),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(90.0),
            child: CustomeAppBar(
              homepage: false,
              title: "Cashier",
              key: _key,
            ),
          ),
          // floatingActionButton: _fab(context),
          drawer: SellerDrawer(),
          bottomNavigationBar: _bottomBar()),
    );
  }

  Widget _sellerHome() {
    return Container(
        child: StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: marketPlaceModel.result!=null?marketPlaceModel.result.length:0,
      itemBuilder: (BuildContext context, int index) => new Container(
          color: Colors.white,
          child: new Center(
            child: itemCardSeller(
                
                index),
          )),
      staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(
            2,
             index.isEven ? 2.7 : 2.9),
                   mainAxisSpacing: 7.0,
      crossAxisSpacing: 7.0,
      
    ));
  }

  Widget itemCardSeller(
    int countID,

  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          User.userData.index=countID;

        });
        AppRoutes.push(context, CashierProductDetail());
      },
      child: Container(
        // margin: EdgeInsets.only(
        //   left: 10,
        //   right: 10,
        //   top: 10,
        // ),
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                   Container(
                    
                     width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .2,
                    child: marketPlaceModel.result[countID].imagePath == null
                      ? Image.asset("images/shirt.png")
                      : Image.network(
                          "${API.API_URL}${marketPlaceModel.result[countID].imagePath}",
                         fit: BoxFit.cover,
                        ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left:17),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "\$${marketPlaceModel.result[countID].actualPrice}",
                          style: TextStyle(
                              decoration:
                                  marketPlaceModel.result[countID].withDiscount ==
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
                        marketPlaceModel.result[countID].withDiscount == true
                            ? Text(
                                "\$${marketPlaceModel.result[countID].salePrice}",
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
                        
                      ],
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.only(top: 5),
                  //   child: Row(
                  //     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: <Widget>[
                  //       Text("\$24.99",
                  //           style: TextStyle(
                  //             decoration: TextDecoration.lineThrough,
                  //             color: Color(0xff515C6F),
                  //             fontSize: 12,
                  //             fontWeight: FontWeight.bold,
                  //           )),
                  //       Container(
                  //           margin: EdgeInsets.only(top: 0, left: 8),
                  //           child: Text("\$58.99",
                  //               style: TextStyle(
                  //                 color: Color(0xff8D8C8C),
                  //                 fontSize: 12,
                  //                 fontWeight: FontWeight.bold,
                  //               ))),
                  //     ],
                  //   ),
                  // ),
                  // // _counter()

                  Container(
                    width: MediaQuery.of(context).size.width*.4,
                decoration: BoxDecoration(
                  
                    color: Color(0xffEDEDED),
                    borderRadius: BorderRadius.circular(10)),
                height: 30,
                child: Row(
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          _decrementAmount(marketPlaceModel.result[countID].id.toString());
                        },
                        // onLongPress: () {
                        //   setState(() {
                        //     map.addAll({
                        //       "${_itemsDataModel.result.productList[index].id.toString()}":
                        //           0
                        //     });
                        //   });
                        // },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Icon(
                            Icons.remove,
                            size: 20,
                          ),
                        )),
                    Expanded(
                        child: Text(
                      marketPlaceModel.result != null
                          ? "${map[marketPlaceModel.result[countID].id.toString()] ?? 1}"
                          : "1",
                      textAlign: TextAlign.center,
                    )),
                    InkWell(
                      onTap: () {
                        _incrementAmount(marketPlaceModel.result[countID].id.toString());
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Icon(
                          Icons.add,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
                GestureDetector(
                  onTap: ()
                  {
                    print(map[marketPlaceModel.result[countID].id.toString()]??1);
                    if(User.userData.rememberPin==0)
                    {
                       Fluttertoast.showToast(
          msg: "no PIN found",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
                    }
                    else
                    {
                      addToCart(map[marketPlaceModel.result[countID].id.toString()]??1,countID);
                  
                    }
                      //_showDialog();
                  },
                  child: Container(
                    margin: EdgeInsets.only(top:5),
                    width: MediaQuery.of(context).size.width*.4,
                    height: 30,
                    decoration: BoxDecoration(
                      color: HexColor("#FF6D2B"),
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Center(
                      child: Text("Add to cart",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ),
                  // countID == 0 || countID == 5
                  //     ? 
                  //     : countID == 1 || countID == 6
                  //         ? _counter2()
                  //         : countID == 2 || countID == 7
                  //             ? _counter3()
                  //             : _counter(),
                ],
              ),
            ),
           
          marketPlaceModel.result[countID].withDiscount==true?
            
            Align(
                alignment: Alignment.topRight,
                child: 
                Container(
                    height: 20,
                    width: 35,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/discountTag.png"),
                      ),
                    ),
                    child: Center(
                      child: marketPlaceModel
                                  .result[countID].isDiscountPercentage ==
                              true
                          ? Text(
                              "-${marketPlaceModel.result[countID].totalDiscount}%",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 8, color: Colors.white),
                            )
                          : Text(
                              "-${marketPlaceModel.result[countID].totalDiscount}\$",
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
  Widget _textField(String label, _controller) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      height: 45,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: TextFormField(
          enabled: label == "Pin" ? true : false,
          controller: _controller,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
          ],
          keyboardType: TextInputType.phone,
          onFieldSubmitted: (String text) {
            print("$text");
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: HexColor("#FFFFFF"),
            hintText: "$label",
            hintStyle: TextStyle(fontSize: 14, color: Colors.black54),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: HexColor("#707070"))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(width: 1, color: HexColor("#707070"))),
            prefixIcon: Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: Icon(Icons.vpn_key)),
          )),
    );
  }

  Widget _counter() {
    return Container(
      width: MediaQuery.of(context).size.width * .36,
      padding: EdgeInsets.symmetric(horizontal: 5),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  counter >= 2 ? counter = counter - 1 : null;
                });
              },
              child: Container(height: 33, child: Icon(Icons.remove)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 17),
                child: Text(
                  "$counter",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                )),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  counter = counter + 1;
                });
              },
              child: Container(height: 33, child: Icon(Icons.add)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _counter2() {
    return Container(
      width: MediaQuery.of(context).size.width * .36,
      padding: EdgeInsets.symmetric(horizontal: 5),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  counter2 >= 2 ? counter2 = counter2 - 1 : null;
                });
              },
              child: Container(height: 33, child: Icon(Icons.remove)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 17),
                child: Text(
                  "$counter2",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                )),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  counter2 = counter2 + 1;
                });
              },
              child: Container(height: 33, child: Icon(Icons.add)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _counter3() {
    return Container(
      width: MediaQuery.of(context).size.width * .36,
      padding: EdgeInsets.symmetric(horizontal: 5),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  counter3 >= 2 ? counter3 = counter3 - 1 : null;
                });
              },
              child: Container(height: 33, child: Icon(Icons.remove)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 17),
                child: Text(
                  "$counter3",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                )),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  counter3 = counter3 + 1;
                });
              },
              child: Container(height: 33, child: Icon(Icons.add)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomBar() {
    return Container(
      height: MediaQuery.of(context).size.height * .08,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // Expanded(
          //   flex: 2,
          //   child: Container(
          //     margin: EdgeInsets.symmetric(horizontal: 20),
          //     child: RichText(
          //       text: TextSpan(children: [
          //         TextSpan(
          //             text: "Total\n",
          //             style: TextStyle(
          //                 fontSize: 15,
          //                 color: HexColor("#3B444B"),
          //                 fontWeight: FontWeight.bold)),
          //         TextSpan(
          //             text: "\$875",
          //             style: TextStyle(
          //                 fontSize: 12,
          //                 color: HexColor("#3B444B"),
          //                 fontWeight: FontWeight.bold))
          //       ]),
          //     ),
          //   ),
          // ),
         
          Expanded(
            flex: 3,
            child: Container(
              width: MediaQuery.of(context).size.width / 3,
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              child: BottomButton(
                name: "View Cart",
                customColor: true,
                color: HexColor("#FF6D2B"),
                ontap: () {
                  if(User.userData.rememberPin==0)
                  {
                     Fluttertoast.showToast(
          msg: "no PIN found",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
                  }
                  else
                  {
                    AppRoutes.push(context, SellerMycart());
                  }
                  
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
