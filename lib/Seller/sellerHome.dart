import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'package:transact/AppBar.dart';
import 'package:transact/Buyer/allCatagories.dart';
import 'package:transact/Buyer/buyerCart.dart';
import 'package:transact/Buyer/itemDetails.dart';
import 'package:transact/Model/marketplacemodel.dart';
import 'package:transact/Seller/addProduct.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:transact/Seller/drawer.dart';
import 'package:transact/Seller/mycart.dart';
import 'package:transact/Seller/notifications.dart';
import 'package:transact/Supplier/ItemDetails.dart';
import 'package:flutter/services.dart';
import 'package:transact/utils/floatingButton.dart';
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/utils/routes.dart';
import 'package:transact/utils/toast.dart';
import 'package:transact/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/Model/supplierdashboardmodel.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SellerHome extends StatefulWidget {
  @override
  _SellerHomeState createState() => _SellerHomeState();
}

class _SellerHomeState extends State<SellerHome> {
  String barcode = "Search here";
  ProgressDialog pr;
  DashBoardModel dashBoardModel = DashBoardModel();
  MarketPlaceModel marketPlaceModel = MarketPlaceModel();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final Color primary = Colors.white;
  final RefreshController _refreshController = RefreshController();
  final Color active = Colors.grey.shade800;
  final Color divider = Colors.transparent;
  bool switchControl = false;
  bool order=false;
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

 productVisibilty(int Id)async
{
  
  pr.show();
  var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var body = {
      "productId":"$Id"
      // "Password": "${loginPass.text.trim()}",
      // "DeviceNumber": "$deviceId",
      // "FCM": "$notificationToken",
    };
    print(body);
    var response = await http.post(
      "${API.productsVisibilty}",
      body: body,
      headers: header,
    );
    print(json.decode(response.body));
    var Json = json.decode(response.body);
    if(response.statusCode==200)
    {

       if (Json['Data']['WithError'] == false)
       {
         pr.dismiss();
         getSupplierProduct();
        // setState(() {
                            
        //                     User.userData.userResult.isOnline = newVal;
        //                   });
          Fluttertoast.showToast(
            msg: "${Json['Data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
         //AppRoutes.push(context, EmailVerification());
         //Navigator.of(context).pop();

       }
       else
       {
         pr.dismiss();
         Fluttertoast.showToast(
            msg: "${Json['Data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
       }
    }
    else
    {
      pr.dismiss();
      Fluttertoast.showToast(
              msg: "response status: ${response.statusCode}",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
    }
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
      message: 'Updating...',
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
        body: _sellerHome(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(125.0),
          child: CustomeAppBar(
            homepage: true,
            title: "HOME",
            key: _key,
            type: "Buyer",
            suffix: true,
            suffixIcon: "images/bell.png",
            suffixOnTap: () {
              AppRoutes.push(context, SellerNotifications());
            },
            bottomIcon1: "images/barcode.png",
            bottomIcon1OnTap: () {
              scan();
            },
            bottomIcon2: "images/cart4.png",
            bottomIcon2OnTap: () {
              AppRoutes.push(context, BuyerCart());
            },
          ),
        ),
        floatingActionButton: CustomFloatingButton(
          ontap: () {
            setState(() {
              User.userData.barCode="";
            });
            AppRoutes.push(context, AddProductSeller());
          },
        ),
        drawer: SellerDrawer(),
      ),
    );
  }

  Widget _sellerHome() {
    return Container(
        height: MediaQuery.of(context).size.height / 1.15,
        child: SmartRefresher(
            controller: _refreshController,
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 3));
              getSupplierProduct();
              _refreshController.refreshCompleted();
            },
            enablePullDown: true,
            child: StaggeredGridView.countBuilder(
              crossAxisCount: 4,
              itemCount: marketPlaceModel.result != null
                  ? marketPlaceModel.result.length
                  : 0,
              itemBuilder: (BuildContext context, int index) => new Container(
                  color: Colors.white,
                  child: new Center(
                    child: _itemCardSupplier(index),
                  )),
              staggeredTileBuilder: (int index) =>
                  new StaggeredTile.count(2, index.isEven ? 3.4 : 3.2),
              mainAxisSpacing: 7.0,
              crossAxisSpacing: 7.0,
            )));
  }

  Widget _itemCardSupplier(int index) {
    return GestureDetector(
      onTap: () {
        // setState(() {
        //   User.userData.index=index;
        // });
        // // AppRoutes.push(context, ItemDetails());
        // //AppRoutes.push(context, AllCategories());
        // AppRoutes.push(context, ItemDetailsBuyer());
      },
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 4),
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
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
                         child: Text(
                          "${marketPlaceModel.result[index].name}",
                          style: TextStyle(
                              color: HexColor("#3B444B"),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CaviarDreams'),
                        ),
                       ),
                        Container(
                   // margin: EdgeInsets.only(top: 30, right: 15),
                   //wsidth: 30,
                    child: Switch(
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.grey,
                        value: marketPlaceModel.result[index].isProductVisible,
                        onChanged: (newVal) {
                          productVisibilty(marketPlaceModel.result[index].id);
                         // updateIsOnline(newVal);
                          
                          //print("$storeOpen");
                        }),
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
                   Row(
                  
                    children: <Widget>[
                      marketPlaceModel.result[index].gst.toString().isEmpty?
                      Text("")
                      :
                       Text(
                          "including ${marketPlaceModel.result[index].gst}% gst",
                          style: TextStyle(
                              color: HexColor("#3B444B"),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CaviarDreams'),
                        ),
                    ],
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
                      _fiveStar(marketPlaceModel.result[index].rating),
                      //  Expanded(
                      //   child: Container(
                      //     width: 30,
                      //     height: 20,
                      //     child: ListView.builder(
                      //     scrollDirection: Axis.horizontal,
                      //     itemCount: dashBoardModel.result!=null?dashBoardModel.result[index].rating:0,
                      //     itemBuilder: (BuildContext context,int index)
                      //   {
                      //     return showRating();
                      //   },
                        
                      //   ),
                      //   ),
                      // ),
                     
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
                      ),
                    ],
                  )
                ],
              ),
            ),
           marketPlaceModel.result[index].withDiscount==true?
            
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

  Widget _itemCardSeller() {
    return GestureDetector(
      onTap: () {
        AppRoutes.push(context, ItemDetails());
      },
      child: Container(
        //margin: EdgeInsets.only(left: 5, top: 5, bottom: 2),

        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Image(
                    image: AssetImage("images/shirt.png"),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "V Neck Shirt - Black",
                          style: TextStyle(
                              color: HexColor("#3B444B"),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CaviarDreams'),
                        ),
                      ],
                    ),
                  ),
                  Row(children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "\$24.99",
                          style: TextStyle(
                              color: HexColor("#707070"),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CaviarDreams'),
                        ),
                      ),
                    ),
                    Expanded(flex: 3, child: _dropdownbutton())
                  ]),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "\$58.99",
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: HexColor("#707070"),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CaviarDreams'),
                        ),
                        Switch(
                          onChanged: toggleSwitch,
                          value: switchControl,
                          activeColor: HexColor("#4D8DBF"),
                          activeTrackColor: HexColor("#BFBFBF"),
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey,
                        )
                      ],
                    ),
                  ),
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
                      child: Text(
                        "-10%",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ))),
          ],
        ),
      ),
    );
  }

  Future scan() async {
    try {
      String barcode;
      await BarcodeScanner.scan().then((onValue) {
        setState(() {
          barcode = onValue.toString();
          User.userData.barCode=barcode;
          AppRoutes.push(context, AddProductSeller());
        });
      }).catchError((onError) {
        print(onError);
      });
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'camera permission not granted!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode = '(User returned)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  Widget _dropdownbutton() {
    return Container(
      height: 20,
      child: DropdownButton<String>(
        elevation: 2,
        underline: Container(
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.transparent, width: 0.0))),
        ),
        icon: Icon(
          Icons.more_vert,
          size: 24,
        ),
        items: <String>[
          "Edit Product",
          "Delete Product",
        ].map((String value) {
          return new DropdownMenuItem<String>(
            value: value,
            child: new Text(value),
          );
        }).toList(),
        onChanged: (value) async {
          if (value == "Edit Product") {
          } else if (value == "Delete Product") {
            print("share");
          }

          print("hello");
        },
      ),
    );
  }

  void _showToast(String msg) {
    showToast(
      "$msg",
      context: context,
      position: StyledToastPosition.bottom,
      backgroundColor: Colors.black54,
      duration: Duration(seconds: 2),
      onDismiss: () {},
      animation: StyledToastAnimation.slideFromLeft,
      animDuration: Duration(milliseconds: 200),
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
