import 'package:flutter/material.dart';

import 'package:transact/utils/bottomButton.dart';
import 'package:transact/utils/grouped_orient.dart';
import 'package:transact/utils/radioButtonGroup.dart';

import 'package:transact/utils/utils.dart';

class SellerCashier extends StatefulWidget {
  @override
  _SellerCashierState createState() => _SellerCashierState();
}

class _SellerCashierState extends State<SellerCashier> {
  bool store = false;
  bool card = false;
  bool delivery = false;
  bool willDeliver = false;

  @override
  Widget build(BuildContext context) {
       return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          decoration: BoxDecoration(),
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: BottomButton(
            name: "PROCEED",
            ontap: () {
            //  AppRoutes.push(context, SellerDashBoard());
            },
          ),
        ),
        backgroundColor: Color(0xffF5F7FA),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    _headerText(),
                    _card1(),
                    _card2(),
                    card == true
                        ? store == true ? _store() : _store()
                        : Container(),
                    _card3(),
                    delivery == true ? _delivery() : Container(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
    Widget _delivery() {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: HexColor("#9D9D9D")),
            borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.only(bottom: 8),
        width: MediaQuery.of(context).size.width / 1.2,
        child: Column(
          children: <Widget>[
            willDeliver == false
                ? RadioButtonGroup(
                    orientation: GroupedButtonsOrientation.VERTICAL,
                    labelStyle: TextStyle(),
                    activeColor: Colors.black,
                    labels: <String>[
                      "Buyer will collect it from the store",
                      "Seller send it through third party courier",
                    ],
                    onSelected: (String selected) {
                      print("$selected");
                    })
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: Text("Seller Will deliver the product or service")),
          ],
        ));
  }
  Widget _store() {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: HexColor("#9D9D9D")),
            borderRadius: BorderRadius.circular(6)),
        margin: EdgeInsets.only(bottom: 8),
        width: MediaQuery.of(context).size.width / 1.2,
        child: Column(
          children: <Widget>[
            Text("Fill the store details", textAlign: TextAlign.center),
            Container(
                margin: EdgeInsets.only(top: store == true ? 15 : 5),
                child: _textField('images/cart5.png', 'Store Name', 2)),
            store == true
                ? Column(
                    children: <Widget>[
                      _textField('images/mapmark.png', 'Store Address', 2),
                      _textField('images/phone.png', 'Phone Number', 2),
                      _textField('images/email.png', 'Email', 2),
                      _textField('images/work.png', 'Add ABN', 2),
                      Container(
                        height: 10,
                      )
                    ],
                  )
                : Container(
                    height: 20,
                  )
          ],
        ));
  }
    Widget _textField(String image, String label, id) {
    return Container(
      margin: id == 1
          ? EdgeInsets.symmetric(vertical: 6)
          : EdgeInsets.symmetric(vertical: 2),
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        decoration: InputDecoration(
            filled: true,
            fillColor: HexColor("#FFFFFF"),
            labelText: "$label",
            labelStyle: TextStyle(fontSize: 14, color: Colors.black54),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: HexColor("#707070"))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 1, color: HexColor("#707070"))),
            prefixIcon: Container(
              padding: EdgeInsets.all(12),
              child: Image(
                image: AssetImage("$image"),
              ),
            )),
      ),
    );
  }
   Widget _headerText() {
    return Container(
      margin: EdgeInsets.all(20),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: <TextSpan>[
          TextSpan(
              text: "SELLER STORE DETAILS\n",
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'antipastro',
                  color: HexColor("#3B444B"))),
          TextSpan(
              text: "Please provide your store detail. ",
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'antipastro',
                  color: HexColor("#3B444B")))
        ]),
      ),
    );
  }
   Widget _card1() {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      width: MediaQuery.of(context).size.width / 1.2,
      child: Column(children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: HexColor("#3B444B")),
              borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("What are you Selling:", style: TextStyle(fontSize: 16)),
              RadioButtonGroup(
                  orientation: GroupedButtonsOrientation.HORIZONTAL,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  activeColor: Colors.black,
                  labels: <String>[
                    "PRODUCT",
                    "SERVICE",
                  ],
                  onSelected: (String selected) => print(selected)),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _card2() {
    return Container(
        margin: EdgeInsets.only(bottom: 8),
        width: MediaQuery.of(context).size.width / 1.2,
        child: Column(children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: HexColor("#9D9D9D")),
                borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Do you have a physical store?",
                    style: TextStyle(fontSize: 16)),
                RadioButtonGroup(
                    orientation: GroupedButtonsOrientation.HORIZONTAL,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    activeColor: Colors.black,
                    labels: <String>[
                      "Yes",
                      "No",
                    ],
                    onSelected: (String selected) {
                      selected == "Yes"
                          ? setState(() {
                              store = true;
                              card = true;
                            })
                          : setState(() {
                              store = false;
                              card = true;
                            });
                    }),
              ],
            ),
          ),
        ]));
  }

  Widget _card3() {
    return Container(
        margin: EdgeInsets.only(bottom: 8),
        width: MediaQuery.of(context).size.width / 1.2,
        child: Column(children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: HexColor("#9D9D9D")),
                borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Do you have you own delivery?",
                    style: TextStyle(fontSize: 16)),
                RadioButtonGroup(
                    orientation: GroupedButtonsOrientation.HORIZONTAL,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    activeColor: Colors.black,
                    labels: <String>[
                      "Yes",
                      "No",
                    ],
                    onSelected: (String selected) {
                      selected == "Yes"
                          ? setState(() {
                              delivery = true;
                              willDeliver = true;
                            })
                          : setState(() {
                              delivery = true;
                              willDeliver = false;
                            });
                    }),
              ],
            ),
          ),
        ]));
  }

}