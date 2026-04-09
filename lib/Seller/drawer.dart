import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/Seller/HistorySeller.dart';
import 'package:transact/Seller/SellerOrders.dart';
import 'package:transact/Seller/bundleItemsSeller.dart';
import 'package:transact/Seller/cashier.dart';

import 'package:transact/Seller/conversationSeller.dart';
import 'package:transact/Seller/expensesSeller.dart';
import 'package:transact/Seller/inventoryManagement.dart';
import 'package:transact/Seller/myAccount.dart';
import 'package:transact/Seller/orderReceived.dart';

import 'package:transact/Seller/purchaseProduct.dart';
import 'package:transact/Seller/reportsSeller.dart';
import 'package:transact/Seller/sellerHome.dart';

import 'package:transact/Seller/settings.dart';
import 'package:transact/Seller/wallet.dart';
import 'package:transact/Supplier/contactUs.dart';
import 'package:transact/Supplier/conversation.dart';
import 'package:transact/Supplier/expenses.dart';

import 'package:transact/loginSignUp/loginSignUp.dart';
import 'package:transact/utils/PaymentMethod.dart';
import 'package:transact/utils/bottomButton.dart';
import 'package:transact/utils/routes.dart';
import 'package:transact/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SellerDrawer extends StatefulWidget {
  @override
  _SellerDrawerState createState() => _SellerDrawerState();
}

class _SellerDrawerState extends State<SellerDrawer> {
  bool storeOpen = true;
  ProgressDialog pr;
  TextEditingController moduleName = TextEditingController();
  TextEditingController pin = TextEditingController();

  navigatorChecker() async {
    pr.show();
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var body = {
      "ModuleName": "${User.userData.drawerItem}",
      "Pin": "${pin.text}",
    };

    print(header);
    print(body);
    var response = await http.post(
      "${API.PinCheckerModuleName}",
      headers: header,
      body: body,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == false) {
        pr.dismiss();
        bool result=Json['Data']['Result'];
        print(result);
        
        if(result==true)
        {
          setState(() {
          User.userData.rememberPin=int.parse(pin.text.trim());
        });
          Navigator.of(context).pop();
          if (User.userData.drawerItem == 'Home') {
          // User.userData.drawerItem="Home";
          // _showDialog();
          AppRoutes.push(context, SellerHome());
        } else if (User.userData.drawerItem == 'Order Received') {
          AppRoutes.push(context, OrderManagement());
        } else if (User.userData.drawerItem == 'Conversations') {
          AppRoutes.push(context, Conversation());
        } else if (User.userData.drawerItem == 'Bundle Items') {
          AppRoutes.push(context, BundleItemsSeller());
        } else if (User.userData.drawerItem == 'Payment Method') {
          AppRoutes.push(context, PaymentMethod());
        } else if (User.userData.drawerItem == 'Inventory Management') {
          AppRoutes.push(context, InventoryManagementSeller());
        } else if (User.userData.drawerItem == 'Expenses') {
          AppRoutes.push(context, Expenses());
        } else if (User.userData.drawerItem == 'Reports') {
          AppRoutes.push(context, ReportsSeller());
        } else if (User.userData.drawerItem == 'History') {
          AppRoutes.push(context, SellerHistory());
        } else if (User.userData.drawerItem == 'Wallet') {
          AppRoutes.push(context, WalletSeller());
        } else if (User.userData.drawerItem == 'My Account') {
          AppRoutes.push(context, MyAccountSeller());
        } else if (User.userData.drawerItem == 'Contact Us') {
          AppRoutes.push(context, ContactUs());
        } else if (User.userData.drawerItem == 'Marketplace') {
          AppRoutes.push(context, PurchaseProduct());
        } else if (User.userData.drawerItem == 'My Orders') {
          AppRoutes.push(context, SellerOrders());
        } else if (User.userData.drawerItem == 'Cashier') {
          AppRoutes.push(context, Cashier());
        } else if (User.userData.drawerItem == 'Settings') {
          AppRoutes.push(context, SellerSettings());
        } else {
          // AppRoutes.replace(context, Conversation());
        }
        }
        else
        {
        //   Fluttertoast.showToast(
        //       msg: "${Json['Data']['ShortMessage']}",
        //       textColor: Colors.white,
        //       backgroundColor: Colors.blueGrey);
        // AppRoutes.replace(context, SellerHome());
        Navigator.of(context).pop();
        _showDialog2();
        }
        

        
         
      } else {
        pr.dismiss();
        Fluttertoast.showToast(
            msg: "${Json['Data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Response Status: ${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }

  updateIsOnline(bool newVal) async {
    pr.show();
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var body = {
      "status": "$newVal"
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
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == false) {
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
              Stack(children: [
                Center(
                  child: 
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.transparent,
                      backgroundImage: User.userData.userResult.imageUrl != null
                          ? NetworkImage(
                              "${API.API_URL}${User.userData.userResult.imageUrl}")
                          : AssetImage("images/profile.png"),
                    ),
                  ),
               
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: EdgeInsets.only(top: 30, right: 15),
                    child: Switch(
                        activeColor: Colors.green,
                        value: User.userData.userResult.isOnline,
                        onChanged: (newVal) {
                          updateIsOnline(newVal);

                          print("$storeOpen");
                        }),
                  ),
                )
              ]),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  "${User.userData.userResult.fullname}",
                  style: TextStyle(
                    color: HexColor("#343434"),
                    fontSize: 18.0,
                  ),
                ),
              ),
              _buildRow("images/home.png", "Home"),
              _buildRow("images/cartPurchase.png", "Marketplace"),
              _buildRow("images/cashier.png", "Cashier"),
              _buildRow("images/cart.png", "Order Received"),
              _buildRow(
                "images/conversation.png",
                "Conversations",
              ),
              _buildRow(
                "images/bundle.png",
                "Bundle Items",
              ),
              _buildRow("images/card.png", "Payment Method"),
              _buildRow("images/inventory.png", "Inventory Management"),
              _buildRow("images/expenses.png", "Expenses"),
              _buildRow("images/reports.png", "Reports"),
              _buildRow("images/cart.png", "My Orders"),
              _buildRow("images/history.png", "History"),
             // _buildRow("images/wallet.png", "Wallet"),
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
                        User.userData.addressLine = "";
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
          if (User.userData.userResult.securityEnabled == true) {
            if (title == 'Home') {
              User.userData.drawerItem = "Home";
              setState(() {
                pin.clear();
              });
              _showDialog();
              //AppRoutes.push(context, SellerHome());
            } else if (title == 'Order Received') {
              User.userData.drawerItem = "Order Received";
              setState(() {
                pin.clear();
              });
              _showDialog();
              //AppRoutes.push(context, OrderManagement());
            } else if (title == 'Conversations') {
              User.userData.drawerItem = "Conversations";
              setState(() {
                pin.clear();
              });
              _showDialog();
              // AppRoutes.push(context, Conversation());
            } else if (title == 'Bundle Items') {
              User.userData.drawerItem = "Bundle Items";
              setState(() {
                pin.clear();
              });
              _showDialog();
              // AppRoutes.push(context, BundleItemsSeller());
            } else if (title == 'Payment Method') {
              User.userData.drawerItem = "Payment Method";
              setState(() {
                pin.clear();
              });
              _showDialog();
              //AppRoutes.push(context, PaymentMethod());
            } else if (title == 'Inventory Management') {
              User.userData.drawerItem = "Inventory Management";
              setState(() {
                pin.clear();
              });
              _showDialog();
              
              //AppRoutes.push(context, InventoryManagementSeller());
            } else if (title == 'Expenses') {
              User.userData.drawerItem = "Expenses";
              setState(() {
                pin.clear();
              });
              _showDialog();
              //AppRoutes.push(context, Expenses());
            } else if (title == 'Reports') {
              User.userData.drawerItem = "Reports";
              setState(() {
                pin.clear();
              });
              _showDialog();
              //AppRoutes.push(context, ReportsSeller());
            } else if (title == 'History') {
              User.userData.drawerItem = "History";
              setState(() {
                pin.clear();
              });
              _showDialog();
              //AppRoutes.push(context, SellerHistory());
            } else if (title == 'Wallet') {
              User.userData.drawerItem = "Wallet";
              setState(() {
                pin.clear();
              });
              _showDialog();
              //AppRoutes.push(context, WalletSeller());
            } else if (title == 'My Account') {
              User.userData.drawerItem = "My Account";
              setState(() {
                pin.clear();
              });
              _showDialog();
              //AppRoutes.push(context, MyAccountSeller());
            } else if (title == 'Contact Us') {
              User.userData.drawerItem = "Contact Us";
              setState(() {
                pin.clear();
              });
              _showDialog();
              //AppRoutes.push(context, ContactUs());
            } else if (title == 'Marketplace') {
              User.userData.drawerItem = "Marketplace";
              setState(() {
                pin.clear();
              });
              _showDialog();
              // AppRoutes.push(context, PurchaseProduct());
            } else if (title == 'My Orders') {
              User.userData.drawerItem = "My Orders";
              setState(() {
                pin.clear();
              });
              _showDialog();
              //AppRoutes.push(context, SellerOrders());
            } else if (title == 'Cashier') {
              User.userData.drawerItem = "Cashier";
              setState(() {
                pin.clear();
              });
              _showDialog();
              //AppRoutes.push(context, Cashier());
            } else if (title == 'Settings') {
              User.userData.drawerItem = "Settings";
              setState(() {
                pin.clear();
              });
              _showDialog();
              //AppRoutes.push(context, SellerSettings());
            } else {
              // AppRoutes.replace(context, Conversation());
            }
          } else {
            if (title == 'Home') {
              AppRoutes.push(context, SellerHome());
            } else if (title == 'Order Received') {
              AppRoutes.push(context, OrderManagement());
            } else if (title == 'Conversations') {
              AppRoutes.push(context, Conversation());
            } else if (title == 'Bundle Items') {
              AppRoutes.push(context, BundleItemsSeller());
            } else if (title == 'Payment Method') {
              AppRoutes.push(context, PaymentMethod());
            } else if (title == 'Inventory Management') {
              AppRoutes.push(context, InventoryManagementSeller());
            } else if (title == 'Expenses') {
              AppRoutes.push(context, Expenses());
            } else if (title == 'Reports') {
              AppRoutes.push(context, ReportsSeller());
            } else if (title == 'History') {
              AppRoutes.push(context, SellerHistory());
            } else if (title == 'Wallet') {
              AppRoutes.push(context, WalletSeller());
            } else if (title == 'My Account') {
              AppRoutes.push(context, MyAccountSeller());
            } else if (title == 'Contact Us') {
              AppRoutes.push(context, ContactUs());
            } else if (title == 'Marketplace') {
              AppRoutes.push(context, PurchaseProduct());
            } else if (title == 'My Orders') {
              AppRoutes.push(context, SellerOrders());
            } else if (title == 'Cashier') {
              AppRoutes.push(context, Cashier());
            } else if (title == 'Settings') {
              AppRoutes.push(context, SellerSettings());
            } else {
              // AppRoutes.replace(context, Conversation());
            }
          }

          // title == 'Home'
          //     ? AppRoutes.replace(context, SellerHome())
          //     : title == 'Conversations'
          //         ? AppRoutes.push(context, Conversation())
          //         : title == 'Order Received'
          //             ? AppRoutes.push(context, OrderManagement())
          //             : title == "Marketplace"
          //                 ? AppRoutes.push(context, PurchaseProduct())
          //                 : title == 'Bundle Items'
          //                     ? AppRoutes.push(context, BundleItemsSeller())
          //                     : title == 'Payment Method'
          //                         ? AppRoutes.push(context, PaymentMethod())
          //                         : title == 'Cashier'
          //                             ? AppRoutes.push(context, Cashier())
          //                             : title == 'Inventory Management'
          //                                 ? AppRoutes.push(
          //                                     context, InventoryManagementSeller())
          //                                 : title == 'Expenses'
          //                                     ? AppRoutes.push(
          //                                         context, Expenses())
          //                                     : title == 'Reports'
          //                                         ? AppRoutes.push(
          //                                             context, ReportsSeller())
          //                                         : title == 'History'
          //                                             ? AppRoutes.push(
          //                                                 context, SellerHistory())
          //                                             : title == 'Wallet'
          //                                                 ? AppRoutes.push(
          //                                                     context,
          //                                                     WalletSeller())
          //                                                 : title == 'My Account'
          //                                                     ? AppRoutes.push(
          //                                                         context,
          //                                                         MyAccountSeller())
          //                                                     : title ==
          //                                                             'Settings'
          //                                                         ? AppRoutes.push(
          //                                                             context,
          //                                                             SellerSettings())
          //                                                         : title ==
          //                                                                 'Contact Us'
          //                                                             ? AppRoutes.push(
          //                                                                 context,
          //                                                                 ContactUs())
          //                                                             : title ==
          //                                                                     'My Orders'
          //                                                                 ? AppRoutes.push(context, SellerOrders())
          //                                                                 : null;
        },
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 17),
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

  void _showDialog2() {
    showDialog(
        context: context,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: MediaQuery.of(context).size.width / 1.2,
            // height: MediaQuery.of(context).size.height/10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                    alignment: Alignment.center,
                    child: Container(
                        width: MediaQuery.of(context).size.width / 1.8,
                        child: Text(
                          "Forbidden",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ))),
                Align(
                    alignment: Alignment.center,
                    child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 30),
                        child: Text(
                          "Not Allowed to Access ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ))),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * .06,
                    padding: EdgeInsets.only(
                      top: 15.0,
                    ),
                    decoration: BoxDecoration(
                      color: HexColor("#3B444B"),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0)),
                    ),
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
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
                      "Input Pin",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ))),
                _textField('${User.userData.drawerItem}', moduleName),
                _textField("Pin", pin),
                GestureDetector(
                  onTap: () {
                    if (pin.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Pin not entered",
                          textColor: Colors.white,
                          backgroundColor: Colors.blueGrey);
                    } else {
                      navigatorChecker();
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

  Widget _textField(String label, _controller) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      height: 45,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: TextFormField(
          enabled: label == "Pin" ? true : false,
          controller: _controller,
          maxLength: 4,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
          ],
          keyboardType: TextInputType.phone,
          onFieldSubmitted: (String text) {
            print("$text");
          },
          decoration: InputDecoration(
            filled: true,
            counterText: "",
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

}
