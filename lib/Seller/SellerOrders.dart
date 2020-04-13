


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:transact/AppBar.dart';
import 'package:http/http.dart' as http;
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/Model/ordermodel.dart';
import 'package:transact/utils/bottomButton.dart';
import 'package:transact/utils/feedback.dart';
import 'package:transact/utils/routes.dart';
import 'dart:convert';
import 'package:transact/utils/togglebuttons.dart';
import 'package:transact/utils/utils.dart';

class SellerOrders extends StatefulWidget {
  @override
  _SellerOrders createState() => _SellerOrders();
}

class _SellerOrders extends State<SellerOrders> {
  ///////////// font style///////////////////////////////
  var style = TextStyle(
      fontFamily: "CaviarDreams", fontSize: 16, fontWeight: FontWeight.bold);
  var style2 = TextStyle(
      fontFamily: "CaviarDreams",
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: HexColor("#6B6B6B"));
  ////////////////////////////////////////////////////////

  var formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  List<bool> _selection = [true, false, false];
  bool order = false;
  int selectedIndex;
  ProgressDialog pr;
  bool pending = true, inProcess = false, rejected = false, delivered = false;
  OrderModel orderModel = OrderModel();


  getPendingList() async {
    pr.show();
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.get(
      "${API.getMyOrder}?status=0",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == false) {
        pr.dismiss();
        setState(() {
          orderModel = OrderModel.fromJson(Json['Data']);
          User.userData.orderModel=orderModel;
        });
      } else {
        pr.dismiss();
        Fluttertoast.showToast(
            msg: "${Json['data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);

        setState(() {
          orderModel = OrderModel();
        });
      }
    } else {
      pr.dismiss();
      Fluttertoast.showToast(
          msg: "response status: ${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }

  getInProcessList() async {
    pr.show();
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.get(
      "${API.getMyOrder}?status=1",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == false) {
        pr.dismiss();
        setState(() {
          orderModel = OrderModel.fromJson(Json['Data']);
          User.userData.orderModel=orderModel;
        });
      } else {
        pr.dismiss();
        Fluttertoast.showToast(
            msg: "${Json['data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);

        setState(() {
          orderModel = OrderModel();
        });
      }
    } else {
      pr.dismiss();
      Fluttertoast.showToast(
          msg: "response status: ${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }

  getRejectedList() async {
    pr.show();
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.get(
      "${API.getMyOrder}?status=2",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == false) {
        pr.dismiss();
        setState(() {
          orderModel = OrderModel.fromJson(Json['Data']);
        });
      } else {
        pr.dismiss();
        Fluttertoast.showToast(
            msg: "${Json['data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);

        setState(() {
          orderModel = OrderModel();
        });
      }
    } else {
      pr.dismiss();
      Fluttertoast.showToast(
          msg: "response status: ${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }

  getDeliveredList() async {
    pr.show();
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.get(
      "${API.getMyOrder}?status=3",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == false) {
        pr.dismiss();
        setState(() {
          orderModel = OrderModel.fromJson(Json['Data']);
          User.userData.orderModel=orderModel;
        });
      } else {
        pr.dismiss();
        Fluttertoast.showToast(
            msg: "${Json['data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);

        setState(() {
          orderModel = OrderModel();
        });
      }
    } else {
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
    getPendingList();
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
          backgroundColor: HexColor("#F5F7FA"),
          // bottomNavigationBar:
          //     order == true && !_selection[2] ? _bottom() : null,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(order == false ? 110 : 70),
            child: CustomeAppBar(
              homepage: false,
              title: "My Orders",
              // child: order == false
              //     ? Buttons
              //     : Container(),
            ),
          ),
          body: order == false
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Buttons(),
                        ],
                      ),
                      Expanded(
                          child: ListView.builder(
                        itemCount: orderModel.result != null
                            ? orderModel.result.length
                            : 0,
                        itemBuilder: (context, index) {
                          return _orderNumber(index);
                        },
                      )),
                    ],
                  ),
                )
              : _order()),
    );
  }



  Widget Buttons() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .08,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.blueGrey, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                setState(() {
                  pending = true;
                  inProcess = false;
                  rejected = false;
                  delivered = false;
                });
                getPendingList();
              },
              child: Container(
                width: MediaQuery.of(context).size.width * .2,
                height: MediaQuery.of(context).size.height * .06,
                decoration: BoxDecoration(
                    color: pending == true ? HexColor("#3B444B") : Colors.white,
                    border: Border.all(color: Colors.blueGrey, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(
                  child: Text(
                    "Pending",
                    style: TextStyle(
                        color: pending == true
                            ? Colors.white
                            : HexColor("#3B444B"),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  pending = false;
                  inProcess = true;
                  rejected = false;
                  delivered = false;
                });
                getInProcessList();
              },
              child: Container(
                width: MediaQuery.of(context).size.width * .2,
                height: MediaQuery.of(context).size.height * .06,
                decoration: BoxDecoration(
                    color:
                        inProcess == true ? HexColor("#3B444B") : Colors.white,
                    border: Border.all(color: Colors.blueGrey, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(
                  child: Text(
                    "In Process",
                    style: TextStyle(
                        color: inProcess == true
                            ? Colors.white
                            : HexColor("#3B444B"),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  pending = false;
                  inProcess = false;
                  rejected = true;
                  delivered = false;
                });
                getRejectedList();
              },
              child: Container(
                width: MediaQuery.of(context).size.width * .2,
                height: MediaQuery.of(context).size.height * .06,
                decoration: BoxDecoration(
                    color:
                        rejected == true ? HexColor("#3B444B") : Colors.white,
                    border: Border.all(color: Colors.blueGrey, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(
                  child: Text(
                    "Rejected",
                    style: TextStyle(
                        color: rejected == true
                            ? Colors.white
                            : HexColor("#3B444B"),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  pending = false;
                  inProcess = false;
                  rejected = false;
                  delivered = true;
                });
                getDeliveredList();
              },
              child: Container(
                width: MediaQuery.of(context).size.width * .2,
                height: MediaQuery.of(context).size.height * .06,
                decoration: BoxDecoration(
                    color:
                        delivered == true ? HexColor("#3B444B") : Colors.white,
                    border: Border.all(color: Colors.blueGrey, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(
                  child: Text(
                    "Delivered",
                    style: TextStyle(
                        color: delivered == true
                            ? Colors.white
                            : HexColor("#3B444B"),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderNumber(int index) {
    return InkWell(
      onTap: () {
        if(orderModel.result[index].status==3)
        {
          setState(() {
            User.userData.index=index;
          });
          AppRoutes.push(context, FeedBack());
        }
        else
        {
          setState(() {
            selectedIndex=index;
          });
          setState(() {
            order=true;
          });
          //_showDialog();
        }
        // if(
        // orderModel.result[index].status==2 || 
        // orderModel.result[index].status==3 
        // )
        // {

        // }
        // else if(orderModel.result[index].status==1)
        // {
        //   setState(() {
        //     selectedIndex = index;
        //   });
        //   _showDialog();
        // }
        // else
        // {
        //    setState(() {
        //   order = true;
        //   selectedIndex = index;
        // });
        // }
       
        // _customerDetails();
      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 7),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: Text("${orderModel.result[index].date}",
                      style:
                          TextStyle(color: HexColor("#9E9E9E"), fontSize: 12)),
                ),
                Text(
                  "Order #  ${orderModel.result[index].orderNumber}",
                  style: style,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "by ${orderModel.result[index].customerName}",
                      style: style2,
                    ),
                    Text(
                      _selection[1]
                          ? "Approved"
                          : _selection[2] ? "Delivered" : "",
                      style: style2.copyWith(
                          color: _selection[1]
                              ? HexColor("#078703")
                              : HexColor("#FF0000")),
                    )
                  ],
                ),
                _selection[2]
                    ? Text(
                        "Delivery Date : 20-01-2020",
                        style: style2,
                      )
                    : Container(),
                Row(children: <Widget>[
                  Text(
                    "Payment Method",
                    style: style2,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  orderModel.result[index].paymentMethod == 0
                      ? Text(
                          "COD",
                          style: style,
                        )
                      : orderModel.result[index].paymentMethod == 1
                          ? Text(
                              "Card",
                              style: style,
                            )
                          : Text(
                              "Bank",
                              style: style,
                            )
                ]),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text("\$${orderModel.result[index].totalBill}",
                      style: style),
                ),
              ])),
    );
  }

  Widget _order() {
    return Container(
      child: Column(
        children: <Widget>[_orderDetails(), _customerDetails()],
      ),
    );
  }

Widget _orderDetails() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .5,
        // margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                onTap: ()
                {
                  setState(() {
                    order=false;
                  });
                },
                child: Icon(Icons.cancel),

              ),
            ],
          ),
              Text(
                "Order Detail",
                style: style.copyWith(color: HexColor("#6B6B6B"), fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Text(
                "  Order# ",
                style: style.copyWith(color: Colors.black, fontSize: 17),
              ),
              Text(
                "${orderModel.result[selectedIndex].orderNumber}",
                style: style.copyWith(color: Colors.black, fontSize: 14),
              ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Text(
                "  by  ",
                style: style.copyWith(color: Colors.black, fontSize: 17),
              ),
              Text(
                "${orderModel.result[selectedIndex].customerName}",
                style: style.copyWith(color: Colors.black, fontSize: 14),
              ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Text(
                "  Payment Method:  ",
                style: style.copyWith(color: Colors.black, fontSize: 17),
              ),
              orderModel.result[selectedIndex].paymentMethod==0?
              Text(
                "Cod",
                style: style.copyWith(color: Colors.black, fontSize: 14),
              ):
              orderModel.result[selectedIndex].paymentMethod==1?
              Text(
                "Card",
                style: style.copyWith(color: Colors.black, fontSize: 14),
              ):
              Text(
                "Bank",
                style: style.copyWith(color: Colors.black, fontSize: 14),
              ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right:10),
                    child: Text(
                "${orderModel.result[selectedIndex].totalBill}",
                style: style.copyWith(color: Colors.black, fontSize: 14),
              ),
                  ),
                ],
              ),
              _divider(),
              Expanded(
                child: ListView.builder(
                    itemCount:
                        orderModel.result[selectedIndex].lineDetail != null
                            ? orderModel.result[selectedIndex].lineDetail.length
                            : 0,
                    itemBuilder: (BuildContext context, int index) {
                      return productsDetail(index);
                    }),
              ),
            ]));
  }




  Widget productsDetail(int index) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Wrap(
                  children: <Widget>[
                    // Image(
                    //   height: MediaQuery.of(context).size.height * .14,
                    //   width: MediaQuery.of(context).size.width * .3,
                    //   image: AssetImage("images/iphone.png"),
                    // ),
                    orderModel.result[selectedIndex].lineDetail[index]
                                .imageUrl !=
                            null
                        ? Image.network(
                            "${API.API_URL}${orderModel.result[selectedIndex].lineDetail[index].imageUrl}",
                            height: MediaQuery.of(context).size.height * .14,
                            width: MediaQuery.of(context).size.width * .3,
                          )
                        : Image.asset(
                            "images/iphone.png",
                            height: MediaQuery.of(context).size.height * .14,
                            width: MediaQuery.of(context).size.width * .3,
                          ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "${orderModel.result[selectedIndex].lineDetail[index].productName}",
                          style: style.copyWith(color: HexColor("#6B6B6B")),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                         "${orderModel.result[selectedIndex].lineDetail[index].qty} * ${orderModel.result[selectedIndex].lineDetail[index].price}",
                          textAlign: TextAlign.start,
                          style: style2,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Text(
                "\$${orderModel.result[selectedIndex].lineDetail[index].total}",
                style: style,
              ),
            ],
          ),
        ],
      ),
    );
  }


  deliverOrder(int id) async {
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var body = {"orderID": "$id"};
    var response =
        await http.post("${API.deliverOrder}", headers: header, body: body);
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if(response.statusCode==200)
    {
      if(Json['Data']['WithError']==false)
      {
        pr.dismiss();
        setState(() {
          order=false;
        });
        Navigator.of(context).pop();
        getInProcessList();
 Fluttertoast.showToast(
          msg: "${Json['Data']['ShortMessage']}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
      }
      else
      {
        pr.dismiss();
        setState(() {
          order=false;
        });
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
          setState(() {
          order=false;
        });
    
    }
  }


  acceptOrder(int id) async {
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var body = {"orderID": "$id"};
    var response =
        await http.post("${API.AcceptOrder}", headers: header, body: body);
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if(response.statusCode==200)
    {
      if(Json['Data']['WithError']==false)
      {
        pr.dismiss();
        setState(() {
          order=false;
        });
        getPendingList();
 Fluttertoast.showToast(
          msg: "${Json['Data']['ShortMessage']}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
      }
      else
      {
        pr.dismiss();
        setState(() {
          order=false;
        });
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
          setState(() {
          order=false;
        });
    
    }
  }

  rejectOrder(int id) async {
    pr.show();
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var body = {"orderID": "$id"};
    var response =
        await http.post("${API.RejectOrder}", headers: header, body: body);
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if(response.statusCode==200)
    {
      if(Json['Data']['WithError']==false)
      {
        pr.dismiss();
        setState(() {
          order=false;
        });
        getPendingList();
 Fluttertoast.showToast(
          msg: "${Json['Data']['ShortMessage']}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
      }
      else
      {
        pr.dismiss();
         Fluttertoast.showToast(
          msg: "${Json['Data']['ShortMessage']}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
          setState(() {
          order=false;
        });
      }
    }
    else
    {
      pr.dismiss();
      Fluttertoast.showToast(
          msg: "response status: ${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
          setState(() {
          order=false;
        });
    
    }
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      height: 1,
      color: HexColor("#707070"),
    );
  }

  Widget _customerDetails() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 1),
              child: Text(
                "Customer Details",
                style: style2.copyWith(fontSize: 16),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${orderModel.result[selectedIndex].customerName}",
                    style: style2.copyWith(
                        fontFamily: "antipasto",
                        fontSize: 18,
                        color: Colors.black),
                  ),
                  Text(
                    "Customer Name",
                    style: style2.copyWith(fontSize: 12),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "ABN",
                    style: style2.copyWith(
                        fontFamily: "antipasto",
                        fontSize: 18,
                        color: Colors.black),
                  ),
                  Text(
                    "Delivery",
                    style: style2.copyWith(fontSize: 12),
                  ),
                ],
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              children: <Widget>[
                Image(
                    height: 20,
                    width: 20,
                    image: AssetImage("images/call.png")),
                orderModel.result[selectedIndex].customerNumber != null
                    ? Text(
                        "  ${orderModel.result[selectedIndex].customerNumber}")
                    : Text("  contact no")
              ],
            ),
          ),
          // Container(
          //   margin: EdgeInsets.only(top: 10, bottom: 10),
          //   child: Row(
          //     children: <Widget>[
          //       Image(
          //           height: 20, width: 20, image: AssetImage("images/msg.png")),
          //       Text("  Chat"),
          //     ],
          //   ),
          // ),
          
        ],
      ),
    );
  }
 
 void _showDialog() {
    showDialog(
        context: context,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: 
          Container(
            padding: EdgeInsets.only(top: 20, left: 15, right: 15),
            height: MediaQuery.of(context).size.height * .65,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                  )
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(35),
                    topLeft: Radius.circular(35))),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      Navigator.of(context).pop();
                    });
                  },
                  child: Container(
                    height: 20,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(top: 10, right: 10),
                    child: Image.asset("images/cross.png"),
                  ),
                ),
                // _orderDetailLine("Order #", "CK12FGH"),
                // _orderDetailLine("Placed on    ", "10-01-2020"),
                // _orderDetailLine("Received on", "20-01-2020"),
                _product(),
                _divider(),
              orderModel.result[selectedIndex].paymentMethod==0?
                Text("Payment Method: COD"):
                orderModel.result[selectedIndex].paymentMethod==1?
                Text("Payment Method: CARD"):
                Text("BANK"),
                Text(
                 "Order Number: ${orderModel.result[selectedIndex].orderNumber}",
                textAlign: TextAlign.left,
                style: TextStyle(
                    height: 1.4, fontSize: 14, color: HexColor("#515C6F")),
              ),
                // _rate(),
                // _divider(),
                // _title("Write a Review"),
                // _textFormField(
                //   "Write here...",
                //   comment
                // ),
                // Container(
                //   margin: EdgeInsets.only(
                //       left: 20, right: 20, top: 14, bottom: 0.0),
                //   child: BottomButton(
                //     name: "Send Feed Back",
                //     ontap: () {
                //       print(comment.text);
                //       Navigator.pop(context);
                //     },
                //   ),
                // ),
              ],
            ),
          )),
    );
  }

  Widget _bottom() {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height * .08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _button("Cancel Order"),
          _button("Accept Order"),
        ],
      ),
    );
  }
Widget _product() {
    return Container(
      child: Row(
        children: <Widget>[
          // Container(
          //   alignment: Alignment.centerLeft,
          //   height: 70,
          //   width: 70,
          //   child: NetworkImage("${API.API_URL}${orderModel.result[selectedIndex].totalBill}"),
          // ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${orderModel.result[selectedIndex].customerName}",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                 "\$${orderModel.result[selectedIndex].totalBill}",
                textAlign: TextAlign.left,
                style: TextStyle(
                    height: 1.4, fontSize: 14, color: HexColor("#515C6F")),
              ),
               
            ],
          ),
        ],
      ),
    );
  }



  Widget _button(String name) {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(left: 10, right: 10),
      padding: EdgeInsets.symmetric(horizontal: 30),
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: name == "Cancel Order" ? Colors.white70 : HexColor("#3B444B")),
      child: GestureDetector(
        onTap: () {
          if (name == "Cancel Order") {
            rejectOrder(orderModel.result[selectedIndex].id);
          } else if (name == "Accept Order") {
            acceptOrder(orderModel.result[selectedIndex].id);
          }
          // setState(() {
          //   name == "Cancel Order" ? order = false : null;
          // });
        },
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                "$name",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    color:
                        name == "Cancel Order" ? Colors.black : Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:transact/AppBar.dart';

// import 'package:transact/utils/togglebuttons.dart';
// import 'package:transact/utils/utils.dart';

// class OrderManagement extends StatefulWidget {
//   @override
//   _OrderManagementState createState() => _OrderManagementState();
// }

// class _OrderManagementState extends State<OrderManagement> {
  
//   ///////////// font style///////////////////////////////
//   var style = TextStyle(
//       fontFamily: "CaviarDreams", fontSize: 16, fontWeight: FontWeight.bold);
//   var style2 = TextStyle(
//       fontFamily: "CaviarDreams",
//       fontSize: 12,
//       fontWeight: FontWeight.bold,
//       color: HexColor("#6B6B6B"));
//   ////////////////////////////////////////////////////////

//   var formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
//   List<bool> _selection = [true, false, false];
//   int selectedIndex;
//   bool order = false;

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: HexColor("#F5F7FA"),
//         bottomNavigationBar: order == true && !_selection[2] ? _bottom() : null,
//         appBar: PreferredSize(
//           preferredSize: Size.fromHeight(order == false ? 110 : 70),
//           child: CustomeAppBar(
//             homepage: false,
//             title: order == false ? "Received Order" : "Order",
//             child: order == false
//                 ? ToggleButton(
//                     isSelected: _selection,
//                     child1Title: "Pending",
//                     child2Title: "Received",
//                     child3Title: "Delivered",
//                     buttonCount: 3,


//                     onPress: (int index) {
//                       setState(() {
//                         _selection[index] = !_selection[index];
//                         for (int buttonIndex = 0;
//                             buttonIndex < _selection.length;
//                             buttonIndex++) {
//                           if (buttonIndex == index) {
//                             _selection[buttonIndex] = true;
//                           } else {
//                             _selection[buttonIndex] = false;
//                           }
//                         }
//                       });
//                     },
//                   )
//                 : Container(),
//           ),
//         ),
//         body: order == false
//             ? Container(
//                 width: MediaQuery.of(context).size.width,
//                 child: ListView.builder(
//                   itemBuilder: (context, index) {
//                     return _orderNumber();
//                   },
//                 ))
//             : _order(),
//       ),
//     );
//   }

//   Widget _orderNumber() {
//     return InkWell(
//       onTap: () {
//         setState(() {
//           order = true;
//         });
//       },
//       child: Container(
//           margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
//           color: Colors.white,
//           padding: EdgeInsets.symmetric(vertical: 5, horizontal: 7),
//           child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Align(
//                   alignment: Alignment.topRight,
//                   child: Text("$formattedDate",
//                       style:
//                           TextStyle(color: HexColor("#9E9E9E"), fontSize: 12)),
//                 ),
//                 Text(
//                   "Order #  CK1FF25",
//                   style: style,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     Text(
//                       "by john Doe",
//                       style: style2,
//                     ),
//                     Text(
//                       _selection[1]
//                           ? "Approved"
//                           : _selection[2] ? "Delivered" : "",
//                       style: style2.copyWith(
//                           color: _selection[1]
//                               ? HexColor("#078703")
//                               : HexColor("#FF0000")),
//                     )
//                   ],
//                 ),
//                 _selection[2]
//                     ? Text(
//                         "Delivery Date : 20-01-2020",
//                         style: style2,
//                       )
//                     : Container(),
//                 Row(children: <Widget>[
//                   Text(
//                     "Payment Method",
//                     style: style2,
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Text(
//                     "COD",
//                     style: style,
//                   )
//                 ]),
//                 Align(
//                   alignment: Alignment.bottomRight,
//                   child: Text("\$945", style: style),
//                 ),
//               ])),
//     );
//   }

//   Widget _order() {
//     return Container(
//       child: Column(
//         children: <Widget>[_orderNumber(), _orderDetails(), _customerDetails()],
//       ),
//     );
//   }

//   Widget _orderDetails() {
//     return Container(
//         margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
//         color: Colors.white,
//         padding: EdgeInsets.all(10),
//         child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 "Order Detail",
//                 style: style.copyWith(color: HexColor("#6B6B6B")),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Container(
//                     child: Wrap(
//                       children: <Widget>[
//                         Image(
//                           height: MediaQuery.of(context).size.height * .14,
//                           width: MediaQuery.of(context).size.width * .3,
//                           image: AssetImage("images/iphone.png"),
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: <Widget>[
//                             Text(
//                               "iphone 8",
//                               style: style.copyWith(color: HexColor("#6B6B6B")),
//                             ),
//                             SizedBox(
//                               height: 30,
//                             ),
//                             Text(
//                               "1 x \$200",
//                               textAlign: TextAlign.start,
//                               style: style2,
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                   Text(
//                     "\$968",
//                     style: style,
//                   ),
//                 ],
//               ),
//               _divider(),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Container(
//                     child: Wrap(
//                       children: <Widget>[
//                         Image(
//                           height: MediaQuery.of(context).size.height * .14,
//                           width: MediaQuery.of(context).size.width * .3,
//                           image: AssetImage("images/iphone.png"),
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: <Widget>[
//                             Text(
//                               "iphone 8",
//                               style: style.copyWith(color: HexColor("#6B6B6B")),
//                             ),
//                             SizedBox(
//                               height: 30,
//                             ),
//                             Text(
//                               "1 x \$200",
//                               textAlign: TextAlign.start,
//                               style: style2,
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                   Text(
//                     "\$968",
//                     style: style.copyWith(color: HexColor("#3B444B")),
//                   ),
//                 ],
//               ),
//             ]));
//   }

//   Widget _divider() {
//     return Container(
//       margin: EdgeInsets.only(bottom: 10),
//       height: 1,
//       color: HexColor("#707070"),
//     );
//   }

//   Widget _customerDetails() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
//       color: Colors.white,
//       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Container(
//               margin: EdgeInsets.symmetric(vertical: 10, horizontal: 1),
//               child: Text(
//                 "Customer Details",
//                 style: style2.copyWith(fontSize: 16),
//               )),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     "John Doe",
//                     style: style2.copyWith(
//                         fontFamily: "antipasto",
//                         fontSize: 18,
//                         color: Colors.black),
//                   ),
//                   Text(
//                     "Customer Name",
//                     style: style2.copyWith(fontSize: 12),
//                   ),
//                 ],
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     "ABN",
//                     style: style2.copyWith(
//                         fontFamily: "antipasto",
//                         fontSize: 18,
//                         color: Colors.black),
//                   ),
//                   Text(
//                     "Delivery",
//                     style: style2.copyWith(fontSize: 12),
//                   ),
//                 ],
//               )
//             ],
//           ),
//           Container(
//             margin: EdgeInsets.only(top: 10, bottom: 10),
//             child: Row(
//               children: <Widget>[
//                 Image(
//                     height: 20,
//                     width: 20,
//                     image: AssetImage("images/call.png")),
//                 Text("  +91111111111111"),
//               ],
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.only(top: 10, bottom: 10),
//             child: Row(
//               children: <Widget>[
//                 Image(
//                     height: 20, width: 20, image: AssetImage("images/msg.png")),
//                 Text("  Chat"),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _bottom() {
//     return Container(
//       color: Colors.white,
//       height: MediaQuery.of(context).size.height * .08,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           _button("Cancel Order"),
//           _button(_selection[0] ? "Accept Order" : "Deliver Order")
//         ],
//       ),
//     );
//   }

//   Widget _button(String name) {
//     return Container(
//       alignment: Alignment.bottomCenter,
//       margin: EdgeInsets.only(left: 10, right: 10),
//       padding: EdgeInsets.symmetric(horizontal: 30),
//       height: 50,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(3),
//           color: name == "Cancel Order" ? Colors.white70 : HexColor("#3B444B")),
//       child: GestureDetector(
//         onTap: () {
//           setState(() {
//             name == "Cancel Order" ? order = false : null;
//           });
//         },
//         child: Stack(
//           children: <Widget>[
//             Align(
//               alignment: Alignment.center,
//               child: Text(
//                 "$name",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     fontSize: 16,
//                     color:
//                         name == "Cancel Order" ? Colors.black : Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:smooth_star_rating/smooth_star_rating.dart';
// import 'package:transact/AppBar.dart';
// import 'package:transact/Model/apismodel.dart';
// import 'package:transact/Model/getauthentication.dart';
// import 'package:transact/Model/ordermodel.dart';
// import 'package:transact/utils/bottomButton.dart';
// import 'package:transact/utils/fonts.dart';
// import 'package:transact/utils/togglebuttons.dart';
// import 'package:transact/utils/utils.dart';
// import 'package:http/http.dart'as http;
// import 'dart:convert';
// class SellerOrders extends StatefulWidget {
//   @override
//   _BuyerOrderState createState() => _BuyerOrderState();
// }

// class _BuyerOrderState extends State<SellerOrders> {
//   var _scaffoldKey = new GlobalKey<ScaffoldState>();
//   OrderModel orderModel = OrderModel();
//   List<bool> _selection = [true, false];
//   bool bottomsheet = false;
//   var style = TextStyle(
//       fontFamily: "CaviarDreams", fontSize: 16, fontWeight: FontWeight.bold);
//   var style2 = TextStyle(
//       fontFamily: "CaviarDreams",
//       fontSize: 12,
//       fontWeight: FontWeight.bold,
//       color: HexColor("#6B6B6B"));
//   //ProgressDialog pr;
//   var _productRating = 0.0;
//   var _sellerRating = 0.0;
//  getPendingList() async {
//     //pr.show();
//     var header = {
//       "Authorization": AuthenticationUser.getAuthentication(),
//     };
//     print(header);
//     var response = await http.get(
//       "${API.getMyOrder}",
//       headers: header,
//     );
//     var Json = json.decode(response.body);
//     print(json.decode(response.body));
//     if (response.statusCode == 200) {
//       if (Json['Data']['WithError'] == false) {
//        // pr.dismiss();
//         setState(() {
//           orderModel = OrderModel.fromJson(Json['Data']);
//         });
//       } else {
//         //pr.dismiss();
//         Fluttertoast.showToast(
//             msg: "${Json['data']['ShortMessage']}",
//             textColor: Colors.white,
//             backgroundColor: Colors.blueGrey);

//         setState(() {
//           orderModel = OrderModel();
//         });
//       }
//     } else {
//       //pr.dismiss();
//       Fluttertoast.showToast(
//           msg: "response status: ${response.statusCode}",
//           textColor: Colors.white,
//           backgroundColor: Colors.blueGrey);
//     }
//   }

// @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getPendingList();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//       bottomSheet: bottomsheet == true ? _bottomSheet() : null,
//       backgroundColor: HexColor("#F5F7FA"),
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(120),
//         child: CustomeAppBar(
//           title: "My Orders",
//           homepage: false,
//           // child: ToggleButton(
//           //   isSelected: _selection,
//           //   buttonCount: 2,
//           //   child1Title: "Pending",
//           //   child2Title: "Received",
//           //   onPress: (int index) {
//           //     setState(() {
//           //       for (int buttonIndex = 0;
//           //           buttonIndex < _selection.length;
//           //           buttonIndex++) {
//           //         if (buttonIndex == index) {
//           //           _selection[buttonIndex] = true;
//           //         } else {
//           //           _selection[buttonIndex] = false;
//           //         }
//           //       }
//           //     });
//           //   },
//           // ),
        
//         ),
//       ),
//       body: Container(
//         child: Column(
//           children: <Widget>[
//             // _myOrders(),
//             // _selection[1] ? _receivedOrderDetails(context) : _orderStatus(),
//             Expanded(
//                           child: ListView.builder(
//                         itemCount: orderModel.result != null
//                             ? orderModel.result.length
//                             : 0,
//                         itemBuilder: (context, index) {
//                           return _orderNumber(index);
//                         },
//                       )),
//           ],
//         ),
//       ),
//     ));
//   }
//   Widget _orderNumber(int index) {
//     return InkWell(
//       onTap: () {
//         if(
//         orderModel.result[index].status==2 || 
//         orderModel.result[index].status==3 
//         )
//         {

//         }
//         else if(orderModel.result[index].status==1)
//         {
//           // setState(() {
//           //   selectedIndex = index;
//           // });
//           // _showDialog();
//         }
//         else
//         {
//         //    setState(() {
//         //   order = true;
//         //   selectedIndex = index;
//         // });
//         }
       
//         // _customerDetails();
//       },
//       child: Container(
//           margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
//           color: Colors.white,
//           padding: EdgeInsets.symmetric(vertical: 5, horizontal: 7),
//           child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Align(
//                   alignment: Alignment.topRight,
//                   child: Text("${orderModel.result[index].date}",
//                       style:
//                           TextStyle(color: HexColor("#9E9E9E"), fontSize: 12)),
//                 ),
//                 Text(
//                   "Order #  ${orderModel.result[index].orderNumber}",
//                   style: style,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     Text(
//                       "by ${orderModel.result[index].customerName}",
//                       style: style2,
//                     ),
//                     // Text(
//                     //   _selection[1]
//                     //       ? "Approved"
//                     //       : _selection[2] ? "Delivered" : "",
//                     //   style: style2.copyWith(
//                     //       color: _selection[1]
//                     //           ? HexColor("#078703")
//                     //           : HexColor("#FF0000")),
//                     // )
//                   ],
//                 ),
//                 // _selection[2]
//                 //     ? Text(
//                 //         "Delivery Date : 20-01-2020",
//                 //         style: style2,
//                 //       )
//                 //     : Container(),
                
//                 Row(children: <Widget>[
//                   Text(
//                     "Payment Method",
//                     style: style2,
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   orderModel.result[index].paymentMethod == 0
//                       ? Text(
//                           "COD",
//                           style: style,
//                         )
//                       : orderModel.result[index].paymentMethod == 1
//                           ? Text(
//                               "Card",
//                               style: style,
//                             )
//                           : Text(
//                               "Bank",
//                               style: style,
//                             )
//                 ]),
//                 Row(children: <Widget>[
//                   Text(
//                     "Status: ",
//                     style: style2,
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   orderModel.result[index].status == 0
//                       ? Text(
//                           "Pending",
//                           style: style,
//                         )
//                       : orderModel.result[index].status == 1
//                           ? Text(
//                               "In Process",
//                               style: style,
//                             )
//                           : 
//                           orderModel.result[index].status == 2
//                           ? Text(
//                               "Rejected",
//                               style: style,
//                             ):
//                           Text(
//                               "Delivered",
//                               style: style,
//                             )
//                 ]),
//                 Align(
//                   alignment: Alignment.bottomRight,
//                   child: Text("\$${orderModel.result[index].totalBill}",
//                       style: style),
//                 ),
//               ])),
//     );
//   }

//   Widget _myOrders() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//       color: Colors.white,
//       width: MediaQuery.of(context).size.width,
//       child: Column(
//         children: <Widget>[
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Text(
//                 "My Orders",
//                 style: blackbold.copyWith(fontSize: 20, height: 1.2),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   print("wokring");
//                 },
//                 child: Text(
//                   "View All",
//                   style: blackbold.copyWith(
//                       decoration: TextDecoration.underline,
//                       fontSize: 15,
//                       fontWeight: FontWeight.normal),
//                 ),
//               ),
//             ],
//           ),
//           Container(
//             height: MediaQuery.of(context).size.height * .2,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: 5,
//               itemBuilder: (context, index) {
//                 return Container(
//                   child: _orderCard(),
//                 );
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _orderCard() {
//     return Container(
//       height: MediaQuery.of(context).size.height * .2,
//       width: MediaQuery.of(context).size.width / 2,
//       margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//       padding: EdgeInsets.all(10),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1.0)]),
//       child: Column(
//         children: <Widget>[
//           Expanded(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Text(
//                   "Order #",
//                   style: blackbold.copyWith(fontSize: 15),
//                 ),
//                 Text("CK128MJ",
//                     style: blackbold.copyWith(
//                       fontSize: 15,
//                     )),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[Text("Placed on:"), Text("10-01-2020")],
//             ),
//           ),
//           Expanded(
//             child: Container(
//               alignment: Alignment.centerRight,
//               child: Text(
//                 "Total   \$291",
//                 style: blackbold.copyWith(
//                   color: HexColor("#334765"),
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _orderStatus() {
//     return Container(
//       color: Colors.white,
//       alignment: Alignment.topLeft,
//       margin: EdgeInsets.only(
//         top: 8,
//       ),
//       padding: EdgeInsets.only(left: 20),
//       width: MediaQuery.of(context).size.width,
//       child: Column(children: <Widget>[
//         Container(
//           alignment: Alignment.bottomLeft,
//           margin: EdgeInsets.only(top: 15, bottom: 10),
//           child: Text(
//             "Order Status",
//             style: blackbold.copyWith(fontSize: 20),
//           ),
//         ),
//         Row(children: <Widget>[
//           Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               _progessIndicator(1),
//               _progessIndicator(2),
//               _progessIndicator(3),
//               _progessIndicator(4),
//             ],
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               _orderProgress("Order Received"),
//               _orderProgress("Payment Received"),
//               _orderProgress("Processing"),
//               _orderProgress("All Shipped"),
//             ],
//           ),
//         ]),
//       ]),
//     );
//   }

//   Widget _orderProgress(String text) {
//     return Container(
//       padding: EdgeInsets.only(
//         top: text == "All Shipped" ? 10 : 20,
//         left: 20,
//         bottom: text == "All Shipped" ? 20 : 0,
//       ),
//       width: 150,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             "$text",
//             style: blackbold.copyWith(fontSize: 17),
//           ),
//           text == "Processing"
//               ? Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       "Estimated Shipping Date",
//                       style: TextStyle(fontSize: 12),
//                     ),
//                     SizedBox(
//                       height: 4,
//                     ),
//                     Text(
//                       "10-01-2020",
//                       style: TextStyle(fontSize: 12),
//                     ),
//                   ],
//                 )
//               : text == "All Shipped"
//                   ? Container()
//                   : Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           "10-01-2020",
//                           style: TextStyle(fontSize: 12),
//                         ),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         Text("7:00"),
//                       ],
//                     )
//         ],
//       ),
//     );
//   }

//   Widget _progessIndicator(int id) {
//     return Container(
//       child: Column(
//         children: <Widget>[
//           CircleAvatar(
//             backgroundColor: id == 1
//                 ? HexColor("#0D4BA7")
//                 : id == 2 ? HexColor("#0D4BA7") : Colors.grey,
//             radius: 6,
//           ),
//           id == 4
//               ? Container()
//               : Container(
//                   width: 1,
//                   height: 40,
//                   color: id == 1
//                       ? HexColor("#0D4BA7")
//                       : id == 2 ? HexColor("#0D4BA7") : Colors.grey),
//         ],
//       ),
//     );
//   }

//   Widget _receivedOrderDetails(context) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       color: Colors.white,
//       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       margin: EdgeInsets.only(top: 10),
//       child: Column(
//         children: <Widget>[
//           Column(
//             children: <Widget>[
//               _orderDetailLine("Order #", "CK12FGH"),
//               _orderDetailLine("Placed on    ", "10-01-2020"),
//               _orderDetailLine("Received on", "20-01-2020"),
//               _product(),
//               Container(
//                 margin: EdgeInsets.only(right: 10, top: 10, bottom: 10),
//                 alignment: Alignment.centerRight,
//                 child: Text(
//                   " Total  \$924",
//                   style: TextStyle(color: HexColor("#334765"), fontSize: 19),
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
//                 child: BottomButton(
//                   name: "LEAVE FEED BACK",
//                   customColor: true,
//                   color: HexColor("#FF4747"),
//                   ontap: () {
//                     setState(() {
//                       bottomsheet = true;
//                     });
//                   },
//                 ),
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _product() {
//     return Container(
//       child: Row(
//         children: <Widget>[
//           Container(
//             alignment: Alignment.centerLeft,
//             height: 70,
//             width: 70,
//             child: Image.asset("images/iphone.png"),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 "iPhone X",
//                 style: TextStyle(
//                   fontSize: 18,
//                 ),
//               ),
//               Text(
//                 "\$924",
//                 textAlign: TextAlign.left,
//                 style: TextStyle(
//                     height: 1.4, fontSize: 14, color: HexColor("#515C6F")),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _orderDetailLine(String text1, String text2) {
//     return Container(
//       margin: EdgeInsets.only(bottom: text1 == "Order #" ? 10 : 5),
//       child: Row(
//         children: <Widget>[
//           Text(
//             "$text1",
//             textAlign: TextAlign.start,
//             style: TextStyle(
//                 color: text1 == "Order #" ? Colors.black : HexColor("#6B6B6B"),
//                 fontSize: text1 == "Order #" ? 18 : 12),
//           ),
//           SizedBox(
//             width: 20,
//           ),
//           Text(
//             "$text2",
//             textAlign: TextAlign.start,
//             style: TextStyle(
//                 color: text1 == "Order #" ? Colors.black : HexColor("#6B6B6B"),
//                 fontSize: text1 == "Order #" ? 18 : 12),
//           ),
//         ],
//       ),
//     );
//   }

 
//   Widget _bottomSheet() {
//     return Container(
//       padding: EdgeInsets.only(top: 20, left: 15, right: 15),
//       height: MediaQuery.of(context).size.height * .65,
//       decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey,
//               blurRadius: 5,
//             )
//           ],
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//               topRight: Radius.circular(35), topLeft: Radius.circular(35))),
//       child: Column(
//         children: <Widget>[
//           GestureDetector(
//             onTap: () {
//               setState(() {
//                 bottomsheet = false;
//               });
//             },
//             child: Container(
//               height: 20,
//               width: MediaQuery.of(context).size.width,
//               alignment: Alignment.centerRight,
//               margin: EdgeInsets.only(top: 10, right: 10),
//               child: Image.asset("images/cross.png"),
//             ),
//           ),
//           _orderDetailLine("Order #", "CK12FGH"),
//           _orderDetailLine("Placed on    ", "10-01-2020"),
//           _orderDetailLine("Received on", "20-01-2020"),
//           _product(),
//           _divider(),
//           _rate(),
//           _divider(),
//           _title("Write a Review"),
//           _textFormField(
//             "Write here...",
//           ),
//           Container(
//             margin: EdgeInsets.only(left: 20, right: 20, top: 14, bottom: 0.0),
//             child: BottomButton(
//               name: "Send Feed Back",
//               ontap: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _divider() {
//     return Container(
//       width: double.infinity,
//       height: 1,
//       color: Colors.grey,
//     );
//   }

//   Widget _rate() {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           Text(
//             "How would you rate this product & Seller?",
//             style: blackbold.copyWith(height: 1.5, fontSize: 18),
//           ),
//           Row(
//             children: <Widget>[
//               Expanded(
//                 child: Container(
//                   alignment: Alignment.center,
//                   child: Text("Product"),
//                 ),
//               ),
//               Expanded(child: _fiveStar(1))
//             ],
//           ),
//           Row(
//             children: <Widget>[
//               Expanded(
//                 child: Container(
//                   alignment: Alignment.center,
//                   child: Text("Seller"),
//                 ),
//               ),
//               Expanded(child: _fiveStar(2))
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Widget _fiveStar(int id) {
//     return Container(
//         margin: EdgeInsets.only(
//           top: id == 1 ? 10 : 0.0,
//           bottom: 10,
//         ),
//         child: SmoothStarRating(
//           rating: id == 1 ? _productRating : _sellerRating,
//           size: 18,
//           filledIconData: Icons.star,
//           halfFilledIconData: Icons.star_half,
//           defaultIconData: Icons.star_border,
//            color: Colors.yellow[600],
//           borderColor: Colors.yellow[600],
//           starCount: 5,
//           allowHalfRating: false,
//           spacing: 2.0,
//           onRatingChanged: (value) {
//             setState(() {
//               id == 1 ? _productRating = value : _sellerRating = value;
//             });
//           },
//         ));
//   }

//   Widget _textFormField(String text) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
//       child: TextFormField(
//         keyboardType: TextInputType.multiline,
//         maxLines: 4,
//         decoration: InputDecoration(
//             isDense: true,
//             enabledBorder:
//                 OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
//             focusedBorder:
//                 OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
//             contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(5),
//             ),
//             hintText: "$text",
//             hintStyle: TextStyle(
//               fontSize: 12,
//               fontFamily: "Roboto",
//               color: HexColor("#9E9E9E"),
//               fontWeight: FontWeight.bold,
//             )),
//       ),
//     );
//   }

//   Widget _title(String text) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 5),
//       child: Text("$text",
//           style: TextStyle(
//             color: HexColor("#9E9E9E"),
//             fontFamily: 'Roboto',
//             fontSize: 15,
//           )),
//     );
//   }
// }




// // import 'package:flutter/material.dart';
// // import 'package:smooth_star_rating/smooth_star_rating.dart';
// // import 'package:transact/AppBar.dart';
// // import 'package:transact/utils/bottomButton.dart';
// // import 'package:transact/utils/fonts.dart';
// // import 'package:transact/utils/togglebuttons.dart';
// // import 'package:transact/utils/utils.dart';

// // class SellerOrders extends StatefulWidget {
// //   @override
// //   _SellerOrdersState createState() => _SellerOrdersState();
// // }

// // class _SellerOrdersState extends State<SellerOrders> {
// //   List<bool> _selection = [true, false];
// //   bool bottomsheet = false;
// //   var _productRating = 0.0;
// //   var _sellerRating = 0.0;

  
// //   @override
// //   Widget build(BuildContext context) {
// //     return SafeArea(
// //         child: Scaffold(
// //       bottomSheet: bottomsheet == true ? _bottomSheet() : null,
// //       backgroundColor: HexColor("#F5F7FA"),
// //       appBar: PreferredSize(
// //         preferredSize: Size.fromHeight(120),
// //         child: CustomeAppBar(
// //           title: "My Orders",
// //           homepage: false,
// //           child: ToggleButton(
// //             isSelected: _selection,
// //             buttonCount: 2,
// //             child1Title: "Pending",
// //             child2Title: "Received",
// //             onPress: (int index) {
// //               setState(() {
// //                 for (int buttonIndex = 0;
// //                     buttonIndex < _selection.length;
// //                     buttonIndex++) {
// //                   if (buttonIndex == index) {
// //                     _selection[buttonIndex] = true;
// //                   } else {
// //                     _selection[buttonIndex] = false;
// //                   }
// //                 }
// //               });
// //             },
// //           ),
// //         ),
// //       ),
// //       body: Container(
// //         child: Column(
// //           children: <Widget>[
// //             _myOrders(),
// //             _selection[1] ? _receivedOrderDetails(context) : _orderStatus(),
// //           ],
// //         ),
// //       ),
// //     ));
// //   }

// //   Widget _myOrders() {
// //     return Container(
// //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
// //       color: Colors.white,
// //       width: MediaQuery.of(context).size.width,
// //       child: Column(
// //         children: <Widget>[
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: <Widget>[
// //               Text(
// //                 "My Orders",
// //                 style: blackbold.copyWith(fontSize: 20, height: 1.2),
// //               ),
// //               GestureDetector(
// //                 onTap: () {
// //                   print("wokring");
// //                 },
// //                 child: Text(
// //                   "View All",
// //                   style: blackbold.copyWith(
// //                       decoration: TextDecoration.underline,
// //                       fontSize: 15,
// //                       fontWeight: FontWeight.normal),
// //                 ),
// //               ),
// //             ],
// //           ),
// //           Container(
// //             height: MediaQuery.of(context).size.height * .2,
// //             child: ListView.builder(
// //               scrollDirection: Axis.horizontal,
// //               itemCount: 5,
// //               itemBuilder: (context, index) {
// //                 return Container(
// //                   child: _orderCard(),
// //                 );
// //               },
// //             ),
// //           )
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _orderCard() {
// //     return Container(
// //       height: MediaQuery.of(context).size.height * .2,
// //       width: MediaQuery.of(context).size.width / 2,
// //       margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
// //       padding: EdgeInsets.all(10),
// //       decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(15),
// //           boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1.0)]),
// //       child: Column(
// //         children: <Widget>[
// //           Expanded(
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: <Widget>[
// //                 Text(
// //                   "Order #",
// //                   style: blackbold.copyWith(fontSize: 15),
// //                 ),
// //                 Text("CK128MJ",
// //                     style: blackbold.copyWith(
// //                       fontSize: 15,
// //                     )),
// //               ],
// //             ),
// //           ),
// //           Expanded(
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: <Widget>[Text("Placed on:"), Text("10-01-2020")],
// //             ),
// //           ),
// //           Expanded(
// //             child: Container(
// //               alignment: Alignment.centerRight,
// //               child: Text(
// //                 "Total   \$291",
// //                 style: blackbold.copyWith(
// //                   color: HexColor("#334765"),
// //                 ),
// //               ),
// //             ),
// //           )
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _orderStatus() {
// //     return Container(
// //       color: Colors.white,
// //       alignment: Alignment.topLeft,
// //       margin: EdgeInsets.only(
// //         top: 8,
// //       ),
// //       padding: EdgeInsets.only(left: 20),
// //       width: MediaQuery.of(context).size.width,
// //       child: Column(children: <Widget>[
// //         Container(
// //           alignment: Alignment.bottomLeft,
// //           margin: EdgeInsets.only(top: 15, bottom: 10),
// //           child: Text(
// //             "Order Status",
// //             style: blackbold.copyWith(fontSize: 20),
// //           ),
// //         ),
// //         Row(children: <Widget>[
// //           Column(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: <Widget>[
// //               _progessIndicator(1),
// //               _progessIndicator(2),
// //               _progessIndicator(3),
// //               _progessIndicator(4),
// //             ],
// //           ),
// //           Column(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: <Widget>[
// //               _orderProgress("Order Received"),
// //               _orderProgress("Payment Received"),
// //               _orderProgress("Processing"),
// //               _orderProgress("All Shipped"),
// //             ],
// //           ),
// //         ]),
// //       ]),
// //     );
// //   }

// //   Widget _orderProgress(String text) {
// //     return Container(
// //       padding: EdgeInsets.only(
// //         top: text == "All Shipped" ? 10 : 20,
// //         left: 20,
// //         bottom: text == "All Shipped" ? 20 : 0,
// //       ),
// //       width: 150,
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.start,
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: <Widget>[
// //           Text(
// //             "$text",
// //             style: blackbold.copyWith(fontSize: 17),
// //           ),
// //           text == "Processing"
// //               ? Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: <Widget>[
// //                     Text(
// //                       "Estimated Shipping Date",
// //                       style: TextStyle(fontSize: 12),
// //                     ),
// //                     SizedBox(
// //                       height: 4,
// //                     ),
// //                     Text(
// //                       "10-01-2020",
// //                       style: TextStyle(fontSize: 12),
// //                     ),
// //                   ],
// //                 )
// //               : text == "All Shipped"
// //                   ? Container()
// //                   : Row(
// //                       mainAxisAlignment: MainAxisAlignment.start,
// //                       children: <Widget>[
// //                         Text(
// //                           "10-01-2020",
// //                           style: TextStyle(fontSize: 12),
// //                         ),
// //                         SizedBox(
// //                           width: 20,
// //                         ),
// //                         Text("7:00"),
// //                       ],
// //                     )
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _progessIndicator(int id) {
// //     return Container(
// //       child: Column(
// //         children: <Widget>[
// //           CircleAvatar(
// //             backgroundColor: id == 1
// //                 ? HexColor("#0D4BA7")
// //                 : id == 2 ? HexColor("#0D4BA7") : Colors.grey,
// //             radius: 6,
// //           ),
// //           id == 4
// //               ? Container()
// //               : Container(
// //                   width: 1,
// //                   height: 40,
// //                   color: id == 1
// //                       ? HexColor("#0D4BA7")
// //                       : id == 2 ? HexColor("#0D4BA7") : Colors.grey),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _receivedOrderDetails(context) {
// //     return Container(
// //       width: MediaQuery.of(context).size.width,
// //       color: Colors.white,
// //       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// //       margin: EdgeInsets.only(top: 10),
// //       child: Column(
// //         children: <Widget>[
// //           Column(
// //             children: <Widget>[
// //               _orderDetailLine("Order #", "CK12FGH"),
// //               _orderDetailLine("Placed on    ", "10-01-2020"),
// //               _orderDetailLine("Received on", "20-01-2020"),
// //               _product(),
// //               Container(
// //                 margin: EdgeInsets.only(right: 10, top: 10, bottom: 10),
// //                 alignment: Alignment.centerRight,
// //                 child: Text(
// //                   " Total  \$924",
// //                   style: TextStyle(color: HexColor("#334765"), fontSize: 19),
// //                 ),
// //               ),
// //               Container(
// //                 margin: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
// //                 child: BottomButton(
// //                   name: "LEAVE FEED BACK",
// //                   customColor: true,
// //                   color: HexColor("#FF4747"),
// //                   ontap: () {
// //                     setState(() {
// //                       bottomsheet = true;
// //                     });
// //                   },
// //                 ),
// //               )
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _product() {
// //     return Container(
// //       child: Row(
// //         children: <Widget>[
// //           Container(
// //             alignment: Alignment.centerLeft,
// //             height: 70,
// //             width: 70,
// //             child: Image.asset("images/iphone.png"),
// //           ),
// //           Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: <Widget>[
// //               Text(
// //                 "iPhone X",
// //                 style: TextStyle(
// //                   fontSize: 18,
// //                 ),
// //               ),
// //               Text(
// //                 "\$924",
// //                 textAlign: TextAlign.left,
// //                 style: TextStyle(
// //                     height: 1.4, fontSize: 14, color: HexColor("#515C6F")),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _orderDetailLine(String text1, String text2) {
// //     return Container(
// //       margin: EdgeInsets.only(bottom: text1 == "Order #" ? 10 : 5),
// //       child: Row(
// //         children: <Widget>[
// //           Text(
// //             "$text1",
// //             textAlign: TextAlign.start,
// //             style: TextStyle(
// //                 color: text1 == "Order #" ? Colors.black : HexColor("#6B6B6B"),
// //                 fontSize: text1 == "Order #" ? 18 : 12),
// //           ),
// //           SizedBox(
// //             width: 20,
// //           ),
// //           Text(
// //             "$text2",
// //             textAlign: TextAlign.start,
// //             style: TextStyle(
// //                 color: text1 == "Order #" ? Colors.black : HexColor("#6B6B6B"),
// //                 fontSize: text1 == "Order #" ? 18 : 12),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _bottomSheet() {
// //     return Container(
// //       padding: EdgeInsets.only(top: 20, left: 15, right: 15),
// //       height: MediaQuery.of(context).size.height * .65,
// //       decoration: BoxDecoration(
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.grey,
// //               blurRadius: 5,
// //             )
// //           ],
// //           color: Colors.white,
// //           borderRadius: BorderRadius.only(
// //               topRight: Radius.circular(35), topLeft: Radius.circular(35))),
// //       child: ListView(
// //         children: <Widget>[
// //           GestureDetector(
// //             onTap: () {
// //               setState(() {
// //                 bottomsheet = false;
// //               });
// //             },
// //             child: Container(
// //               height: 20,
// //               width: MediaQuery.of(context).size.width,
// //               alignment: Alignment.centerRight,
// //               margin: EdgeInsets.only(top: 10, right: 10),
// //               child: Image.asset("images/cross.png"),
// //             ),
// //           ),
// //           _orderDetailLine("Order #", "CK12FGH"),
// //           _orderDetailLine("Placed on    ", "10-01-2020"),
// //           _orderDetailLine("Received on", "20-01-2020"),
// //           _product(),
// //           _divider(),
// //           _rate(),
// //           _divider(),
// //           _title("Write a Review"),
// //           _textFormField(
// //             "Write here...",
// //           ),
// //           Container(
// //             margin: EdgeInsets.only(left: 20, right: 20, top: 14, bottom: 0.0),
// //             child: BottomButton(
// //               name: "Send Feed Back",
// //               ontap: () {
// //                 Navigator.pop(context);
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _divider() {
// //     return Container(
// //       width: double.infinity,
// //       height: 1,
// //       color: Colors.grey,
// //     );
// //   }

// //   Widget _rate() {
// //     return Container(
// //       margin: EdgeInsets.symmetric(vertical: 10),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.center,
// //         children: <Widget>[
// //           Text(
// //             "How would you rate this product & Seller?",
// //             style: blackbold.copyWith(height: 1.5, fontSize: 18),
// //           ),
// //           Row(
// //             children: <Widget>[
// //               Expanded(
// //                 child: Container(
// //                   alignment: Alignment.center,
// //                   child: Text("Product"),
// //                 ),
// //               ),
// //               Expanded(child: _fiveStar(1))
// //             ],
// //           ),
// //           Row(
// //             children: <Widget>[
// //               Expanded(
// //                 child: Container(
// //                   alignment: Alignment.center,
// //                   child: Text("Seller"),
// //                 ),
// //               ),
// //               Expanded(child: _fiveStar(2))
// //             ],
// //           )
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _fiveStar(int id) {
// //     return Container(
// //         margin: EdgeInsets.only(
// //           top: id == 1 ? 10 : 0.0,
// //           bottom: 10,
// //         ),
// //         child: SmoothStarRating(
// //           rating: id == 1 ? _productRating : _sellerRating,
// //           size: 18,
// //           filledIconData: Icons.star,
// //           halfFilledIconData: Icons.star_half,
// //           defaultIconData: Icons.star_border,
// //           starCount: 5,
// //           color: Colors.yellow[600],
// //           borderColor: Colors.yellow[600],
// //           allowHalfRating: false,
// //           spacing: 2.0,
// //           onRatingChanged: (value) {
// //             setState(() {
// //               id == 1 ? _productRating = value : _sellerRating = value;
// //             });
// //           },
// //         ));
// //   }

// //   Widget _textFormField(String text) {
// //     return Container(
// //       margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
// //       child: TextFormField(
// //         keyboardType: TextInputType.multiline,
// //         maxLines: 4,
// //         decoration: InputDecoration(
// //             isDense: true,
// //             enabledBorder:
// //                 OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
// //             focusedBorder:
// //                 OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
// //             contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
// //             border: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(5),
// //             ),
// //             hintText: "$text",
// //             hintStyle: TextStyle(
// //               fontSize: 12,
// //               fontFamily: "Roboto",
// //               color: HexColor("#9E9E9E"),
// //               fontWeight: FontWeight.bold,
// //             )),
// //       ),
// //     );
// //   }

// //   Widget _title(String text) {
// //     return Container(
// //       margin: EdgeInsets.symmetric(vertical: 5),
// //       child: Text("$text",
// //           style: TextStyle(
// //             color: HexColor("#9E9E9E"),
// //             fontFamily: 'Roboto',
// //             fontSize: 15,
// //           )),
// //     );
// //   }
// // }
