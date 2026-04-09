import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:transact/AppBar.dart';
import 'package:transact/Buyer/buyerAddress.dart';
import 'package:transact/Buyer/buyerPaymentSelection.dart';
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/utils/bottomButton.dart';
import 'package:transact/utils/dialogBox.dart';
import 'package:transact/utils/fonts.dart';
import 'package:transact/utils/routes.dart';
import 'package:transact/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CheckOut extends StatefulWidget {
  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  var editAdress = false;
  int deliverycostCheck = 5;
  int selected = 5;
  TextEditingController email=TextEditingController();
    TextEditingController contact=TextEditingController();
      TextEditingController voucher=TextEditingController();
  double shippingFee = 15;
  double grandTotal = 0.0;
  getdeliveryCost() async {
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    print(header);
    var response = await http.get(
      "${API.getDeliveryCost}",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == true) {
        Fluttertoast.showToast(
            msg: "no Address found",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      } else {
        setState(() {
          // cartFount=true;
          // cartModel=CartModel.fromJson(Json['Data']);
        });
        // for(int i=0;i<cartModel.result.length;i++)
        // {
        //   setState(() {
        //     total=total+cartModel.result[i].lineTotal;
        //   });
        // }
      }
    } else {
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
    grandTotal = User.userData.totalCart;
    // getdeliveryCost();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("#F5F7FA"),
        bottomNavigationBar: _bottomBar(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: CustomeAppBar(
            title: "Check Out",
            homepage: false,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[_buyerInfo(), _deliveryOptions(), 
           // _voucher()
            ],
          ),
        ),
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
                      text: "\$$grandTotal",
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
                  name: "Proceed to Pay",
                  customColor: true,
                  color: HexColor("#FF6D2B"),
                  ontap: () {
                    // selected == 2
                    //     ? showDialog(
                    //         context: context,
                    //         child: DialogBox(
                    //           title: "Pick up Location",
                    //           buttonName: "OK",
                    //           child: Container(
                    //             child: Column(
                    //               children: <Widget>[
                    //                 Container(
                    //                   margin: EdgeInsets.only(
                    //                     top: 5,
                    //                     left: 10,
                    //                     right: 10,
                    //                   ),
                    //                   child: Text(
                    //                     "Lorem ipsum dolor sit amet, consectetur adipiscing elit,"
                    //                     " sed do eiusmod tempor incididunt. ",
                    //                     style: TextStyle(
                    //                         fontSize: 16,
                    //                         fontFamily: "CaviarDreams",
                    //                         color: Colors.grey),
                    //                   ),
                    //                 ),
                    //                 Align(
                    //                   alignment: Alignment.bottomRight,
                    //                   child: GestureDetector(
                    //                     onTap: () {},
                    //                     child: Container(
                    //                       padding: EdgeInsets.all(5),
                    //                       margin: EdgeInsets.only(
                    //                           right: 20, top: 15, bottom: 15),
                    //                       width: 100,
                    //                       height: 30,
                    //                       decoration: BoxDecoration(
                    //                           color: Colors.white,
                    //                           borderRadius:
                    //                               BorderRadius.circular(20),
                    //                           boxShadow: [
                    //                             BoxShadow(
                    //                               blurRadius: 5,
                    //                               color: Colors.grey[300],
                    //                             )
                    //                           ]),
                    //                       child: Center(
                    //                         child: Text(
                    //                           "Link to the Map",
                    //                           style: TextStyle(
                    //                               fontSize: 14,
                    //                               color: Colors.blueAccent),
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 )
                    //               ],
                    //             ),
                    //           ),
                    //           ontap: () {
                    //             Navigator.pop(context);
                    //           },
                    //         ))
                    //     :
                    if (selected == 5) {
                      Fluttertoast.showToast(
                          msg: "please select delivery option first",
                          textColor: Colors.white,
                          backgroundColor: Colors.blueGrey);
                    } else if (selected == 200) {
                      Fluttertoast.showToast(
                          msg: "Unavailable",
                          textColor: Colors.white,
                          backgroundColor: Colors.blueGrey);
                    } else {
                      if(email.text.isNotEmpty || contact.text.isNotEmpty)
                      {
                        setState(() {
                        User.userData.totalCart=grandTotal;
                        User.userData.email=email.text.trim();
                        User.userData.contact=contact.text.trim();
                      });
                      print(User.userData.contact);
                      AppRoutes.push(context, BuyerPaymentSelection());
                      }
                      else
                      {
                        setState(() {
                        User.userData.totalCart=grandTotal;
                      });
                      AppRoutes.push(context, BuyerPaymentSelection());
                      }
                      
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }

  Widget _buyerInfo() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 20,
                    width: 20,
                    child: Image.asset("images/location.png"),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Text(
                    "${User.userData.userResult.fullname}",
                    textAlign: TextAlign.start,
                    style: headingFont,
                  ),
                ),
                // Expanded(
                //   child: GestureDetector(
                //     onTap: () {
                //       AppRoutes.push(context, BuyerAdress());
                //     },
                //     child: Container(
                //         child: Text(
                //       "EDIT",
                //       style: headingFont.copyWith(fontSize: 17),
                //     )),
                //   ),
                // )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 40, right: 10, top: 10),
            child: Text(
                "${User.userData.addressModel.result[User.userData.index].address}"),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 5),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Expanded(
                  flex: 6,
                  child: Text(
                    "Bill the Same Address",
                    textAlign: TextAlign.start,
                    style: headingFont,
                  ),
                ),
                // Expanded(
                //   child: GestureDetector(
                //     onTap: () {
                //       setState(() {
                //         editAdress = true;
                //       });
                //     },
                //     child: Container(
                //         child: Text(
                //       "EDIT",
                //       style: headingFont.copyWith(fontSize: 17),
                //     )),
                //   ),
                // )
              ],
            ),
          ),
          _textField("images/email.png", "${User.userData.email}", 1,email),
          _textField("images/phone.png", "${User.userData.contact}", 2,contact)
        ],
      ),
    );
  }

  Widget _deliveryOptions() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 0.0),
      margin: EdgeInsets.only(
        top: 5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text("Delivery Options", style: headingFont)),
         Row(
           children: <Widget>[
             Text("   "),
            User.userData.isdeliveryFree==true?
             _optionCard(3):
             _optionCard(0),
              Text(""),
              User.userData.onlineDelivery==true?
              _optionCard(1)
              :Text(""),
              User.userData.buyerPickup==true?
              _optionCard(2)
              :Text(""),
           ],
         ),
         
        ],
      ),
    );
  }

  Widget _optionCard(int id) {
    return GestureDetector(
      onTap: () {
        setState(() {
              User.userData.deliveryOption = id;
              selected = id;
            });
        setState(() {

          if (id == 0) {
            if(deliverycostCheck==0)
            {
              Fluttertoast.showToast(
                msg: "Already Selected",
                textColor: Colors.white,
                backgroundColor: Colors.blueGrey);
            }
            else
            {
              setState(() {
              deliverycostCheck = 0;
              grandTotal =
                  grandTotal + User.userData.deliveryCost;
            });
            }
            
          } else if (id == 1) {
            Fluttertoast.showToast(
                msg: "not Available",
                textColor: Colors.white,
                backgroundColor: Colors.blueGrey);
          } else {
            if(deliverycostCheck==0)
            {
              deliverycostCheck = 5;
              grandTotal=
                  grandTotal - User.userData.deliveryCost;
            }
            else
            {
              // User.userData.totalCart =
              //     User.userData.deliveryCost + User.userData.totalCart
            }
            
          }
          // id == 1 ? null : ;
        });
      },
      child: Container(
        //margin: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
        //padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width*.32,
        height: MediaQuery.of(context).size.height*.14,
        decoration: BoxDecoration(
          border: Border.all(
            color: selected == id ? HexColor("#FF6D2B") : HexColor("#79C5D6"),
          ),
          borderRadius: BorderRadius.circular(10),
          color: id == 1 ? Colors.grey[200] : HexColor("#FAFAFA"),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              id == 0
                  ? "Seller Delivery"
                  : id == 1 ? "Online Delivery" : 
                  id==3?
                  "free Delivery"
                  :
                  "Self Pickup",
              style: headingFont.copyWith(color: Colors.black),
            ),
            id == 2
                ? Container(
                    child: Text(
                      "${User.userData.addressLine}",
                      style: headingFont.copyWith(
                          color: Colors.black, fontSize: 12),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: id == 1
                        ? Container(
                            child: Text("Unavailable"),
                          )
                        : Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 5),
                                height: 17,
                                width: 17,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue,
                                ),
                                padding: EdgeInsets.all(1),
                                child: Icon(
                                  Icons.check,
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "\$${User.userData.deliveryCost}",
                                style: headingFont.copyWith(
                                    color: Colors.black, fontSize: 12),
                              )
                            ],
                          ),
                  ),
            id == 2
                ? Container(
                    child: Text(
                      "",
                      style: headingFont.copyWith(
                          color: Colors.black, fontSize: 12),
                    ),
                  )
                : Container(
                    child:
                        Text(id == 1 ? "Unavailable" : id==3?
                        ""
                        :"    Get within 4 to 6 days",
                            style: headingFont.copyWith(
                              color: Colors.black,
                              fontSize: 12,
                            )),
                  )
          ],
        ),
      ),
    );
  }

  Widget _textField(String image, String label, id,_controller) {
    return Container(
      margin: EdgeInsets.only(right: 20, top: 5),
      height: 45,
      child: TextFormField(
        controller: _controller,
        //enabled: editAdress,
        decoration: InputDecoration(
          isDense: true,
          icon: image == ""
              ? null
              : Container(
                  padding: EdgeInsets.only(left: 6),
                  height: 30,
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
          _text("Subtotal ", "\$${User.userData.totalCart}"),
          SizedBox(
            height: 5,
          ),
          selected==0?
          _text("Delivery fee", "\$ ${User.userData.deliveryCost}"):
          Text(""),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: _textField("", "Enter Voucher Code", 3,voucher),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 45,
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

  Widget _text(String text1, String text2) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "$text1",
          style: headingFont.copyWith(color: HexColor("#363636"), fontSize: 14),
        ),
        Text(
          "$text2",
          style: headingFont.copyWith(color: Colors.black, fontSize: 14),
        ),
      ],
    ));
  }
}
