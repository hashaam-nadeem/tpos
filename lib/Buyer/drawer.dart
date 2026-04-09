import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:transact/Buyer/buyerAccount.dart';
import 'package:transact/Buyer/buyerConversation.dart';
import 'package:transact/Buyer/buyerHome.dart';
import 'package:transact/Buyer/buyerOrder.dart';
import 'package:transact/Buyer/buyerSettings.dart';
import 'package:transact/Buyer/filterlocation.dart';
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Supplier/contactUs.dart';
import 'package:transact/Supplier/conversation.dart';
import 'package:transact/loginSignUp/loginSignUp.dart';
import 'package:transact/utils/PaymentMethod.dart';
import 'package:transact/utils/bottomButton.dart';
import 'package:transact/utils/fonts.dart';
import 'package:transact/utils/routes.dart';
import 'package:transact/utils/utils.dart';

class BuyerDrawer extends StatefulWidget {
  bool filter;
  BuyerDrawer({this.filter});
  @override
  _BuyerDrawerState createState() => _BuyerDrawerState();
}

class _BuyerDrawerState extends State<BuyerDrawer> {
  bool physical = false;
  bool virtual = false,all=false,location=false;
  double radius=0.0;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 3,
      child: User.userData.filter == true
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 25),
                    // child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: <Widget>[
                    //     Text(
                    //       "Refine Results",
                    //       style: catagoryFont.copyWith(
                    //         color: HexColor("#515C6F"),
                    //       ),
                    //     ),
                    //     GestureDetector(
                    //       onTap: () {
                    //         print("clear");
                    //       },
                    //       child: Container(
                    //         height: 20,
                    //         width: 40,
                    //         child: Text(
                    //           "Clear",
                    //           style: catagoryFont.copyWith(
                    //             color: HexColor("#FF6969"),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: _filter(),
                ),
                Expanded(
                  flex: 1,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: BottomButton(
                          name: "APPLY FILTER",
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if(all==false && virtual==false && location==false)
                          {
                            Fluttertoast.showToast(
                                msg: "please select filter",
                                textColor: Colors.white,
                                backgroundColor: Colors.blueGrey);
                          }
                          else if(all==true)
                          {
                            setState(() {
                              User.userData.selectedFilter=0;
                            });
                             AppRoutes.replace(context, BuyerHome());
                          print("call api");
                          }
                          else if(location==true)
                          {
                            if(User.userData.lat==0.0 || radius==0.0)
                            {
                              Fluttertoast.showToast(
                                msg: "please select location and radius",
                                textColor: Colors.white,
                                backgroundColor: Colors.blueGrey);
                            }
                            else{
                              setState(() {
                                User.userData.radius=radius;
                                User.userData.location=true;
                              });
                              AppRoutes.replace(context, BuyerHome());
                              print("call api");
                            }
                          }
                          else
                          {
                            setState(() {
                              User.userData.selectedFilter=1;
                            });
                             AppRoutes.replace(context, BuyerHome());
                            print("call api");
                          }
                          // if (physical == false && virtual == false && radius==0.0) {
                          //   Fluttertoast.showToast(
                          //       msg: "please select filter",
                          //       textColor: Colors.white,
                          //       backgroundColor: Colors.blueGrey);
                          //   setState(() {
                          //     setState(() {
                          //       widget.filter = false;
                          //       //User.userData.selectedFilter = 0;
                          //     });
                          //   });
                          // } 
                          // else if(physical==false && virtual==false && radius!=0.0 )
                          // {
                          //   if(User.userData.selectedLong==0.0)
                          //   {
                          //     Fluttertoast.showToast(
                          //       msg: "please select location",
                          //       textColor: Colors.white,
                          //       backgroundColor: Colors.blueGrey);
                          //   }
                          //   else
                          //   {
                          //     setState(() {
                          //       widget.filter=false;
                          //       User.userData.radius=radius;
                          //       User.userData.selectedFilter=5;
                          //   });
                          //   AppRoutes.replace(context, BuyerHome());
                          //   }
                          //                             }
                          // else {
                          //   if (physical == true) {
                          //     setState(() {
                          //       widget.filter = false;
                          //       User.userData.selectedFilter = 0;
                          //     });
                          //     AppRoutes.replace(context, BuyerHome());
                          //   } else {
                          //     setState(() {
                          //       widget.filter = false;
                          //       User.userData.selectedFilter = 1;
                          //     });
                          //     AppRoutes.replace(context, BuyerHome());
                          //   }
                          // }

                          // print("object");
                          // Navigator.pop(context);
                        },
                        child: Container(
                          margin:
                              EdgeInsets.only(left: 30, right: 30, bottom: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            // color: Colors.yellow,
                          ),
                          alignment: Alignment.topRight,
                          padding: EdgeInsets.all(8),
                          child: Image(
                              color: Colors.white,
                              image: AssetImage("images/forward_icon.png")),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Center(
                  child: Container(
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
                Center(
                  child: Text(
                    "${User.userData.userResult.fullname}",
                    style: TextStyle(
                      color: HexColor("#343434"),
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        _buildRow("images/home.png", "Home"),
                        _buildRow("images/cart.png", "My Orders"),
                        _buildRow(
                          "images/conversation.png",
                          "Conversation",
                        ),
                        _buildRow("images/card.png", "Payment Method"),
                        _buildRow("images/user2.png", "My Account"),
                        _buildRow("images/settings.png", "Settings"),
                        _buildRow("images/contact-us.png", "Contact Us"),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
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
          title == "Home"
              ? Navigator.pop(context)
              : title == "Conversation"
                  ? AppRoutes.push(context, Conversation())
                  : title == "Payment Method"
                      ? AppRoutes.push(context, PaymentMethod())
                      : title == "My Account"
                          ? AppRoutes.push(context, BuyerAccount())
                          : title == "Settings"
                              ? AppRoutes.push(context, BuyerSettings())
                              : title == "Contact Us"
                                  ? AppRoutes.push(context, ContactUs())
                                  : title == "My Orders"
                                      ? AppRoutes.push(context, BuyerOrder())
                                      : null;
        },
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 17),
            //  padding: const EdgeInsets.symmetric(vertical: 5.0),
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

  Widget _filter() {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 15),
      child: Column(
        children: <Widget>[
          Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        physical = true;
                        virtual = false;
                        User.userData.selectedLat=0.0;
                        User.userData.selectedLong=0.0;
                      });
                    },
                    child: Container(
                      // margin: EdgeInsets.only(top:10),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 1.5)),
                      child: Center(
                        child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: physical == true
                                  ? Colors.black
                                  : Colors.white,
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                    //height: 10,
                  ),
                  Text("Physical Store", style: TextStyle(color: Colors.black)),
                ],
              ),
              Row(
                children: <Widget>[
                  physical==true?
             Padding(
               padding: EdgeInsets.only(top:10),
               child:                 Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        physical = true;
                        virtual = false;
                        User.userData.selectedLat=0.0;
                        User.userData.selectedLong=0.0;
                        all=true;
                        location=false;
                      });
                    },
                    child: Container(
                      // margin: EdgeInsets.only(top:10),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 1.5)),
                      child: Center(
                        child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: all == true
                                  ? Colors.black
                                  : Colors.white,
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                    //height: 10,
                  ),
                  Text("All", style: TextStyle(color: Colors.black)),
                ],
              ),

             ) :
             Text(""),
             SizedBox(
               width: 30,
             ),
          physical==true?
       Padding(
         padding: EdgeInsets.only(top:10),
         child:           Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        physical = true;
                        virtual = false;
                        location=true;
                        all=false;
                        User.userData.selectedLat=0.0;
                        User.userData.selectedLong=0.0;
                      });
                    },
                    child: Container(
                      // margin: EdgeInsets.only(top:10),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 1.5)),
                      child: Center(
                        child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: location == true
                                  ? Colors.black
                                  : Colors.white,
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                    //height: 10,
                  ),
                  Text("Location", style: TextStyle(color: Colors.black)),
                ],
              ),
       
       )
       :Text(""),
                ],
              ),
       location==true?
          Row(
           // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: ()
                {
                  AppRoutes.push(context, FilterLocation());
                },
                child: Container(
                  margin: EdgeInsets.only(top:20),
                width: MediaQuery.of(context).size.width*.3,
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.all(Radius.circular(15))
                ),
                height: 50,
                child: Center(
                  child:
                  User.userData.selectedLat!=0.0?
                  Text("${User.userData.city}",style: TextStyle(
                    color: Colors.white,
                  ),)
                  :
                   Text("Select location",style: TextStyle(
                    color: Colors.white,
                  ),),
                ),
              ),
              ),
            ],
          )
       
       :Text(""),
           location==true?
           
           Row(
           // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                //width: 50,
                height: 40,
              ),
              Text("Radius",style: TextStyle(
                color: Colors.black
              ),)
            ],
          )
           :Text(""),
          location==true?Row(
           
           // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Container(
              width: MediaQuery.of(context).size.width*.5,
              height: MediaQuery.of(context).size.height*.08,
              child: TextField(
                keyboardType: TextInputType.number,
                onTap: ()
                {
                  setState(() {
                 physical=false;
                  virtual=false;
                  });
                },
                onChanged: (value)
                {
                  radius=double.parse(value);
                },
                decoration: InputDecoration(
                  hintText: "enter radius in km",
                  
                ),
              ),

            )],
          ):Text(""),
                     Padding(
               padding: EdgeInsets.only(top:20),
               child:  Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        physical = false;
                        virtual = true;
                        location=false;
                        User.userData.selectedLat=0.0;
                        User.userData.selectedLong=0.0;
                      });
                    },
                    child: Container(
                     // margin: EdgeInsets.only(top: 20),
                      // margin: EdgeInsets.only(top:10),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 1.5)),
                      child: Center(
                        child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  virtual == true ? Colors.black : Colors.white,
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                    //height: 10,
                  ),
                  Text("Virtual Store", style: TextStyle(color: Colors.black)),
                ],
              ),

              
             
             ),
       
          // _filterRow("Store", "Physical", true),
          // _filterRow("Store", "Virtual", true),
          // _filterRow("Color", "Men's Apparel", true),
          // _filterRow("Brand", "All Brands", true),
          // _filterRow("Size", "Large", true),
          // _filterRow("Price", "\$0-\$50", true),
        ],
      ),
    );
  }

  Widget _filterRow(String title, String value, bool trailing) {
    return InkWell(
      onTap: () {
        print("$title");
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 5, child: Text("$title", style: catagoryFont.copyWith())),
            title == "Color"
                ? Expanded(
                    flex: 2,
                    child: Container(
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: HexColor("#C5DC1B"),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: HexColor("#FF77E5"),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: HexColor("#77CBFF"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Expanded(
                    flex: 3,
                    child: Text(
                      "$value",
                      style: catagoryFont.copyWith(color: HexColor("#707070")),
                    ),
                  ),
            trailing == true
                ? Expanded(
                    child: Image(
                      height: 20,
                      width: 20,
                      image: AssetImage("images/forward_icon.png"),
                    ),
                  )
                : Expanded(
                    child: Container(),
                  ),
          ],
        ),
      ),
    );
  }
}
