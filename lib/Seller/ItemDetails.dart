import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:transact/AppBar.dart';
import 'package:transact/utils/fonts.dart';

import 'package:transact/utils/utils.dart';

class ItemDetailsSeller extends StatefulWidget {
  @override
  _ItemDetailsSellerState createState() => _ItemDetailsSellerState();
}

class _ItemDetailsSellerState extends State<ItemDetailsSeller> {
  List<bool> _selection = [true, false, false];

  List<String> images = [
    "images/item3.png",
    "images/item1.png",
    "images/item2.png",
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: HexColor("#F5F7FA"),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomeAppBar(
          homepage: false,
          title: "Details",
          suffix: true,
          suffixIcon: "images/more_vert.png",
        ),
      ),
      body: Column(
        children: <Widget>[
          _itemPhotos(),
          _itemName(),
          _allDetails(),
        ],
      ),
    ));
  }

  Widget _itemPhotos() {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      child: Scrollbar(
        child: ListView.builder(
          itemCount: 3,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
              child: Image(
                height: 200,
                width: 200,
                image: AssetImage("${images[index]}"),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _itemName() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Align(
              alignment: Alignment.topRight,
              child: Container(
                  height: 20,
                  width: 35,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/discountTag.png"),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "-10%",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ))),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 0.0, bottom: 10, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "iPhone X",
                  style: TextStyle(fontSize: 18, height: 2),
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        style:
                            blackbold.copyWith(decoration: TextDecoration.none),
                        text: "\$1000 "),
                    TextSpan(style: blackbold, text: " \$936")
                  ]),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _allDetails() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          _toggleButton(),
          _selection[0]
              ? _desciption()
              : _selection[1] ? _specification() : _feedback()
        ],
      ),
    );
  }

  Widget _feedback() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _heading("Feedback"),
                          Row(
                            children: <Widget>[
                              _fiveStar(),
                              Text(
                                "(10)",
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "View All",
                    style: blackbold.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ]),
          Container(
              height: MediaQuery.of(context).size.height / 3,
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    child: _feedbackTile(),
                  );
                },
              ))
        ],
      ),
    );
  }

  Widget _feedbackTile() {
    return Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10),
              child: CircleAvatar(
                backgroundImage: AssetImage("images/photo1.png"),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "John Doe",
                      style: blackbold,
                    ),
                    _fiveStar(),
                    Text(
                      "(4.0)",
                      style: blackbold.copyWith(fontSize: 10),
                    )
                  ],
                ),
                Text("Lorem ipsum dolor sit amet,"
                    "consectetur,"),
                Container(
                    margin: EdgeInsets.only(top: 15),
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "34 ",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.black),
                        ),
                        TextSpan(
                          text: "Reply",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue),
                        )
                      ]),
                    ))
              ],
            ),
          ],
        ));
  }

  Widget _fiveStar() {
    return Container(
        child: Row(children: <Widget>[
      Icon(
        Icons.star,
        size: 12,
        color: Colors.yellow,
      ),
      Icon(
        Icons.star,
        size: 12,
        color: Colors.yellow,
      ),
      Icon(
        Icons.star,
        size: 12,
        color: Colors.yellow,
      ),
      Icon(
        Icons.star,
        size: 12,
        color: Colors.yellow,
      ),
      Icon(
        Icons.star,
        size: 12,
        color: Colors.yellow,
      ),
    ]));
  }

  Widget _specification() {
    return Container(
    
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          _heading("Specification"),
          Row(
            children: <Widget>[
              Expanded(
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "Color: ",
                        style: blackbold.copyWith(fontSize: 13)),
                    TextSpan(
                        text: " RED",
                        style:
                            blackbold.copyWith(fontSize: 13, color: Colors.red))
                  ]),
                ),
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "Capacity: ",
                        style: blackbold.copyWith(fontSize: 13)),
                    TextSpan(
                        text: " 256 gb",
                        style: blackbold.copyWith(
                          fontSize: 13,
                        ))
                  ]),
                ),
              ),
            ],
          ),
          _descriptionDetails(),
          _descriptionDetails(),
          _descriptionDetails(),
          _descriptionDetails(),
          _descriptionDetails(),
        ],
      ),
    );
  }

  Widget _desciption() {
    return Container(
      height: MediaQuery.of(context).size.height / 2.5,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: <Widget>[
          _heading("Description"),
          Text("Lorem ipsum dolor sit amet,"
              "consectetur adipiscing elit, sed do eiusmod tempor incididunt ut "
              "labore et dolore magna aliqua. "),
          _descriptionDetails(),
          _descriptionDetails(),
          _descriptionDetails(),
        ],
      ),
    );
  }

  Widget _heading(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text("$text", style: blackbold.copyWith(fontSize: 18)),
    );
  }

  Widget _descriptionDetails() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
            height: 8,
            width: 8,
            color: Colors.black,
          ),
          Flexible(
            child: Container(
              child: Text("Lorem ipsum dolor sit amet,"
                  "consectetur adipiscing elit, sed do eiusmod tempor incididunt ut "
                  "labore et dolore magna aliqua. "),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleButton() {
    return Container(
      margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: HexColor("#D2D2D2")),
          color: HexColor("#F5F5F5"),
          borderRadius: BorderRadius.circular(30)),
      child: ToggleButtons(
        borderRadius: BorderRadius.circular(30),
        fillColor: HexColor("#F5F5F5"),
        isSelected: _selection,
        onPressed: (int index) {
          setState(() {
            for (int buttonIndex = 0;
                buttonIndex < _selection.length;
                buttonIndex++) {
              if (buttonIndex == index) {
                _selection[buttonIndex] = true;
              } else {
                _selection[buttonIndex] = false;
              }
            }
          });
        },
        renderBorder: false,
        children: <Widget>[
          AnimatedContainer(
            duration: Duration(microseconds: 10),
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: _selection[0] == true
                    ? HexColor("#3B444B")
                    : Colors.transparent),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                '  Description  ',
                style: TextStyle(
                    fontSize: 15,
                    color: _selection[0] == true ? Colors.white : Colors.black),
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(microseconds: 10),
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: _selection[1] == true
                  ? HexColor("#3B444B")
                  : HexColor("#F5F5F5"),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                '  Specification  ',
                style: TextStyle(
                    fontSize: 15,
                    color: _selection[1] == true ? Colors.white : Colors.black),
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(microseconds: 10),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: _selection[2] == true
                    ? HexColor('#3B444B')
                    : HexColor("#F5F5F5")),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Feed back',
                style: TextStyle(
                    fontSize: 15,
                    color: _selection[2] == true ? Colors.white : Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
