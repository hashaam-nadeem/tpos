import 'package:flutter/material.dart';
import 'package:transact/AppBar.dart';
import 'package:transact/Seller/sellerHome.dart';
import 'package:transact/utils/bottomButton.dart';
import 'package:transact/utils/routes.dart';
import 'package:transact/utils/utils.dart';

class Receipt extends StatefulWidget {
  @override
  _ReceiptState createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  var style = TextStyle(
      fontFamily: "CaviarDreams",
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: HexColor("#F5F7FA"),
          bottomNavigationBar: _bottomBar(),
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: Padding(
                padding: EdgeInsets.only(top: 0),
                child: CustomeAppBar(
                  title: "Receipt",
                  homepage: false,
                ),
              )),
          body: _body()),
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
            flex: 1,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: BottomButton(
                name: "Print",
                customColor: true,
                color: HexColor("#FF6D2B"),
                ontap: () {
                  _showDialog();
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: BottomButton(
                name: "Ok",
                customColor: true,
                color: HexColor("#FF6D2B"),
                ontap: () {
                  AppRoutes.replace(context, SellerHome());
                },
              ),
            ),
          )
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
            width: 300.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Receipt",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 5.0,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text("Select to print or save Receipt",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                      )),
                ),
                _button("Print", 1),
                _button("Send by email", 2),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * .06,
                    decoration: BoxDecoration(
                      color: HexColor("#3B444B"),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0)),
                    ),
                    child: Center(
                      child: Text(
                        "BACK",
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

  Widget _body() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Center(
        child: Column(
          children: <Widget>[
            _row("Amount Received:", 1000),
            _row("Total Cost:", 897),
            _divider(),
            _row("Change:", 103)
          ],
        ),
      ),
    );
  }

  Widget _row(String text, double amount) {
    return Container(
      margin: EdgeInsets.only(bottom: 5, top: 5),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Text(
            "$text",
            textAlign: TextAlign.right,
            style: style,
          )),
          Expanded(
              child: Text(
            "\$ $amount",
            textAlign: TextAlign.right,
            style: style,
          )),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      width: MediaQuery.of(context).size.width * .9,
      color: Colors.black,
    );
  }

  Widget _button(String name, int id) {
    return GestureDetector(
      onTap: () {
        setState(() {
          Navigator.pop(context);
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
        height: 50,
        // width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: HexColor("#F5F7FA")),

        child: Center(
          child: Text(
            "$name",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
