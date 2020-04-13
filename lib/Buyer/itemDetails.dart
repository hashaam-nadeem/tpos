import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:transact/AppBar.dart';
import 'package:transact/Buyer/buyerAddress.dart';
import 'package:transact/Buyer/buyerCart.dart';
import 'package:transact/Buyer/buyerConversation.dart';
import 'package:transact/Buyer/storeDetails.dart';
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/utils/admin_chat.dart';
import 'package:transact/utils/bottomButton.dart';
import 'package:transact/utils/fonts.dart';
import 'package:transact/utils/routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:transact/utils/utils.dart';

class ItemDetailsBuyer extends StatefulWidget {
  @override
  _ItemDetailsBuyerState createState() => _ItemDetailsBuyerState();
}

class _ItemDetailsBuyerState extends State<ItemDetailsBuyer> {
  var counter = 1;
  var favorite;
  bool buyerCheck = false;
  int selected;
  ProgressDialog pr;

  List<bool> _selection = [true, false, false];
  List<String> colors = ["#FF0000", "#DBDBDB", "#001E95", "#000000"];

  List<String> images = [
    "images/item3.png",
    "images/item1.png",
    "images/item2.png",
  ];
  bool bottomSheet = false;
  addToCart() async {

if(User.userData.marketPlaceModel.result[User.userData.index].type==1)
{
  pr.show();
      double lineTotal = 0.0;
      lineTotal = counter *
          User.userData.marketPlaceModel.result[User.userData.index]
              .actualPrice;
      var header = {
        "Authorization": AuthenticationUser.getAuthentication(),
      };
      var body = {
        "Qty": "$counter",
        "Price":
            "${User.userData.marketPlaceModel.result[User.userData.index].actualPrice}",
        "LineTotal": "$lineTotal",
        "ProductId":
            "${User.userData.marketPlaceModel.result[User.userData.index].id}",
      };
      var response = await http.post(
        "${API.addCartLine}",
        headers: header,
        body: body,
      );
      var Json = json.decode(response.body);
      print(json.decode(response.body));
      if (response.statusCode == 200) {
        if (Json['Data']['WithError'] == false) {
          pr.dismiss();
          if (buyerCheck == true) {
            setState(() {
              User.userData.totalCart=counter *
          User.userData.marketPlaceModel.result[User.userData.index]
              .salePrice;
            });
            AppRoutes.push(context, BuyerAdress());
          } else {
            AppRoutes.push(context, BuyerCart());
          }

          Fluttertoast.showToast(
              msg: "${Json['Data']['ShortMessage']}",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
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
            msg: "Status Code: ${response.statusCode}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      }
}
else
{
  if (
        counter <
            User.userData.marketPlaceModel.result[User.userData.index]
                .minOrder) {
      Fluttertoast.showToast(
          msg: "not allowed less than min-Order",
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.blueGrey);
    } 
    else if(counter >
            User.userData.marketPlaceModel.result[User.userData.index].qty)
            {
              Fluttertoast.showToast(
          msg: "not more than quantity",
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.blueGrey);
            }
    else {
      pr.show();
      double lineTotal = 0.0;
      lineTotal = counter *
          User.userData.marketPlaceModel.result[User.userData.index]
              .actualPrice;
      var header = {
        "Authorization": AuthenticationUser.getAuthentication(),
      };
      var body = {
        "Qty": "$counter",
        "Price":
            "${User.userData.marketPlaceModel.result[User.userData.index].actualPrice}",
        "LineTotal": "$lineTotal",
        "ProductId":
            "${User.userData.marketPlaceModel.result[User.userData.index].id}",
      };
      var response = await http.post(
        "${API.addCartLine}",
        headers: header,
        body: body,
      );
      var Json = json.decode(response.body);
      print(json.decode(response.body));
      if (response.statusCode == 200) {
        if (Json['Data']['WithError'] == false) {
          pr.dismiss();
          if (buyerCheck == true) {
            setState(() {
              User.userData.totalCart=counter *
          User.userData.marketPlaceModel.result[User.userData.index]
              .salePrice;
            });
            AppRoutes.push(context, BuyerAdress());
          } else {
            AppRoutes.push(context, BuyerCart());
          }

          Fluttertoast.showToast(
              msg: "${Json['Data']['ShortMessage']}",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
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
            msg: "Status Code: ${response.statusCode}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      }
    }
}
    
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
      message: 'Loading...',
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
      bottomSheet: bottomSheet == true ? _bottomSheet() : null,
      backgroundColor: HexColor("#F5F7FA"),
      bottomNavigationBar:
          bottomSheet == true ? null : _itemDetailsBottomButton(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomeAppBar(
          homepage: false,
          title: "Details",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            User.userData.marketPlaceModel.result[User.userData.index]
                        .imgList !=
                    null
                ? _itemPhotos()
                : User.userData.marketPlaceModel.result[User.userData.index]
                            .imagePath !=
                        null
                    ? Image.network(
                        "${API.API_URL}${User.userData.marketPlaceModel.result[User.userData.index].imagePath}",
                        height: 200,
                        width: 200,
                      )
                    : Container(
                        child: Image(
                          height: 200,
                          width: 200,
                          image: AssetImage("images/item3.png"),
                        ),
                      ),
            _itemName(),
            _allDetails(),
            //_deliveryDetails(),
            //_shopName(),
            // Expanded(
            //   flex: 1,
            //   child: Container(
            //     width: MediaQuery.of(context).size.width,
            //     height: 50,
            //     child: _itemDetailsBottomButton()
            //   )
            //   ,
            // ),
          ],
        ),
      ),
    ));
  }

  Widget _itemPhotos() {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      child: Scrollbar(
        child: ListView.builder(
          itemCount: User.userData.marketPlaceModel.result[User.userData.index]
                      .imgList !=
                  null
              ? User.userData.marketPlaceModel.result[User.userData.index]
                  .imgList.length
              : 0,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Image.network(
                "${API.API_URL}${User.userData.marketPlaceModel.result[User.userData.index].imgList[index].url}");

            // Container(
            //   child: Image(
            //     height: 200,
            //     width: 200,
            //     image: AssetImage("${images[index]}"),
            //   ),
            // );
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
         User.userData.marketPlaceModel.result[User.userData.index].withDiscount==true?
            
            Align(
                alignment: Alignment.topRight,
                child: 
                Container(
                    height: 20,
                    width: 35,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/discountTag.png"),
                      ),
                    ),
                    child: Center(
                      child: User.userData.marketPlaceModel
                                  .result[User.userData.index].isDiscountPercentage ==
                              true
                          ? Text(
                              "-${User.userData.marketPlaceModel.result[User.userData.index].totalDiscount}%",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 8, color: Colors.white),
                            )
                          : Text(
                              "-${User.userData.marketPlaceModel.result[User.userData.index].totalDiscount}\$",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 8, color: Colors.white),
                            ),
                    )))
          :Text(""),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 0.0, bottom: 10, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${User.userData.marketPlaceModel.result[User.userData.index].name}",
                  style: TextStyle(fontSize: 18, height: 2),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "\$${User.userData.marketPlaceModel.result[User.userData.index].actualPrice}",
                      style: TextStyle(
                          decoration: User
                                      .userData
                                      .marketPlaceModel
                                      .result[User.userData.index]
                                      .withDiscount ==
                                  true
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: HexColor("#707070"),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'CaviarDreams'),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    User.userData.marketPlaceModel.result[User.userData.index]
                                .withDiscount ==
                            true
                        ? Text(
                            "\$${User.userData.marketPlaceModel.result[User.userData.index].salePrice}",
                            style: TextStyle(
                                color: HexColor("#515C6F"),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'CaviarDreams'),
                          )
                        : Text(
                            "",
                            style: TextStyle(
                                color: HexColor("#515C6F"),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'CaviarDreams'),
                          ),
                  ],
                ),
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

                          // Row(
                          //   children: <Widget>[
                          //     _fiveStar(),
                          //     Text(
                          //       "(10)",
                          //       style: TextStyle(fontSize: 10),
                          //     )
                          //   ],
                          // )
                        ],
                      ),
                    ],
                  ),
                ),
                // Expanded(
                //   flex: 2,
                //   child: Text(
                //     "View All",
                //     style: blackbold.copyWith(
                //       decoration: TextDecoration.underline,
                //     ),
                //   ),
                // )
              ]),
          Container(
            width: MediaQuery.of(context).size.width,
            height: User.userData.marketPlaceModel.result[User.userData.index]
                        .feedback !=
                    null
                ? MediaQuery.of(context).size.height * .25
                : MediaQuery.of(context).size.height * .02,
            child: ListView.builder(
              itemCount: User.userData.marketPlaceModel
                          .result[User.userData.index].feedback !=
                      null
                  ? User.userData.marketPlaceModel.result[User.userData.index]
                      .feedback.length
                  : 0,
              itemBuilder: (BuildContext context, int index) {
                return _feedbackTile(index);
              },
            ),
          ),
          // Container(
          //   child: Column(
          //     children: <Widget>[

          //       _feedbackTile(),
          //       _feedbackTile(),
          //       _feedbackTile(),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _feedbackTile(int index) {
    return Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
        child: Row(
          children: <Widget>[
            // Container(
            //   margin: EdgeInsets.only(right: 10),
            //   child: CircleAvatar(
            //     backgroundImage: AssetImage("images/photo1.png"),
            //   ),
            // ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "${User.userData.marketPlaceModel.result[User.userData.index].feedback[index].name}",
                      style: blackbold,
                    ),
                    // _fiveStar(),
                    _fiveStar(User.userData.marketPlaceModel
                        .result[User.userData.index].feedback[index].rate),

                    Text(
                      "    ("
                      "${User.userData.marketPlaceModel.result[User.userData.index].feedback[index].rate}"
                      ")",
                      style: blackbold.copyWith(fontSize: 10),
                    )
                  ],
                ),
                Text(
                    "${User.userData.marketPlaceModel.result[User.userData.index].feedback[index].feedBack}"),
                // Container(
                //     margin: EdgeInsets.only(top: 15),
                //     child: RichText(
                //       text: TextSpan(children: [
                //         TextSpan(
                //           text: "34 ",
                //           style: TextStyle(
                //               decoration: TextDecoration.underline,
                //               color: Colors.black),
                //         ),
                //         TextSpan(
                //           text: "Reply",
                //           style: TextStyle(
                //               decoration: TextDecoration.underline,
                //               color: Colors.blue),
                //         )
                //       ]),
                //     ))
              ],
            ),
          ],
        ));
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
              // Expanded(
              //   child: RichText(
              //     text: TextSpan(children: [
              //       TextSpan(
              //           text: "Capacity: ",
              //           style: blackbold.copyWith(fontSize: 13)),
              //       TextSpan(
              //           text: " 256 gb",
              //           style: blackbold.copyWith(
              //             fontSize: 13,
              //           ))
              //     ]),
              //   ),
              // ),
            ],
          ),
          Container(
            margin: EdgeInsets.all(15),
            child: Text(
                "${User.userData.marketPlaceModel.result[User.userData.index].specification}"),
          ),
          // _descriptionDetails(),
          // _descriptionDetails(),
          // _descriptionDetails(),
          // _descriptionDetails(),
          // _descriptionDetails(),
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
          Text(
              "${User.userData.marketPlaceModel.result[User.userData.index].description}"),
          // _descriptionDetails(),
          // _descriptionDetails(),
          // _descriptionDetails(),
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

  Widget _itemDetailsBottomButton() {
    return Container(
      height: MediaQuery.of(context).size.height * .08,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  User.userData.userStoreId = User.userData.marketPlaceModel
                      .result[User.userData.index].userId;
                });
                AppRoutes.replace(context, StoreDetails());
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Image.asset("images/store.png"),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                // AppRoutes.push(context, BuyerConversation());
                if (User.userData.marketPlaceModel.result[User.userData.index]
                        .userId ==
                    User.userData.userResult.id) {
                  Fluttertoast.showToast(
                      msg: "don't allow to chat with yourself.",
                      textColor: Colors.white,
                      backgroundColor: Colors.blueGrey);
                } else {
                  AppRoutes.push(
                      context,
                      AdminChat(
                        name: User.userData.marketPlaceModel
                            .result[User.userData.index].name,
                        peerid: User.userData.marketPlaceModel
                            .result[User.userData.index].userId,
                        pic: User.userData.marketPlaceModel
                            .result[User.userData.index].imagePath,
                      ));
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Image.asset("images/chat.png"),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  buyerCheck = true;
                  bottomSheet = true;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 4),
                child: BottomButton(
                  name: "Buy Now",
                  customColor: true,
                  color: HexColor("#FFB618"),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 4),
              child: BottomButton(
                name: "Add to cart",
                color: HexColor("#FF6D2B"),
                customColor: true,
                ontap: () {
                  // setState(() {
                  //   User.userData.count=counter;

                  setState(() {
                    buyerCheck = false;
                    //buyerCheck=true;
                    bottomSheet = true;
                  });
                  // });
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _bottomSheet() {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 15, right: 15),
      height: MediaQuery.of(context).size.height * .55,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2,
            )
          ],
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(35), topLeft: Radius.circular(35))),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                bottomSheet = false;
              });
            },
            child: Container(
              height: 20,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(top: 10, right: 10),
              child: Image.asset("images/cross.png"),
            ),
          ),
          _product(),
          //_divider(),
          //_colorFamily(),
          _divider(),
          _quantity(),
          Container(
            //margin: EdgeInsets.only(left: 20, right: 20, top: 70, bottom: 0.0),
            child: buyerCheck == true
                ? BottomButton(
                    name: "Buy",
                    customColor: true,
                    color: HexColor("#FF6D2B"),
                    ontap: () {
                      print(User.userData.marketPlaceModel
                          .result[User.userData.index].qty);
                      print(User.userData.marketPlaceModel
                          .result[User.userData.index].minOrder);
                          print(counter);
                      addToCart();
                    },
                  )
                : BottomButton(
                    name: "Add to cart",
                    customColor: true,
                    color: HexColor("#FF6D2B"),
                    ontap: () {
                      print(User.userData.marketPlaceModel
                          .result[User.userData.index].qty);
                      print(User.userData.marketPlaceModel
                          .result[User.userData.index].minOrder);
                          print(counter);
                      addToCart();
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _fiveStar(var rat) {
    return Container(
        // margin: EdgeInsets.only(
        //   top: id == 1 ? 10 : 0.0,
        //   bottom: 10,
        // ),
        child: RatingBar(
      initialRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: rat,
      itemSize: 20,
      glow: true,
      unratedColor: Colors.amber,
      //itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        print(rating);
      },
    )
        // SmoothStarRating(
        //   //rating: rat.todouble(),
        //   //rating:rat,
        //   size: 14,
        //   filledIconData: Icons.star,
        //   halfFilledIconData: Icons.star_half,
        //   defaultIconData: Icons.star_border,
        //   color: Colors.yellow[600],
        //   borderColor: Colors.yellow[600],
        //   starCount: rat,
        //   //allowHalfRating: false,
        //   spacing: 0.2,
        //   onRatingChanged: (value) {
        //     setState(() {
        //       //_productRating = value;
        //     });
        //     //print(_productRating);
        //   },
        // )
        );
  }

  Widget _deliveryDetails() {
    return Container(
      color: Colors.white,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      padding: EdgeInsets.only(top: 5.0, bottom: 5, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Delivery Details",
            style: TextStyle(fontSize: 22, height: 2),
          ),
          Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit,"
              " sed do eiusmod tempor incididunt ut"
              " labore et dolore magna aliqua. ")
        ],
      ),
    );
  }

  Widget _shopName() {
    return Container(
      color: Colors.white,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.only(top: 5.0, bottom: 5, left: 20, right: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(
              "Shop Name",
              style: TextStyle(fontSize: 20, height: 2),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0.0),
              child: BottomButton(
                name: "Visit Here",
                color: HexColor("#FF6D2B"),
                customColor: true,
                ontap: () {
                  print("Shop URL");
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////////////////////////////

  Widget _colorFamily() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Color Family",
            style: TextStyle(fontSize: 20, height: 3),
          ),
          Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return _colors(colors[index], index);
                },
              )),
        ],
      ),
    );
  }

  Widget _quantity() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Quantity",
            style: TextStyle(fontSize: 20, height: 3),
          ),
          _counter()
        ],
      ),
    );
  }

  Widget _counter() {
    return Container(
      height: 38,
      width: MediaQuery.of(context).size.width * .33,
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
                counter >= 2 ? counter-- : null;
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
                counter++;
              });
            },
            child: Container(height: 30, child: Icon(Icons.add)),
          ),
        ],
      ),
    );
  }

  Widget _colors(String color, int id) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = id;
        });
      },
      child: Container(
        height: selected == id ? 50 : 40,
        width: selected == id ? 50 : 40,
        margin: EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
            border: selected == id
                ? Border.all(color: Colors.white60, width: 2)
                : Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(30),
            color: HexColor("$color")),
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: double.infinity,
      height: 1,
      color: Colors.grey,
    );
  }

  Widget _product() {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            height: 70,
            width: 70,
            child: Image.network(
                "${API.API_URL}${User.userData.marketPlaceModel.result[User.userData.index].imagePath}"),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${User.userData.marketPlaceModel.result[User.userData.index].name}",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),

              Text(
                "\$${User.userData.marketPlaceModel.result[User.userData.index].salePrice}",
                textAlign: TextAlign.left,
                style: TextStyle(
                    height: 1.4, fontSize: 14, color: HexColor("#515C6F")),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
