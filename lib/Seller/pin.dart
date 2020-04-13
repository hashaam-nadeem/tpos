
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:transact/AppBar.dart';
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/Model/pinsmodel.dart';
import 'package:transact/Seller/addExpense.dart';
import 'package:transact/Seller/securityitems.dart';
import 'package:transact/utils/bottomButton.dart';
import 'package:transact/utils/routes.dart';
import 'package:transact/utils/utils.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';

class PIN extends StatefulWidget {
  @override
  _PINState createState() => _PINState();
}

class _PINState extends State<PIN> {
  bool switchControl = false;
  bool marketSwitch = false;
  bool cashierSwitch = false;
  bool orderSwitch = false;
  bool chatSwitch = false;
  bool bundleSwitch = false;
  bool inventorySwitch = false;
  bool paymentSwitch = false;
  bool expensesSwitch = false;
  bool reportSwitch = false;
  bool myOrderSwitch = false;
  bool historySwitch = false;
  bool walletSwitch = false;
  bool myAccountSwitch = false;
  bool settingsSwitch = false;
  PinsModel pinsModel=PinsModel();
  TextEditingController pin=TextEditingController();
    TextEditingController confirmPin=TextEditingController();
  var style1 =
      TextStyle(fontFamily: "CaviarDreams", fontSize: 20, color: Colors.white);
      ProgressDialog pr;

        getPins()async
      {
          var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    print(header);
    var response = await http.get(
      "${API.ViewUserPins}",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if(response.statusCode==200)
    {
      if(Json['Data']['WithError']==false)
      {
        setState(() {
          pinsModel=PinsModel.fromJson(Json['Data']);
        });
       // User.userData.rememberPin=int.parse(pinsModel.result[0].pin);
        //print(User.userData.rememberPin);

      }
      else
      {
        setState(() {
          pinsModel=PinsModel();
        });
         Fluttertoast.showToast(
              msg: "${Json['Data']['ShortMessage']}",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
      }
    }
    else
    {
       Fluttertoast.showToast(
              msg: "response status: ${response.statusCode}",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
    }
      }
    

                setNewPin() async {
    pr.show();
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var body = {
      "Pin": "${pin.text}",
      
    };

    print(header);
    print(body);
    var response = await http.post(
      "${API.AddSecurityPin}",
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
        getPins();
        _showDialog2();
        // Fluttertoast.showToast(
        //       msg: "${Json['Data']['ShortMessage']}",
        //       textColor: Colors.white,
        //       backgroundColor: Colors.blueGrey);
        //        //AppRoutes.replace(context, SellerHome());
              // Navigator.of(context).pop();
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
  void initState() {
    // TODO: implement initState
    super.initState();
    getPins();
  }
     
  @override
  Widget build(BuildContext context) {
        pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
      message: 'Please wait...',
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
            preferredSize: Size.fromHeight(70),
            child: Padding(
              padding: EdgeInsets.only(top: 0),
              child: CustomeAppBar(
                title: "Security",
                homepage: false,
              ),
            )),
            bottomNavigationBar: BottomButton(
            name: "+ ADD NEW PIN",
            ontap: () {
              _showDialog();
              pin.clear();
              confirmPin.clear();
              //_checkList();
              //AppRoutes.push(context, AddExpenseSeller());
            },
          ),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
            child: Column(
        children: <Widget>[
          //_list("Security Pin", 1),
           Container(
          margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Text(
            "---- Select Pin to add module -----",
            style: TextStyle(fontSize: 16),
          ),
        ),
           Expanded(
             child: ListView.builder(itemBuilder: (BuildContext context,int index)
               {
                 return _checkList(index);
               },
               itemCount: pinsModel.result!=null?pinsModel.result.length:0,
               ),
           ),
        ],
      ),
    );
  }

  Widget _checkList(int index) {
    return GestureDetector(
      onTap: ()
      {
        setState(() {
          User.userData.index=index;
        User.userData.pin=pinsModel.result[index].pin;
        });
        print(User.userData.pin);
        AppRoutes.push(context, SecurityItems());
      },
      child:   Container(
        margin: EdgeInsets.only(top:10),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height*.05,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color:Colors.grey,width:1),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
       Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: <Widget>[
           Row(
             children: <Widget>[
               Icon(
             Icons.fiber_pin,
           ),
           _list("${pinsModel.result[index].pin}", 2),
             ],
           ),
           Icon(
             Icons.settings
           ),
         ],
       ),
        
        // _list("Marketplace", 3),
        // _list("Cashier", 4),
        // _list("Order Management", 5),
        // _list("Conversation", 6),
        // _list("Budle Items", 7),
        // _list("Payment method", 8),
        // _list("Inventory Management", 9),
        // _list("Expenses", 10),
        // _list("Reports", 11),
        // _list("My Orders", 12),
        // _list("History", 13),
        // _list("Wallet", 14),
        // _list("My Account", 15),
        // _list("Settings", 16),
      ],
    ))
    );
  
  }

  Widget _list(String text, int id) {
    return Container(
      margin: EdgeInsets.only(left:15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "$text",
            style: style1.copyWith(
                color: Colors.black, fontSize:  20),
          ),
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
          content: Container(
            width: MediaQuery.of(context).size.width / 1.2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                    alignment: Alignment.center,
                    child: Container(
                        child: Text(
                      "Input to set your pin",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ))),
                _textField('pin',pin),
                _textField("Confirm Pin",confirmPin),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    if(int.parse(pin.text)!=int.parse(confirmPin.text))
                    {
                               Fluttertoast.showToast(
              msg: "Pin doesn't match",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
                    }
                    else if(pin.text.isEmpty || confirmPin.text.isEmpty)
                    {
                      Fluttertoast.showToast(
              msg: "Pin enter pin",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
                    }
                    else
                    {
                      setNewPin();
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

  Widget _textField(String label,_controller) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      height: 45,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: TextFormField(
        maxLength: 4,
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
                          "Congragulation",
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
                          "Your PIN has been set Successfully ",
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

  void toggleSwitch(bool value) {
    switchControl == false
        ? setState(() {
            switchControl = true;
            _showDialog();
          })
        : setState(() {
            switchControl = false;
            print("false");
          });
  }

  void toggleMarket(bool value) {
    marketSwitch == false
        ? setState(() {
            marketSwitch = true;
          })
        : setState(() {
            marketSwitch = false;
            print("false");
          });
  }

  void cashier(bool value) {
    cashierSwitch == false
        ? setState(() {
            cashierSwitch = true;
          })
        : setState(() {
            cashierSwitch = false;
            print("false");
          });
  }

  void order(bool value) {
    orderSwitch == false
        ? setState(() {
            orderSwitch = true;
          })
        : setState(() {
            orderSwitch = false;
            print("false");
          });
  }

  void chat(bool value) {
    chatSwitch == false
        ? setState(() {
            chatSwitch = true;
          })
        : setState(() {
            chatSwitch = false;
            print("false");
          });
  }

  void bundle(bool value) {
    bundleSwitch == false
        ? setState(() {
            bundleSwitch = true;
          })
        : setState(() {
            bundleSwitch = false;
          });
  }

  void payment(bool value) {
    paymentSwitch == false
        ? setState(() {
            paymentSwitch = true;
          })
        : setState(() {
            paymentSwitch = false;
            print("false");
          });
  }

  void inventory(bool value) {
    myOrderSwitch == false
        ? setState(() {
            inventorySwitch = true;
          })
        : setState(() {
            inventorySwitch = false;
            print("false");
          });
  }

  void expenses(bool value) {
    expensesSwitch == false
        ? setState(() {
            expensesSwitch = true;
          })
        : setState(() {
            expensesSwitch = false;
            print("false");
          });
  }

  void reports(bool value) {
    reportSwitch == false
        ? setState(() {
            reportSwitch = true;
          })
        : setState(() {
            reportSwitch = false;
            print("false");
          });
  }

  void myOrder(bool value) {
    myOrderSwitch == false
        ? setState(() {
            myOrderSwitch = true;
          })
        : setState(() {
            myOrderSwitch = false;
            print("false");
          });
  }

  void history(bool value) {
    historySwitch == false
        ? setState(() {
            historySwitch = true;
          })
        : setState(() {
            historySwitch = false;
            print("false");
          });
  }

  void wallet(bool value) {
    walletSwitch == false
        ? setState(() {
            walletSwitch = true;
          })
        : setState(() {
            walletSwitch = false;
            print("false");
          });
  }

  void myAccount(bool value) {
    myAccountSwitch == false
        ? setState(() {
            myAccountSwitch = true;
          })
        : setState(() {
            myAccountSwitch = false;
            print("false");
          });
  }

  void settings(bool value) {
    settingsSwitch == false
        ? setState(() {
            settingsSwitch = true;
          })
        : setState(() {
            settingsSwitch = false;
            print("false");
          });
  }
}
