import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/Seller/sellerHome.dart';
import 'package:transact/utils/routes.dart';

import 'package:transact/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeliveryCost extends StatefulWidget {
  @override
  _DeliveryCostState createState() => _DeliveryCostState();
}

class _DeliveryCostState extends State<DeliveryCost> {

TextEditingController cost=TextEditingController();
TextEditingController order=TextEditingController();
ProgressDialog pr;
bool productSelected=false;
  setCost() async {
    pr.show();
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var body = {
      "PushNotificationEnabled": "",
      "SecurityPinEnabled": "",
      "DeliveryCost": "${cost.text}",
      "MinimumOrder": "${order.text}",
      "IsDeliveryFree":"${User.userData.isdeliveryFree}"
    };
    print(header);
    print(body);
    var response = await http.post(
      "${API.UpdateUserSetting}",
      headers: header,
      body:body,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if(response.statusCode==200)
    {
      if(Json['Data']['WithError']==false)
      {
        pr.dismiss();
        Fluttertoast.showToast(
              msg: "${Json['Data']['ShortMessage']}",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
               //AppRoutes.replace(context, SellerHome());
               Navigator.of(context).pop();
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
      Fluttertoast.showToast(
              msg: "Response Status: ${response.statusCode}",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(bottom: 10),
            width: MediaQuery.of(context).size.width,
            color: HexColor("#F5F7FA"),
            child: Stack(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      _cancelButton(),
                      _logo2(),
                      _deliveryText(),
                      _forgotCard(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _deliveryText() {
    return Container(
      // margin: EdgeInsets.only(top: 15),
      child: Column(
        children: <Widget>[
          Text(
            " Delivery Cost",
            style: TextStyle(fontSize: 18, color: HexColor("#000000")),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Text(
              "Please Add Delivery Cost ",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: HexColor("#000000")),
            ),
          ),
        ],
      ),
    );
  }

  Widget _forgotCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      // height: MediaQuery.of(context).size.height * .4,
      width: MediaQuery.of(context).size.width * .9,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5,
            ),
          ],
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: <Widget>[

            Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          User.userData.isdeliveryFree= !User.userData.isdeliveryFree;
                          //sellingTypeProduct = !sellingTypeProduct;
                        });
                      },
                      child: Container(
                        // margin: EdgeInsets.only(top:10),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.grey, width: 1.5)),
                        child: Center(
                          child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: User.userData.isdeliveryFree == true
                                    ? Colors.black
                                    : Colors.white,
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                      //height: 10,
                    ),
                    Text("Free Delivery", style: TextStyle(color: Colors.black,fontSize: 18)),
                  ],
                ),
               
            _text("Delivery Cost"),
            _textField("\$${User.userData.deliveryCost}", 1,cost),
            _text("On minumum order"),
            _textField("\$${User.userData.minOrder}", 2,order),
            _button(),
          ],
        ),
      ),
    );
  }

  Widget _text(String text) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 5),
      alignment: Alignment.centerLeft,
      child: Text(
        "$text",
        style: TextStyle(fontSize: 14, color: HexColor("#000000")),
      ),
    );
  }

  Widget _textField(String label, id,_controller) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      height: 50,
      child: TextFormField(
        controller: _controller,
        enabled: User.userData.isdeliveryFree==true?false:true,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          filled: true,
          fillColor: HexColor("#FFFFFF"),
          hintText: "$label",
          hintStyle: TextStyle(fontSize: 14, color: HexColor("#3B444B")),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: HexColor("#707070"))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 1, color: HexColor("#707070"))),
        ),
      ),
    );
  }

  Widget _logo2() {
    return Container(
      child: Image(
        height: MediaQuery.of(context).size.height * .3,
        width: MediaQuery.of(context).size.width * .25,
        //color: Colors.black,
        image: AssetImage("images/applogo.png"),
      ),
    );
  }

  Widget _button() {
    return GestureDetector(
      onTap: () {
        if(User.userData.isdeliveryFree==true)
        {
          setCost();
        }
        else
        {
          if(order.text.isEmpty || cost.text.isEmpty)
        {
          Fluttertoast.showToast(
              msg: "please enter the required field",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
        }
        else
        {
          setCost();
        }

        }
               
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.bottomCenter,
        height: MediaQuery.of(context).size.height * .07,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: HexColor("#3B444B")),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "Save",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _cancelButton() {
    return Align(
      alignment: Alignment.topLeft,
      child: GestureDetector(
        onTap: () {
          setState(() {
            Navigator.pop(context);
          });
        },
        child: Container(
          height: 25,
          width: 25,
          margin: EdgeInsets.all(15),
          child: Image.asset("images/cross.png"),
        ),
      ),
    );
  }
}
