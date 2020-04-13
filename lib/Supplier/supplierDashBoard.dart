import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:transact/AppBar.dart';
import 'package:flutter/services.dart';
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/Model/supplierdashboardmodel.dart';
import 'package:transact/Supplier/ItemDetails.dart';
import 'package:transact/Supplier/addProduct.dart';
import 'package:transact/Supplier/drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:transact/utils/routes.dart';
import 'package:transact/utils/utils.dart';

class SupplierDashBoard extends StatefulWidget {
  @override
  _SupplierDashBoardState createState() => _SupplierDashBoardState();
}

class _SupplierDashBoardState extends State<SupplierDashBoard> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  DashBoardModel dashBoardModel=DashBoardModel();
  final Color primary = Colors.white;
  ProgressDialog pr;
  String barcode = "Search here";
  final Color active = Colors.grey.shade800;
  final Color divider = Colors.transparent;
  final RefreshController _refreshController = RefreshController();
  bool switchControl = false;
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

getSupplierProduct() async
{
   var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.get(
      "${API.SupplierDashboardProduct}",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if(response.statusCode==200)
    {
      if(Json['Data']['WithError']==true)
      {
         Fluttertoast.showToast(
              msg: "no product found",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
      }
      else
      {
        setState(() {
          dashBoardModel=DashBoardModel.fromJson(Json['Data']);
          User.userData.dashBoardResult=dashBoardModel;
        });
      }
    }
    else
    {
       Fluttertoast.showToast(
              msg: "${response.statusCode}",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
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
  
@override
  void initState() {
    // TODO: implement initState
    super.initState();
getSupplierProduct();
  }

  Future scan() async {
    try {
      String barcode;
      await BarcodeScanner.scan().then((onValue) {
        setState(() {
          barcode = onValue.toString();
          print(onValue);
          User.userData.barCode=barcode;
          
        });
        AppRoutes.push(context, AddProduct());
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
          preferredSize: Size.fromHeight(105.0),
          child: CustomeAppBar(
            homepage: true,
            title: "Home",
            key: _key,
            bottomIcon1: "images/barcode.png",
            bottomIcon1OnTap: () {
              //scan();
              scan();
            },
          ),
        ),
        floatingActionButton: _fab(context),
        drawer: SupplierDrawer(),
      ),
    );
  }

  Widget _sellerHome() {
    return 
Container(
        height: MediaQuery.of(context).size.height / 1.15,
        child: 
            SmartRefresher(
      controller: _refreshController,
onRefresh: ()async
{
  await Future.delayed(Duration(seconds: 3));
getSupplierProduct();
_refreshController.refreshCompleted();
},
enablePullDown: true,

    child:
        StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          itemCount: dashBoardModel.result!=null?dashBoardModel.result.length:0,
          itemBuilder: (BuildContext context, int index) => new Container(
              color: Colors.white,
              child: new Center(
                child:_itemCardSupplier(index),
              )
              ),
          staggeredTileBuilder: (int index) =>
              new StaggeredTile.count(2, index.isEven ? 3.2 : 2.9),
          mainAxisSpacing: 7.0,
          crossAxisSpacing: 7.0,
        )));
  }

  Widget _itemCardSupplier(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          User.userData.index=index;
        });
        AppRoutes.push(context, ItemDetails());
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
                
                  // dashBoardModel.result[index].imagePath==null? Image.asset("images/shirt.png"):
                  
                  // Image.network("${API.API_URL}${dashBoardModel.result[index].imagePath}",
                  // width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height*.2,
                  // ),
                   Container(
                    
                     width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .2,
                    child: dashBoardModel.result[index].imagePath == null
                      ? Image.asset("images/shirt.png")
                      : Image.network(
                          "${API.API_URL}${dashBoardModel.result[index].imagePath}",
                         fit: BoxFit.cover,
                        ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child:Text(
                          "${dashBoardModel.result[index].name}",
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
                        value: dashBoardModel.result[index].isProductVisible,
                        onChanged: (newVal) {

                          productVisibilty(dashBoardModel.result[index].id);
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
                          "\$${dashBoardModel.result[index].actualPrice}",
                          style: TextStyle(
                              decoration:dashBoardModel.result[index].withDiscount==true? TextDecoration.lineThrough:TextDecoration.none,
                              color: HexColor("#707070"),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CaviarDreams'),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        dashBoardModel.result[index].withDiscount==true?
                        Text(
                          "\$${ dashBoardModel.result[index].salePrice}",
                          style: TextStyle(
                              color: HexColor("#515C6F"),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CaviarDreams'),
                        ):Text(
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
                      "Min Order : (${dashBoardModel.result[index].minOrder})",
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
                    _fiveStar(dashBoardModel.result[index].rating),
                      // Expanded(
                      //   child: Container(
                      //     width: 30,
                      //     height: 20,
                      //     child: ListView.builder(
                      //     scrollDirection: Axis.horizontal,
                      //     itemCount: dashBoardModel.result[index].rating,
                      //     itemBuilder: (BuildContext context,int index)
                      //   {
                      //     return showRating();
                      //   },
                        
                      //   ),
                      //   ),
                      // ),
                      // // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: <Widget>[
                      //     Icon(
                      //       Icons.star,
                      //       color: HexColor("#EFCE4A"),
                      //       size: 9,
                      //     ),
                      //     Icon(
                      //       Icons.star,
                      //       color: HexColor("#EFCE4A"),
                      //       size: 9,
                      //     ),
                      //     Icon(
                      //       Icons.star,
                      //       color: HexColor("#EFCE4A"),
                      //       size: 9,
                      //     ),
                      //     Icon(
                      //       Icons.star,
                      //       color: HexColor("#EFCE4A"),
                      //       size: 9,
                      //     ),
                      //     Icon(
                      //       Icons.star,
                      //       color: HexColor("#EFCE4A"),
                      //       size: 9,
                      //     ),
                      //     SizedBox(
                      //       width: 4,
                      //     ),
                      //     Text(
                      //       "(10)",
                      //       style: TextStyle(fontSize: 9),
                      //     ),
                      //   ],
                      // ),
                      
                      dashBoardModel.result[index].qty<=0?
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
          dashBoardModel.result[index].withDiscount==true?
            
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
                      child: dashBoardModel
                                  .result[index].isDiscountPercentage ==
                              true
                          ? Text(
                              "-${dashBoardModel.result[index].totalDiscount}%",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 8, color: Colors.white),
                            )
                          : Text(
                              "-${dashBoardModel.result[index].totalDiscount}\$",
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

  Widget _fab(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          User.userData.barCode="";
                  });
        AppRoutes.push(context, AddProduct());
      },
      child: Container(
        width: MediaQuery.of(context).size.width * .15,
        height: MediaQuery.of(context).size.width * .15,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xff3B444B),
                  const Color(0xff1A956C),
                  const Color(0xff3B444B),
                ]),
            borderRadius: BorderRadius.circular(600)),
        child: Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
  Widget showRating()
  {
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
