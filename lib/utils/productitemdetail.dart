import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:transact/AppBar.dart';
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/utils/fonts.dart';

import 'package:transact/utils/utils.dart';

class productItemDetails extends StatefulWidget {
  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<productItemDetails> {
  List<bool> _selection = [true, false, false];

  List<String> images = [
    "images/item3.png",
    "images/item1.png",
    "images/item2.png",
  ];

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    //print(User.userData.dashBoardResult.result[User.userData.index].description); 
  }
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
          //suffix: true,
          //suffixIcon: "images/more_vert.png",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            User.userData.productSearchModel.result[User.userData.index].imgList!=null?
             _itemPhotos()
            :
             User.userData.productSearchModel.result[User.userData.index].imagePath!=null?
             Image.network("${API.API_URL}${User.userData.productSearchModel.result[User.userData.index].imagePath}"
             ,
              height: 200,
                width: 200,
             )
             :Container(
              child: Image(
                height: 200,
                width: 200,
                image: AssetImage("images/item3.png"),
              ),
            ),
            _itemName(),
            _allDetails(),
          ],
        ),
      ),
    ));
  }

  Widget _itemPhotos() {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      width: double.infinity,
      child: Scrollbar(
        child: ListView.builder(
          itemCount:  User.userData.productSearchModel.result[User.userData.index].imgList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Image.network("${API.API_URL}${User.userData.productSearchModel.result[User.userData.index].imgList[index].url}",
             // height: 200,
                //width: 150,
              );
            // return Container(
            //   height: 200,
            //     width: 200,
            //   child: 
              
              
              // Image(
                
              //   image: AssetImage("${images[index]}"),
              // ),
              
            
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
                    child: 
                    User.userData.productSearchModel.result[User.userData.index].isDiscountPercentage==true
                   ?
                      Text(
                        "-${User.userData.productSearchModel.result[User.userData.index].totalDiscount}%",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 8, color: Colors.white),
                      )
                      :
                      Text(
                        "-${User.userData.productSearchModel.result[User.userData.index].totalDiscount}\$",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 8, color: Colors.white),
                      ),
                  ))),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 0.0, bottom: 10, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${User.userData.productSearchModel.result[User.userData.index].name}",
                  style: TextStyle(fontSize: 18, height: 2),
                ),
                Row(
                  children: <Widget>[
                    Text(
                          "\$${User.userData.productSearchModel.result[User.userData.index].actualPrice}",
                          style: TextStyle(
                              decoration:User.userData.productSearchModel.result[User.userData.index].withDiscount==true? TextDecoration.lineThrough:TextDecoration.none,
                              color: HexColor("#707070"),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CaviarDreams'),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        User.userData.productSearchModel.result[User.userData.index].withDiscount==true?
                        Text(
                          "\$${ User.userData.productSearchModel.result[User.userData.index].salePrice}",
                          style: TextStyle(
                              color: HexColor("#515C6F"),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CaviarDreams'),
                        ):Text(
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
          //       Expanded(
          //         flex: 2,
          //         child: Text(
          //           "View All",
          //           style: blackbold.copyWith(
          //             decoration: TextDecoration.underline,
          //           ),
          //         ),
          //       )
          //     ]),
          // Container(
          //     height: MediaQuery.of(context).size.height / 3,
          //     child: ListView.builder(
          //       itemCount: 5,
          //       itemBuilder: (context, index) {
          //         return Container(
          //           child: _feedbackTile(),
          //         );
          //       },
          //     ))

         
        ],
      ),
       Container(
                 width: MediaQuery.of(context).size.width,
                 height:
                 User.userData.productSearchModel.result[User.userData.index].feedback!=null?
                 MediaQuery.of(context).size.height*.25:
                 MediaQuery.of(context).size.height*.02
                 ,
                 child: ListView.builder
                (
                  itemCount: User.userData.productSearchModel.result[User.userData.index].feedback!=null?
                  User.userData.productSearchModel.result[User.userData.index].feedback.length
                  :0,
                  itemBuilder: (BuildContext context,int index)
                {
                  return _feedbackTile(index);
                }
                ,),
               ),
      ]
      )
    );}
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
                      "${User.userData.productSearchModel.result[User.userData.index].feedback[index].name}",
                      style: blackbold,
                    ),
                   // _fiveStar(),
                    _fiveStar(User.userData.productSearchModel.result[User.userData.index].feedback[index].rate),
                    Text(
                      "    (""${User.userData.productSearchModel.result[User.userData.index].feedback[index].rate}"")",
                      style: blackbold.copyWith(fontSize: 10),
                    )
                  ],
                ),
                Text("${User.userData.productSearchModel.result[User.userData.index].feedback[index].feedBack}"
                    ),
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

  // Widget _feedbackTile() {
  //   return Container(
  //       margin: EdgeInsets.only(top: 5, bottom: 5),
  //       child: Row(
  //         children: <Widget>[
  //           Container(
  //             margin: EdgeInsets.only(right: 10),
  //             child: CircleAvatar(
  //               backgroundImage: AssetImage("images/photo1.png"),
  //             ),
  //           ),
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: <Widget>[
  //               Row(
  //                 children: <Widget>[
  //                   Text(
  //                     "John Doe",
  //                     style: blackbold,
  //                   ),
  //                   _fiveStar(),
  //                   Text(
  //                     "(4.0)",
  //                     style: blackbold.copyWith(fontSize: 10),
  //                   )
  //                 ],
  //               ),
  //               Text("Lorem ipsum dolor sit amet,"
  //                   "consectetur,"),
  //               Container(
  //                   margin: EdgeInsets.only(top: 15),
  //                   child: RichText(
  //                     text: TextSpan(children: [
  //                       TextSpan(
  //                         text: "34 ",
  //                         style: TextStyle(
  //                             decoration: TextDecoration.underline,
  //                             color: Colors.black),
  //                       ),
  //                       TextSpan(
  //                         text: "Reply",
  //                         style: TextStyle(
  //                             decoration: TextDecoration.underline,
  //                             color: Colors.blue),
  //                       )
  //                     ]),
  //                   ))
  //             ],
  //           ),
  //         ],
  //       ));
  // }

   Widget _fiveStar(var rat) {
    return 
    Container(
        // margin: EdgeInsets.only(
        //   top: id == 1 ? 10 : 0.0,
        //   bottom: 10,
        // ),
        child: 
        RatingBar(
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
            child: Text("${User.userData.productSearchModel.result[User.userData.index].specification}"),
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
          Text("${User.userData.productSearchModel.result[User.userData.index].description}"),
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
}
