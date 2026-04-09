import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:transact/AppBar.dart';
import 'package:transact/Buyer/checkOut.dart';
import 'package:transact/utils/bottomButton.dart';
import 'package:transact/utils/routes.dart';
import 'package:transact/utils/utils.dart';

class SellerCart extends StatefulWidget {
  @override
  _SellerCartState createState() => _SellerCartState();
}

class _SellerCartState extends State<SellerCart> {
  int counter = 1;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: HexColor("#F5F7FA"),
          bottomNavigationBar: _bottomBar(),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: CustomeAppBar(
              title: "My Cart",
              homepage: false,
            ),
          ),
          body: Container(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  child: _cartItem(),
                );
              },
            ),
          )),
    );
  }

  Widget _cartItem() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 5, left: 10, right: 10),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                child: Image.asset("images/item3.png"),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "Iphone X\n",
                          style: TextStyle(
                              fontSize: 15,
                              height: 2,
                              color: HexColor("#3B444B"),
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: "\$875",
                          style: TextStyle(
                              height: 1.5,
                              fontSize: 12,
                              color: HexColor("#3B444B"),
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: "   per piece",
                          style: TextStyle(
                              fontSize: 10,
                              color: HexColor("#939698"),
                              fontWeight: FontWeight.bold))
                    ]),
                  ),
                  _counter()
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text("\$924",
                  style: TextStyle(
                      fontSize: 15,
                      color: HexColor("#3B444B"),
                      fontWeight: FontWeight.bold)),
            )
          ],
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
                      text: "\$875",
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
                  AppRoutes.replace(context, CheckOut());
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _counter() {
    return Container(
      height: 38,
      width: MediaQuery.of(context).size.width * .31,
      padding: EdgeInsets.symmetric(horizontal: 5),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
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
            child: Container(height: 30, child: Icon(Icons.remove)),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 17),
              child: Text(
                "$counter",
                style: TextStyle(fontSize: 20),
              )),
          GestureDetector(
            onTap: () {
              setState(() {
                counter = counter + 1;
              });
            },
            child: Container(height: 30, child: Icon(Icons.add)),
          ),
        ],
      ),
    );
  }
}
