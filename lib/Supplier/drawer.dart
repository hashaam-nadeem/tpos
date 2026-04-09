import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/loginSignUp/loginSignUp.dart';
import 'package:transact/utils/PaymentMethod.dart';
import 'package:transact/utils/bottomButton.dart';
import 'package:transact/utils/routes.dart';
import 'package:transact/utils/utils.dart';
import 'package:transact/Supplier/History.dart';

import 'package:transact/Supplier/bundleItems.dart';
import 'package:transact/Supplier/contactUs.dart';
import 'package:transact/Supplier/conversation.dart';
import 'package:transact/Supplier/expenses.dart';
import 'package:transact/Supplier/inventoryManagement.dart';
import 'package:transact/Supplier/myAccount.dart';
import 'package:transact/Supplier/orderReceived.dart';

import 'package:transact/Supplier/reports.dart';
import 'package:transact/Supplier/settings.dart';
import 'package:transact/Supplier/wallet.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
class SupplierDrawer extends StatefulWidget {
  @override
  _SupplierDrawerState createState() => _SupplierDrawerState();
}

class _SupplierDrawerState extends State<SupplierDrawer> {
  ProgressDialog pr;
  updateIsOnline(bool newVal)async
{
  
  pr.show();
  var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var body = {
      "status":"$newVal"
      // "Password": "${loginPass.text.trim()}",
      // "DeviceNumber": "$deviceId",
      // "FCM": "$notificationToken",
    };
    print(body);
    var response = await http.post(
      "${API.markUserOnline}",
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
        setState(() {
                            
                            User.userData.userResult.isOnline = newVal;
                          });
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
    return Drawer(
      elevation: 3,
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

              Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: EdgeInsets.only(top: 10, right: 15),
                    child: Switch(
                        activeColor: Colors.green,
                        value: User.userData.userResult.isOnline,
                        onChanged: (newVal) {
                          updateIsOnline(newVal);
                          
                          //print("$storeOpen");
                        }),
                  ),
                ),
              Container(
                margin: EdgeInsets.only(top: 25),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.transparent,
                  backgroundImage: User.userData.userResult.imageUrl!=null?
                  NetworkImage("${API.API_URL}${User.userData.userResult.imageUrl}")
                  : AssetImage("images/profile.png"),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 2, bottom: 10),
                child: Text(
                  "${User.userData.userResult.fullname}",
                  style: TextStyle(
                    color: HexColor("#343434"),
                    fontSize: 18.0,
                  ),
                ),
              ),
              
              
              _buildRow("images/home.png", "Home"),
              _buildRow("images/cart.png", "Order Received"),
              _buildRow(
                "images/conversation.png",
                "Conversation",
              ),
              _buildRow(
                "images/bundle.png",
                "Bundle Items",
              ),
              _buildRow("images/card.png", "Payment Method"),
              _buildRow("images/inventory.png", "Inventory Management"),
              _buildRow("images/expenses.png", "Expenses"),
              _buildRow("images/reports.png", "Reports"),
              _buildRow("images/history.png", "History"),
              //_buildRow("images/wallet.png", "Wallet"),
              _buildRow("images/user2.png", "My Account"),
              _buildRow("images/settings.png", "Settings"),
              _buildRow("images/contact-us.png", "Contact Us"),
              GestureDetector(
                child: Container(
                  width: double.infinity,
                  child: BottomButton(
                    name: "LOG OUT",
                    image: Image(
                      height: 20,
                      width: 20,
                      image: AssetImage("images/logout.png"),
                    ),
                    ontap: () {
                      setState(() {
                      User.userData.addressLine="";
                      });
                      AppRoutes.makeFirst(context, Login());
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(
    String image,
    String title,
  ) {
    final TextStyle tStyle =
        TextStyle(color: HexColor("#343434"), fontSize: 17.0);
    return InkWell(
        onTap: () {
       
          title == 'Home'
              ? Navigator.pop(context)
              : title == 'Conversation'
                  ? AppRoutes.push(context, Conversation())
                  : title == 'Contact Us'
                      ? AppRoutes.push(context, ContactUs())
                      : title == 'Payment Method'
                          ? AppRoutes.push(context, PaymentMethod())
                          : title == 'History'
                              ? AppRoutes.push(context, SupplierHistory())
                              : title == 'Wallet'
                                  ? AppRoutes.push(context, Wallet())
                                  : title == 'Order Received'
                                      ? AppRoutes.push(context, OrderReceived())
                                      : title == 'My Account'
                                          ? AppRoutes.push(context, MyAccount())
                                          : title == 'Settings'
                                              ? AppRoutes.push(
                                                  context, Settings())
                                              : title == 'Bundle Items'
                                                  ? AppRoutes.push(
                                                      context, BundleItems())
                                                  : title ==
                                                          'Inventory Management'
                                                      ? AppRoutes.push(context,
                                                          InventoryManagement())
                                                      : title == 'Expenses'
                                                          ? AppRoutes.push(
                                                              context,
                                                              Expenses())
                                                          : title == 'Reports'
                                                              ? AppRoutes.push(
                                                                  context,
                                                                  Reports())
                                                              : null;
        },
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 1, horizontal: 17),
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Row(children: [
              Image(
                height: 25,
                width: 25,
                image: AssetImage("$image"),
              ),
              SizedBox(width: 17.0),
              Text(
                title,
                style: tStyle,
              ),
            ])));
  }
}
