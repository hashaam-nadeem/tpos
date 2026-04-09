import 'package:flutter/material.dart';
import 'package:transact/Seller/receipt.dart';
import 'package:transact/utils/bottomButton.dart';
import 'package:transact/utils/routes.dart';
import 'package:transact/utils/utils.dart';

import '../AppBar.dart';

class Sellerorder extends StatefulWidget {
  @override
  _SellerorderState createState() => _SellerorderState();
}

class _SellerorderState extends State<Sellerorder> {
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
                  title: "Order",
                  homepage: false,
                ),
              )),
          body: SingleChildScrollView(child: centerpart())),
    );
  }

  Widget _textFieldone(String label) {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      height: 39,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: TextFormField(
          keyboardType: TextInputType.phone,
          onFieldSubmitted: (String text) {
            print("$text");
          },
          decoration: InputDecoration(
              filled: true,
              fillColor: HexColor("#FFFFFF"),
              hintText: "$label",
              hintStyle: TextStyle(fontSize: 14, color: Colors.black54),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: HexColor("#707070"))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(width: 1, color: HexColor("#707070"))),
              contentPadding: EdgeInsets.only(left: 40))),
    );
  }

  Widget _textField(String label) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      height: 45,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: TextFormField(
          onFieldSubmitted: (String text) {
            print("$text");
          },
          decoration: InputDecoration(
            filled: true,
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
                      text: "Cancel Order",
                      style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff6B6B6B),
                          fontWeight: FontWeight.bold)),
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
                name: "Proceed",
                customColor: true,
                color: HexColor("#FF6D2B"),
                ontap: () {
                  _showDialog();
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
            width: MediaQuery.of(context).size.width / 1.2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                    alignment: Alignment.center,
                    child: Container(
                        child: Text(
                      "Please provide your cashier pin to proceed further.",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ))),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    child: _textField('Password')),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _showDialog1();
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
                        "Proceed",
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
                          "You have successfully Added this transaction ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ))),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    AppRoutes.push(context, Receipt());
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
                      "Proceed",
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

  void _showDialog1() {
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
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                    alignment: Alignment.center,
                    child: Container(
                        child: Text(
                      "Please enter received amount.",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ))),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: _textFieldone('\$590')),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _showDialog2();
                  },
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * .063,
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
                      "Proceed",
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

  Widget centerpart() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        children: <Widget>[
          upperpart(),
          SizedBox(
            height: 5,
          ),
          lowerpart()
        ],
      ),
    );
  }

  Widget upperpart() {
    return Card(
        child: Container(
      height: MediaQuery.of(context).size.height / 5.6,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text('10-01-2020',
                    style: TextStyle(
                        color: Color(0xff6B6B6B),
                        fontSize: 10,
                        fontWeight: FontWeight.bold))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Order #',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  width: 25,
                ),
                Text('CKF12432',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('cashier',
                    style: TextStyle(
                        color: Color(0xff6B6B6B),
                        fontSize: 10,
                        fontWeight: FontWeight.bold))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Payment Method',
                    style: TextStyle(
                        color: Color(0xff6B6B6B),
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  width: 25,
                ),
                Text('On shop',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20, top: 05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text('\$954',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold))
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget lowerpart() {
    return Card(
        child: Container(
            height: MediaQuery.of(context).size.height / 3.6,
            child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20, top: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Order Detail',
                        style: TextStyle(
                            color: Color(0xff6B6B6B),
                            fontSize: 16,
                            fontWeight: FontWeight.bold))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 6,
                          child: Image.asset(
                            'images/item3.png',
                            scale: 1,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'iPhone X',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff3B444B),
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  '1 x \$924.99',
                                  style: TextStyle(
                                      color: Color(0xff515C6F),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )),
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Text(
                          '\$924.99',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
              Text('___________________________________________',
                  style: TextStyle(
                    color: Colors.grey,
                  )),
              Padding(
                padding: EdgeInsets.only(left: 20, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 6,
                          child: Image.asset(
                            'images/kurti.png',
                            scale: 1,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Ladies Kurti',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff3B444B),
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  '2 x \$25',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color(0xff515C6F),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )),
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Text(
                          '\$50',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              )
            ])));
  }
}
