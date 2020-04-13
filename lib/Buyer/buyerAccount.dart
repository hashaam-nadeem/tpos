
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:transact/AppBar.dart';
import 'package:transact/Model/ordermodel.dart';
import 'package:transact/changepass.dart';
import 'package:transact/utils/fonts.dart';
import 'package:transact/utils/routes.dart';
import 'package:transact/utils/utils.dart';
import 'package:transact/utils/wishlistproduct.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/Model/marketplacemodel.dart';
import 'package:transact/utils/utils.dart';
class BuyerAccount extends StatefulWidget {
  @override
  _MyAccountSellerState createState() => _MyAccountSellerState();
}

class _MyAccountSellerState extends State<BuyerAccount> {
  var style1 =
      TextStyle(fontFamily: "CaviarDreams", fontSize: 16, color: Colors.black);
       MarketPlaceModel marketPlaceModel = MarketPlaceModel();
       int wishCount=0;
       ProgressDialog pr;
OrderModel orderModel=OrderModel();



          myCancellation() async {
            pr.show();
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.get(
      "${API.CancelList}",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == true) {
        pr.dismiss();
         Fluttertoast.showToast(
              msg: "no any data found",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
        setState(() {
          orderModel = new OrderModel();
        });
      } else {
        pr.dismiss();
        setState(() {
          orderModel = OrderModel.fromJson(Json['Data']);
          //wishCount=marketPlaceModel.result.length;
        });
      }
    } else {
      pr.dismiss();
      Fluttertoast.showToast(
          msg: "response status:  ${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }


         getToPay() async {
           pr.show();
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.get(
      "${API.toPay}",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      
      if (Json['Data']['WithError'] == true) {
        pr.dismiss();
         Fluttertoast.showToast(
              msg: "no any data found",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
        setState(() {
          orderModel = new OrderModel();
        });
      } else {
        pr.dismiss();
        setState(() {
          orderModel = OrderModel.fromJson(Json['Data']);
          //wishCount=marketPlaceModel.result.length;
        });
      }
    } else {
      pr.dismiss();
      Fluttertoast.showToast(
          msg: "response status:  ${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }



         searchProduct() async {
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.get(
      "${API.getWishList}",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == true) {
        //  Fluttertoast.showToast(
        //       msg: "no product found",
        //       textColor: Colors.white,
        //       backgroundColor: Colors.blueGrey);
        setState(() {
          marketPlaceModel = new MarketPlaceModel();
        });
      } else {
        setState(() {
          marketPlaceModel = MarketPlaceModel.fromJson(Json['Data']);
          wishCount=marketPlaceModel.result.length;
        });
      }
    } else {
      Fluttertoast.showToast(
          msg: "response status:  ${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchProduct();
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
      backgroundColor: HexColor("#F5F7FA"),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(115),
        child: CustomeAppBar(
            homepage: false,
            title: "My Account",
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[_accountInfo(), _wishList()],
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
        children: <Widget>[_myOrders(), 
        
       // _eWallet(),
       changePass(),
        listOrder(),
        
        
        ],
      ),
      )
    ));
  }

Widget changePass()
{
  return GestureDetector(
    onTap: ()
    {
      AppRoutes.push(context, ChangePassword());
    },
    child:   Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height*.1,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color:Colors.green,width:1),
      borderRadius: BorderRadius.all(Radius.circular(8))
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left:10,right:10),
          child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Change password",style: TextStyle(
              color: Colors.blueGrey,fontSize: 18,
              fontWeight: FontWeight.bold,
            ),),
            Icon(Icons.settings),
          ],
        ),
      
        ),
      ],
    ),
  )
  );
}
Widget listOrder()
{
  return  Container(
//padding: EdgeInsets.only(left:10,right:10),
    //width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height*.4,
    child: ListView.builder(itemBuilder: (BuildContext context,int index)
                  {
                    return listOrders(index);
                  },
                  itemCount: orderModel.result!=null?orderModel.result.length:0,
                  )
  );
}

Widget listOrders(int index)
{
  return Container(
    margin: EdgeInsets.only(right:10,left:10),
    decoration: BoxDecoration(
      color: Colors.white,
      //border: Border.all(color:Colors.grey,width: 0.5)
    ),
    height: 30,
    child: Column(
      children: <Widget>[
       Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: <Widget>[
           Text("${orderModel.result[index].id}",style: TextStyle(
             color: Colors.grey,fontSize: 17,
           ),),
           Text("${orderModel.result[index].orderNumber}",style: TextStyle(
             color: Colors.grey,fontSize: 17,
           ),),
           Text("\$${orderModel.result[index].totalBill}",style: TextStyle(
             color: Colors.grey,fontSize: 17,
           ),),
         ],
       ),
      ],
    ),
  );
}
  
  Widget _wishList() {
    return 
    
    GestureDetector(
      onTap: ()
      {
        AppRoutes.push(context,WishList());
      },
      child: Container(
      child: Column(
        children: <Widget>[
          Text(
            "$wishCount",
            style: blackbold.copyWith(
                
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.normal),
          ),
          Text("My Wishlist",
              style: blackbold.copyWith(
                  height: 2,
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal))
        ],
      ),
    )
    );
  }

  Widget _eWallet() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      margin: EdgeInsets.symmetric(vertical: 5),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "E-Wallet",
                style: style1,
              ),
              InkWell(
                  onTap: () {
                    print("Activated");
                  },
                  child: Text(
                    "Activate Now",
                    style: style1.copyWith(
                        decoration: TextDecoration.underline, fontSize: 12),
                  )),
            ],
          ),
          Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 10),
              child: Column(
                children: <Widget>[
                  Text(
                    "\$0",
                    style: style1.copyWith(
                        color: HexColor("#E23737"), fontFamily: "Roboto"),
                  ),
                  Text("Balance", style: style1.copyWith(fontSize: 18)),
                ],
              ))
        ],
      ),
    );
  }

  Widget _myOrders() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      margin: EdgeInsets.symmetric(vertical: 5),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "My Orders",
                style: style1,
              ),
              // InkWell(
              //     onTap: () {
              //       print("Activated");
              //     },
              //     child: Text(
              //       "View All",
              //       style: style1.copyWith(
              //           decoration: TextDecoration.underline, fontSize: 12),
              //     )),
            ],
          ),
          Row(
            children: <Widget>[
              _orderType("images/pay.png", "To Pay"),
             // _orderType("images/return.png", "My Return"),
              _orderType("images/cargo.png", "My Cancelation"),
            ],
          )
        ],
      ),
    );
  }

  Widget _orderType(String image, String text) {
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 15, right: 40),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if(text=="To Pay")
              {
                getToPay();
              }
              else if(text=="My Cancelation")
              {
                myCancellation();
              }
              print("$text");
            },
            child: Image(
              height: 50,
              width: 40,
              image: AssetImage("$image"),
            ),
          ),
          Text(
            "$text",
            style: style1.copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _accountInfo() {
    return Container(
      margin: EdgeInsets.only(top: 5, left: 20),
      child: Row(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(right: 10),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                backgroundImage: 
                User.userData.userResult.imageUrl!=null?
                NetworkImage("${API.API_URL}${ User.userData.userResult.imageUrl}")
                :
                AssetImage("images/myImage.jpg"),
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${User.userData.userResult.fullname}",
                style: style1.copyWith(
                    fontFamily: "ProbaPro", fontSize: 18, color: Colors.white),
              ),
              Text(
                "${User.userData.userResult.email}",
                style: style1.copyWith(
                    fontSize: 12, fontFamily: "ProbaPro", color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:transact/AppBar.dart';
// import 'package:transact/utils/fonts.dart';
// import 'package:transact/utils/routes.dart';
// import 'package:transact/utils/utils.dart';
// import 'package:transact/utils/wishlistproduct.dart';
// import 'package:http/http.dart'as http;
// import 'package:transact/utils/wishlistproduct.dart';
// import 'dart:convert';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:transact/Model/UserModel.dart';
// import 'package:transact/Model/apismodel.dart';
// import 'package:transact/Model/getauthentication.dart';
// import 'package:transact/Model/marketplacemodel.dart';
// import 'package:transact/utils/utils.dart';

// class BuyerAccount extends StatefulWidget {
//   @override
//   _BuyerAccountState createState() => _BuyerAccountState();
// }

// class _BuyerAccountState extends State<BuyerAccount> {
//   var style1 =
//       TextStyle(fontFamily: "CaviarDreams", fontSize: 16, color: Colors.black);
//       int wishCount=0;
//        MarketPlaceModel marketPlaceModel = MarketPlaceModel();

//               searchProduct() async {
//     var header = {
//       "Authorization": AuthenticationUser.getAuthentication(),
//     };
//     var response = await http.get(
//       "${API.getWishList}",
//       headers: header,
//     );
//     var Json = json.decode(response.body);
//     print(json.decode(response.body));
//     if (response.statusCode == 200) {
//       if (Json['Data']['WithError'] == true) {
//         //  Fluttertoast.showToast(
//         //       msg: "no product found",
//         //       textColor: Colors.white,
//         //       backgroundColor: Colors.blueGrey);
//         setState(() {
//           marketPlaceModel = new MarketPlaceModel();
//         });
//       } else {
//         setState(() {
//           marketPlaceModel = MarketPlaceModel.fromJson(Json['Data']);
//           wishCount=marketPlaceModel.result.length;
//         });
//       }
//     } else {
//       Fluttertoast.showToast(
//           msg: "response status:  ${response.statusCode}",
//           textColor: Colors.white,
//           backgroundColor: Colors.blueGrey);
//     }
//   }

// @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     searchProduct();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//       backgroundColor: HexColor("#F5F7FA"),
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(115),
//         child: CustomeAppBar(
//             homepage: false,
//             title: "My Account",
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[_accountInfo(), _wishList()],
//             )),
//       ),
//       body: Column(
//         children: <Widget>[_myOrders(),
//         //_eWallet()
//         ],
//       ),
//     ));
//   }

//   Widget _eWallet() {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
//       margin: EdgeInsets.symmetric(vertical: 5),
//       color: Colors.white,
//       child: Column(
//         children: <Widget>[
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Text(
//                 "E-Wallet",
//                 style: style1,
//               ),
//               InkWell(
//                   onTap: () {
//                     print("Activated");
//                   },
//                   child: Text(
//                     "Activate Now",
//                     style: style1.copyWith(
//                         decoration: TextDecoration.underline, fontSize: 12),
//                   )),
//             ],
//           ),
//           Container(
//               alignment: Alignment.center,
//               margin: EdgeInsets.only(top: 10),
//               child: Column(
//                 children: <Widget>[
//                   Text(
//                     "\$0",
//                     style: style1.copyWith(
//                         color: HexColor("#E23737"), fontFamily: "Roboto"),
//                   ),
//                   Text("Balance", style: style1.copyWith(fontSize: 18)),
//                 ],
//               ))
//         ],
//       ),
//     );
//   }

//   Widget _myOrders() {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
//       margin: EdgeInsets.symmetric(vertical: 5),
//       color: Colors.white,
//       child: Column(
//         children: <Widget>[
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Text(
//                 "My Orders",
//                 style: style1,
//               ),
//               InkWell(
//                   onTap: () {
//                     print("Activated");
//                   },
//                   child: Text(
//                     "View All",
//                     style: style1.copyWith(
//                         decoration: TextDecoration.underline, fontSize: 12),
//                   )),
//             ],
//           ),
//           Row(
//             children: <Widget>[
//               _orderType("images/pay.png", "To Pay"),
//               _orderType("images/cargo.png", "My Cancelation"),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Widget _orderType(String image, String text) {
//     return Container(
//       margin: EdgeInsets.only(top: 15, bottom: 15, right: 40),
//       child: Column(
//         children: <Widget>[
//           GestureDetector(
//             onTap: () {
//               print("$text");
//             },
//             child: Image(
//               height: 50,
//               width: 40,
//               image: AssetImage("$image"),
//             ),
//           ),
//           Text(
//             "$text",
//             style: style1.copyWith(fontSize: 10),
//           ),
//         ],
//       ),
//     );
//   }

//    Widget _accountInfo() {
//     return Container(
//       margin: EdgeInsets.only(top: 5, left: 20),
//       child: Row(
//         children: <Widget>[
//           Container(
//               margin: EdgeInsets.only(right: 10),
//               child: CircleAvatar(
//                 radius: 28,
//                 backgroundImage: User.userData.userResult.imageUrl!=null?
//                 NetworkImage("${API.API_URL}${ User.userData.userResult.imageUrl}")
//                 :
//                 AssetImage("images/myImage.jpg"),
//               )),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 "${User.userData.userResult.fullname}",
//                 style: style1.copyWith(
//                     fontFamily: "ProbaPro", fontSize: 18, color: Colors.white),
//               ),
//               Text(
//                 "${User.userData.userResult.email} ",
//                 style: style1.copyWith(
//                     fontSize: 12, fontFamily: "ProbaPro", color: Colors.white),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Widget _wishList() {
//     return 
    
//     GestureDetector(
//       onTap: ()
//       {
//         AppRoutes.push(context,WishList());
//       },
//       child: Container(
//       child: Column(
//         children: <Widget>[
//           Text(
//             "$wishCount",
//             style: blackbold.copyWith(
                
//                 color: Colors.white,
//                 fontSize: 26,
//                 fontWeight: FontWeight.normal),
//           ),
//           Text("My Wishlist",
//               style: blackbold.copyWith(
//                   height: 2,
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.normal))
//         ],
//       ),
//     )
//     );
//   }
// }
