import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:transact/Buyer/buyerAddress.dart';
import 'package:transact/Buyer/checkOut.dart';
import 'package:http/http.dart'as http;
import 'package:transact/Buyer/shippingAdress.dart';
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/cartmodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'dart:convert';

import 'package:transact/utils/bottomButton.dart';
import 'package:transact/utils/routes.dart';

import 'package:transact/utils/utils.dart';

import '../AppBar.dart';
import 'buyerPaymentSelection.dart';

class BuyerCart extends StatefulWidget {
  @override
  _BuyerCartState createState() => _BuyerCartState();
}

class _BuyerCartState extends State<BuyerCart> {
  int counter = 1;
  var listItems = 6;
  CartModel cartModel=CartModel();
  bool cartFount=false;
  double total=0.0;
ProgressDialog pr;
  deleteCart(int id) async
  {
    pr.show();
    print(id);
     var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    print(header);
    var t="${API.deleteCart}?id=$id";
    print(t);
    var response = await http.get(
      t,
      headers: header,
    );
    var Json=json.decode(response.body);
    if(response.statusCode==200)
    {

       if (Json['Data']['WithError'] == true) 
       {
         pr.dismiss();
           Fluttertoast.showToast(
            msg: "${Json['Data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
       }
       else
       {
         pr.dismiss();
         getCartline();
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
            msg: "Status Code: ${response.statusCode}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
    }
  }

  cartEmpty() async
  {
    // setState(() {
    //   total=0.0;
    // });
    pr.show();
     var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.get(
      "${API.CartEmpty}",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if(response.statusCode==200)
    {
       if (Json['Data']['WithError'] == true) 
       {
         pr.dismiss();
           Fluttertoast.showToast(
            msg: "${Json['Data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
       }
       else
       {
         pr.dismiss();
         getCartline();
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
            msg: "Status Code: ${response.statusCode}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
    }
  }
  
  getCartline() async
  {
    setState(() {
      total=0.0;
    });
     var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.get(
      "${API.getCart}",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if(response.statusCode==200)
    {
       if (Json['Data']['WithError'] == true) 
       {
           Fluttertoast.showToast(
            msg: "no product found",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
             setState(() {
              total=0.0;
            });
       }
       else
       {
          setState(() {
            cartFount=true;
            cartModel=CartModel.fromJson(Json['Data']);
          });
          for(int i=0;i<cartModel.result.length;i++)
          {
            setState(() {
              total=total+cartModel.result[i].lineTotal;
            });
          }
          setState(() {
            User.userData.totalCart=total;
          });
       }
    }
    else
    {
      Fluttertoast.showToast(
            msg: "Status Code: ${response.statusCode}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
    }
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCartline();
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
          
      backgroundColor: HexColor("#F5F7FA"),
      bottomNavigationBar: _bottomBar(),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: Padding(
            padding: EdgeInsets.only(top: 0),
            child: CustomeAppBar(
              title: "My Cart",
              homepage: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                 Padding(
                   padding: EdgeInsets.only(right:10,bottom:5),
                   child:  deleteButton(),
                 ),
                ],
              ),
            ),
          )),
      body: SingleChildScrollView(
          child: Container(
              child: Column(
        children: <Widget>[
          cartFount==false?
          Container(
            height: MediaQuery.of(context).size.height *.02,
          )
          :
          Container(
              height: MediaQuery.of(context).size.height / 2,
              child: ListView.builder(
                itemCount: cartModel.result!=null?cartModel.result.length:0,
                itemBuilder: (context, index) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    // height: 30,
                    child: _cartItem(index),
                  );
                },
              )
              ),
          SizedBox(
            height: 10,
          ),
         // _voucher()
        ],
      ))),
    ));
  }

  Widget _bottomBar() {
    return Container(
      height: MediaQuery.of(context).size.height * .08,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "Total\n",
                      style: TextStyle(
                          fontSize: 15,
                          color: HexColor("#3B444B"),
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: "\$$total",
                      style: TextStyle(
                          fontSize: 12,
                          color: HexColor("#3B444B"),
                          fontWeight: FontWeight.bold))
                ]),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              width: MediaQuery.of(context).size.width / 3,
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              child: BottomButton(
                name: "Check Out",
                customColor: true,
                color: HexColor("#FF6D2B"),
                ontap: () {
                  if(cartModel.result.isEmpty)
                  {
                     Fluttertoast.showToast(
            msg: "no cart added",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
                  }
                  else
                  {
                    setState(() {
                      User.userData.totalCart=total;
                    });

                    AppRoutes.push(context, BuyerAdress());
                  }
                   
                  //AppRoutes.push(context, BuyerPaymentSelection());
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _cartItem(int index) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.2,
      child: Card(
        elevation: 7,
        color: Colors.white,
        child: Container(
          height: MediaQuery.of(context).size.height / 7.5,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width*.23,
                height: MediaQuery.of(context).size.height*.08,
                margin: EdgeInsets.only(left: 5,right:5),
                child: 
                cartModel.result[index].imagePath!=null?
                Image.network("${API.API_URL}${cartModel.result[index].imagePath}",
               // scale: 10,
                )
                :
                Image.asset(
                  "images/item3.png",
                  scale: 7,
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "${cartModel.result[index].name}",
                              style: TextStyle(
                                  fontSize: 12,
                                  height: 2,
                                  color: Color(0xff3B444B),
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: "\$${cartModel.result[index].price}",
                              style: TextStyle(
                                  height: 1.5,
                                  fontSize: 12,
                                  color: Color(0xff515C6F),
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: "   per piece",
                              style: TextStyle(
                                  fontSize: 7,
                                  color: Color(0xff939698),
                                  fontWeight: FontWeight.bold))
                        ]),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width / 1.6,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              //_counter(),
                              Text("Quantity: ${cartModel.result[index].qty}",
                                  style: TextStyle(
                                      height: 2,
                                      fontSize: 15,
                                      color: Color(0xff515C6F),
                                      fontWeight: FontWeight.bold)),
                              Text("\$${cartModel.result[index].lineTotal}",
                                  style: TextStyle(
                                      height: 2,
                                      fontSize: 15,
                                      color: Color(0xff515C6F),
                                      fontWeight: FontWeight.bold)),
                            ],
                          ))
                    ],
                  )),
            ],
          ),
        ),
      ),
      actions: <Widget>[],
      secondaryActions: <Widget>[
        IconSlideAction(
          foregroundColor: Colors.white,
          color: Color(0xffFF3D00),
          iconWidget: Image.asset(
            'images/delete.png',
            scale: 4,
          ),
          onTap: () {
            print('deleted');
            deleteCart(cartModel.result[index].id);
            // setState(() {
            //   listItems = listItems - 1;
            // });
          },
        ),
      ],
    );
  }

  Widget _textField(String image, String label, id) {
    return Container(
      margin: EdgeInsets.only(right: 2, top: 5),
      height: MediaQuery.of(context).size.height / 18,
      child: TextFormField(
        decoration: InputDecoration(
          isDense: true,
          icon: image == ""
              ? null
              : Container(
                  height: 45,
                  width: 30,
                  child: Image.asset("$image"),
                ),
          filled: true,
          fillColor: HexColor("#FFFFFF"),
          hintText: "$label",
          hintStyle: TextStyle(
              fontFamily: "CaviarDreams",
              fontSize: 14,
              color: HexColor("#939698")),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(id == 3 ? 4 : 10),
              borderSide: BorderSide(color: HexColor("#707070"))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(id == 3 ? 4 : 10),
              borderSide: BorderSide(width: 1, color: HexColor("#707070"))),
        ),
      ),
    );
  }

  Widget _voucher() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      color: Colors.white,
      padding: EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          // _text("Subtotal (1 item)", "\$9024.99"),
          SizedBox(
            height: 5,
          ),
          // _text("Shipping fee", "\$ 15"),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                
                Expanded(
                  flex: 2,
                  child: _textField("", "Enter Voucher Code", 3),
                ),

                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(left: 4),
                    height: MediaQuery.of(context).size.height / 18,
                    width: MediaQuery.of(context).size.width / 29,
                    child: BottomButton(
                      name: "Apply",
                      customColor: true,
                      color: HexColor("#E8DDDD"),
                      ontap: () {
                        print("Voucher");
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  
Widget deleteButton()
{
  return GestureDetector(
                    onTap: ()
                    {
                      cartEmpty();
                    },
                    child: Icon(Icons.delete,color: Colors.red,),
                  );
}
  Widget _counter() {
    return Container(
      height: MediaQuery.of(context).size.height / 26,
      width: MediaQuery.of(context).size.width * .24,
      padding: EdgeInsets.symmetric(horizontal: 5),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(03),
        color: Colors.grey[200],
      ),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                counter >= 2 ? counter = counter - 1 : null;
              });
            },
            child: Container(
                height: 30,
                child: Icon(
                  Icons.remove,
                  size: 16,
                )),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 17),
              child: Text(
                "$counter",
                style: TextStyle(fontSize: 18),
              )),
          GestureDetector(
            onTap: () {
              setState(() {
                counter = counter + 1;
              });
            },
            child: Container(
                height: 30,
                child: Icon(
                  Icons.add,
                  size: 16,
                )),
          ),
        ],
      ),
    );
  }
}
