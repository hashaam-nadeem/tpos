import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:transact/Model/UserModel.dart';
import 'dart:convert';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/Seller/sellerHome.dart';
import 'package:transact/Supplier/supplierDashBoard.dart';

import 'package:transact/utils/bottomButton.dart';

import 'package:transact/utils/grouped_orient.dart';
import 'package:transact/utils/locationPicker.dart';
import 'package:transact/utils/radioButtonGroup.dart';
import 'package:transact/utils/routes.dart';
import 'package:transact/utils/storedetailaddress.dart';
import 'package:transact/utils/utils.dart';

class SupplierDetails extends StatefulWidget {
  @override
  _SupplierDetails createState() => _SupplierDetails();
}

class _SupplierDetails extends State<SupplierDetails> {
  bool store = false;
  bool sellingTypeProduct = false,
      physicalstoreYes = false,
      physicalstoreNo = false,
      sellingTypeService = false;
  bool card = false;
  bool delivery = false;
  bool willDeliver = false;
  String ownDelivery = "No";
  String selling = "Product";
  String selling1 = "Service";
  ProgressDialog pr;
  final storeName = TextEditingController();
  // final storeAddress = TextEditingController();
  final phoneNo = TextEditingController();
  bool physicalStore = false;
  String physicalStoreSelected = "No";
  final email = TextEditingController();
  final addAbn = TextEditingController();
  bool productSelected = false;
  bool serviceSelected = false;
  bool buyerCollection = false;
  bool thirdParty = false;
  bool supplierDeliverProduct = false;


callapiFunc()async
{
  pr.show();
    var body = {
      "IsPhysicalStoreExist": "$physicalstoreYes",
      "SellingProductType": sellingTypeProduct==true && sellingTypeService==true?
      "2":sellingTypeProduct==true?"0":sellingTypeService==true?"1":"0",
      "Storename": "${storeName.text.trim()}",
      "Address": "${User.userData.addressLine}",
      "Phone": "${phoneNo.text.trim()}",
      "Email": "${email.text.trim()}",
      "Adn": "${addAbn.text.trim()}",
      "Lat":"${User.userData.lat}",
      "Long":"${User.userData.long}",
      "BuyerPickup":"$buyerCollection",
      "SellerDelivery":"$supplierDeliverProduct",
      "OnlineDelivery":"$thirdParty",


    };
    print(body);
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    print(header);
    var response = await http.post(
      "${API.UpdateElementory}",
      body: body,
      headers: header,
    );
    print(json.decode(response.body));
    var Json = json.decode(response.body);
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == false) {
        pr.dismiss();
        AppRoutes.push(context, SupplierDashBoard());
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
          msg: "Response Status Code: ${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
}
  updateElementoryProfile() async {
    if (sellingTypeProduct == false && sellingTypeService == false) {
      Fluttertoast.showToast(
          msg: "no Selling type selected",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    } 
    
    else if(physicalstoreNo==false && physicalstoreYes==false)
    {
       Fluttertoast.showToast(
          msg: "please select do you have physical store or not.",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
    else if (physicalstoreYes == true) {
      if (storeName.text.isEmpty ||
          phoneNo.text.isEmpty ||
          email.text.isEmpty ||
          addAbn.text.isEmpty) {
        Fluttertoast.showToast(
            msg: "Please enter the required fields.",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      } else 
      {
        if(buyerCollection==false && supplierDeliverProduct==false && thirdParty==false)
        {
          Fluttertoast.showToast(
              msg: "Please select options below",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
        }
        else
        {
          if (buyerCollection == true) {
        if (User.userData.addressLine == "") {
          Fluttertoast.showToast(
              msg: "Please select the Address",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
        } else {
          callapiFunc();
          print("call Api");
        }
      }  
      else {
          callapiFunc();
          print("call Api");
        }
        }
        
      }
      
    } else {
      if (storeName.text.isEmpty) {
        Fluttertoast.showToast(
            msg: "Please enter store name",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      } else 
      {
        if(buyerCollection==false && supplierDeliverProduct==false && thirdParty==false)
        {
           Fluttertoast.showToast(
              msg: "Please select the Options below",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
        }
       else
       {
          if (buyerCollection == true) {
        if (User.userData.addressLine == "") {
          Fluttertoast.showToast(
              msg: "Please select address",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
        }
        else{
          callapiFunc();
        }
      }
       else {
            callapiFunc();
          print("call api");
        }
       }
      }
      
      
    }

   
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
        bottomNavigationBar: Container(
          decoration: BoxDecoration(),
          // margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: BottomButton(
            name: "PROCEED",
            ontap: () {
              updateElementoryProfile();
            },
          ),
        ),
        backgroundColor: Color(0xffF5F7FA),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            // height: MediaQuery.of(context).size.height,
            // width: MediaQuery.of(context).size.width,
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

  Widget _headerText() {
    return Container(
      margin: EdgeInsets.all(20),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: <TextSpan>[
          TextSpan(
              text: "Supplier Store Details\n",
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'antipastro',
                  color: HexColor("#3B444B"))),
          TextSpan(
              text: "Please provide your store details. ",
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
              Text("What are you selling?", style: TextStyle(fontSize: 16)),
              SizedBox(
                //width: 10,
                height: 10,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          productSelected = !productSelected;
                          sellingTypeProduct = !sellingTypeProduct;
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
                                color: productSelected == true
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
                    Text("Product", style: TextStyle(color: Colors.black)),
                  ],
                ),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          serviceSelected = !serviceSelected;
                          sellingTypeService = !sellingTypeService;
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
                                color: serviceSelected == true
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
                    Text("Service", style: TextStyle(color: Colors.black)),
                  ],
                ),
              ]),
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
                    //picked: physicalStoreSelected,
                    labels: <String>[
                      "Yes",
                      "No",
                    ],
                    onSelected: (String selected) {
                      // setState(() {
                      //   hasPhysicalStore=0;
                      // });
                      selected == "Yes"
                          ? setState(() {
                              physicalstoreYes = true;
                              physicalstoreNo = false;
                              store = true;
                              card = true;
                              physicalStore = true;
                            })
                          : setState(() {
                              physicalstoreYes = false;
                              physicalstoreNo = true;
                              store = false;
                              card = true;
                              physicalStore = false;
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
                Text("Do you provide your own delivery?",
                    style: TextStyle(fontSize: 16)),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          buyerCollection = !buyerCollection;
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
                                color: buyerCollection == true
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
                    Text("Buyer will collect it from the store",
                        style: TextStyle(color: Colors.black)),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                buyerCollection == true
                    ? _addressLine('images/cart5.png')
                    : Text(""),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          thirdParty = !thirdParty;
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
                                color: thirdParty == true
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
                    Flexible(
                      child: Text(
                          "Supplier will send it through third party courier",
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          supplierDeliverProduct = !supplierDeliverProduct;
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
                                color: supplierDeliverProduct == true
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
                    Flexible(
                      child: Text(
                          "Supplier will deliver the product or service",
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]));
  }

  Widget _delivery() {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: HexColor("#9D9D9D")),
            borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.only(bottom: 8),
        width: MediaQuery.of(context).size.width * .82,
        child: Column(
          children: <Widget>[
            willDeliver == false
                ? RadioButtonGroup(
                    orientation: GroupedButtonsOrientation.VERTICAL,
                    labelStyle: TextStyle(fontSize: 10),
                    activeColor: Colors.black,
                    labels: <String>[
                      "Supplier will collect it from the store",
                      "Supplier will send it through third party courier",
                    ],
                    onSelected: (String selected) {
                      if (selected == "Buyer will collect it from the store") {
                        print("collect from store");
                        setState(() {
                          // deliverySetting = 1;
                        });
                      } else {
                        setState(() {
                          //  deliverySetting = 2;
                        });
                        print("Supplier sent it");
                      }
                      //print("$selected");
                    })
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child:
                        Text("Supplier will deliver the product or service")),
          ],
        ));
  }

  Widget _store() {
    return Container(
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: HexColor("#9D9D9D")),
            borderRadius: BorderRadius.circular(6)),
        margin: EdgeInsets.only(bottom: 8),
        width: MediaQuery.of(context).size.width / 1.2,
        child: Column(
          children: <Widget>[
            Text(
              "Fill the store details",
              textAlign: TextAlign.center,
            ),
            Container(
                margin: EdgeInsets.only(top: store == true ? 15 : 5),
                child:
                    _textField('images/cart5.png', 'Store Name', 2, storeName)),
            //_addressLine('images/cart5.png'),
            //  _textField('images/mapmark.png', 'Store Address', 2,
            //       storeAddress),
            store == true
                ? Column(
                    children: <Widget>[
                      // _addressLine('images/cart5.png'),
                      _textField(
                          'images/phone.png', 'Phone Number', 2, phoneNo),
                      _textField('images/email.png', 'Email', 2, email),
                      _textField('images/work.png', 'Add ABN', 2, addAbn),
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

  Widget _addressLine(
    String image,
  ) {
    return GestureDetector(
        onTap: () {
          AppRoutes.push(context, StoreDetailAddress());
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 2, horizontal: 18),
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              border: Border.all(color: HexColor("#707070"), width: 1),
              // color: HexColor("#707070"),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Center(
            child: Row(
              children: <Widget>[
                Image.asset(
                  "$image",
                  scale: 3,
                ),
                SizedBox(
                  width: 10,
                ),
                User.userData.addressLine == ""
                    ? Flexible(
                        child: Text(
                        "Store Address",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ))
                    : Flexible(
                        child: Text(
                        "${User.userData.addressLine}",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ))
              ],
            ),
          ),
        ));
  }

  Widget _textField(String image, String label, id, _controller) {
    return Container(
      margin: id == 1
          ? EdgeInsets.symmetric(vertical: 6)
          : EdgeInsets.symmetric(vertical: 2),
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        // onTap: ()
        // {
        //   if(_controller==storeAddress)
        //   {
        //     AppRoutes.push(context, StoreDetailAddress());
        //     setState(() {
        //       storeAddress.text=User.userData.addressLine;
        //     });
        //   }
        // },
        controller: _controller,
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
}

// import 'package:flutter/material.dart';
// import 'package:transact/Seller/sellerHome.dart';
// import 'package:transact/utils/bottomButton.dart';

// import 'package:transact/utils/grouped_orient.dart';
// import 'package:transact/utils/radioButtonGroup.dart';
// import 'package:transact/utils/routes.dart';
// import 'package:transact/utils/utils.dart';

// class SellerDetails extends StatefulWidget {
//   @override
//   _SellerDetailsState createState() => _SellerDetailsState();
// }

// class _SellerDetailsState extends State<SellerDetails> {
//   bool store = false;
//   bool card = false;
//   bool delivery = false;
//   bool willDeliver = false;

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         bottomNavigationBar: Container(
//           decoration: BoxDecoration(),
//           margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//           child: BottomButton(
//             name: "PROCEED",
//             ontap: () {
//               AppRoutes.push(context, SellerHome());
//             },
//           ),
//         ),
//         backgroundColor: Color(0xffF5F7FA),
//         body: SingleChildScrollView(
//           child: Container(
//             alignment: Alignment.center,
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             child: Column(
//               children: <Widget>[
//                 Column(
//                   children: <Widget>[
//                     _headerText(),
//                     _card1(),
//                     _card2(),
//                     card == true
//                         ? store == true ? _store() : _store()
//                         : Container(),
//                     _card3(),
//                     delivery == true ? _delivery() : Container(),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _headerText() {
//     return Container(
//       margin: EdgeInsets.all(20),
//       child: RichText(
//         textAlign: TextAlign.center,
//         text: TextSpan(children: <TextSpan>[
//           TextSpan(
//               text: "SELLER STORE DETAILS\n",
//               style: TextStyle(
//                   fontSize: 18,
//                   fontFamily: 'antipastro',
//                   color: HexColor("#3B444B"))),
//           TextSpan(
//               text: "Please provide your store detail. ",
//               style: TextStyle(
//                   fontSize: 16,
//                   fontFamily: 'antipastro',
//                   color: HexColor("#3B444B")))
//         ]),
//       ),
//     );
//   }

//   Widget _card1() {
//     return Container(
//       margin: EdgeInsets.only(bottom: 8),
//       width: MediaQuery.of(context).size.width / 1.2,
//       child: Column(children: <Widget>[
//         Container(
//           decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border.all(color: HexColor("#3B444B")),
//               borderRadius: BorderRadius.circular(10)),
//           padding: EdgeInsets.all(10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text("What are you Selling:", style: TextStyle(fontSize: 16)),
//               Row(children: [
//                 RadioButtonGroup(
//                     orientation: GroupedButtonsOrientation.HORIZONTAL,
//                     labelStyle: TextStyle(fontWeight: FontWeight.bold),
//                     activeColor: Colors.black,
//                     labels: <String>[
//                       "PRODUCT",
//                     ],
//                     onSelected: (String selected) => print(selected)),
//                 RadioButtonGroup(
//                     orientation: GroupedButtonsOrientation.HORIZONTAL,
//                     labelStyle: TextStyle(fontWeight: FontWeight.bold),
//                     activeColor: Colors.black,
//                     labels: <String>[
//                       "SERVICE",
//                     ],
//                     onSelected: (String selected) => print(selected)),
//               ]),
//             ],
//           ),
//         ),
//       ]),
//     );
//   }

//   Widget _card2() {
//     return Container(
//         margin: EdgeInsets.only(bottom: 8),
//         width: MediaQuery.of(context).size.width / 1.2,
//         child: Column(children: <Widget>[
//           Container(
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border.all(color: HexColor("#9D9D9D")),
//                 borderRadius: BorderRadius.circular(10)),
//             padding: EdgeInsets.all(10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text("Do you have a physical store?",
//                     style: TextStyle(fontSize: 16)),
//                 RadioButtonGroup(
//                     orientation: GroupedButtonsOrientation.HORIZONTAL,
//                     labelStyle: TextStyle(fontWeight: FontWeight.bold),
//                     activeColor: Colors.black,
//                     labels: <String>[
//                       "Yes",
//                       "No",
//                     ],
//                     onSelected: (String selected) {
//                       selected == "Yes"
//                           ? setState(() {
//                               store = true;
//                               card = true;
//                             })
//                           : setState(() {
//                               store = false;
//                               card = true;
//                             });
//                     }),
//               ],
//             ),
//           ),
//         ]));
//   }

//   Widget _card3() {
//     return Container(
//         margin: EdgeInsets.only(bottom: 8),
//         width: MediaQuery.of(context).size.width / 1.2,
//         child: Column(children: <Widget>[
//           Container(
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border.all(color: HexColor("#9D9D9D")),
//                 borderRadius: BorderRadius.circular(10)),
//             padding: EdgeInsets.all(10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text("Do you have you own delivery? 15km*",
//                     style: TextStyle(fontSize: 16)),
//                 RadioButtonGroup(
//                     orientation: GroupedButtonsOrientation.HORIZONTAL,
//                     labelStyle: TextStyle(fontWeight: FontWeight.bold),
//                     activeColor: Colors.black,
//                     labels: <String>[
//                       "Yes",
//                       "No",
//                     ],
//                     onSelected: (String selected) {
//                       selected == "Yes"
//                           ? setState(() {
//                               delivery = true;
//                               willDeliver = true;
//                             })
//                           : setState(() {
//                               delivery = true;
//                               willDeliver = false;
//                             });
//                     }),
//               ],
//             ),
//           ),
//         ]));
//   }

//   Widget _delivery() {
//     return Container(
//         decoration: BoxDecoration(
//             color: Colors.white,
//             border: Border.all(color: HexColor("#9D9D9D")),
//             borderRadius: BorderRadius.circular(10)),
//         margin: EdgeInsets.only(bottom: 8),
//         width: MediaQuery.of(context).size.width / 1.2,
//         child: Column(
//           children: <Widget>[
//             willDeliver == false
//                 ? RadioButtonGroup(
//                     orientation: GroupedButtonsOrientation.VERTICAL,
//                     labelStyle: TextStyle(),
//                     activeColor: Colors.black,
//                     labels: <String>[
//                       "Buyer will collect it from the store",
//                       "Seller send it through third party courier",
//                     ],
//                     onSelected: (String selected) {
//                       print("$selected");
//                     })
//                 : Container(
//                     padding: EdgeInsets.symmetric(vertical: 18),
//                     child: Text("Seller Will deliver the product or service")),
//           ],
//         ));
//   }

//   Widget _store() {
//     return Container(
//         decoration: BoxDecoration(
//             color: Colors.white,
//             border: Border.all(color: HexColor("#9D9D9D")),
//             borderRadius: BorderRadius.circular(6)),
//         margin: EdgeInsets.only(bottom: 8),
//         width: MediaQuery.of(context).size.width / 1.2,
//         child: Column(
//           children: <Widget>[
//             Text("Fill the store details", textAlign: TextAlign.center),
//             Container(
//                 margin: EdgeInsets.only(top: store == true ? 15 : 5),
//                 child: _textField('images/cart5.png', 'Store Name', 2)),
//             store == true
//                 ? Column(
//                     children: <Widget>[
//                       _textField('images/mapmark.png', 'Store Address', 2),
//                       _textField('images/phone.png', 'Phone Number', 2),
//                       _textField('images/email.png', 'Email', 2),
//                       _textField('images/work.png', 'Add ABN', 2),
//                       Container(
//                         height: 10,
//                       )
//                     ],
//                   )
//                 : Container(
//                     height: 20,
//                   )
//           ],
//         ));
//   }

//   Widget _textField(String image, String label, id) {
//     return Container(
//       margin: id == 1
//           ? EdgeInsets.symmetric(vertical: 6)
//           : EdgeInsets.symmetric(vertical: 2),
//       height: 40,
//       padding: EdgeInsets.symmetric(horizontal: 20),
//       child: TextFormField(
//         decoration: InputDecoration(
//             filled: true,
//             fillColor: HexColor("#FFFFFF"),
//             labelText: "$label",
//             labelStyle: TextStyle(fontSize: 14, color: Colors.black54),
//             border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(color: HexColor("#707070"))),
//             focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(width: 1, color: HexColor("#707070"))),
//             prefixIcon: Container(
//               padding: EdgeInsets.all(12),
//               child: Image(
//                 image: AssetImage("$image"),
//               ),
//             )),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geocoder/geocoder.dart';
// import 'package:progress_dialog/progress_dialog.dart';
// import 'package:transact/Buyer/storeDetails.dart';
// import 'package:transact/Model/apismodel.dart';
// import 'package:transact/Model/getauthentication.dart';

// import 'package:transact/Supplier/supplierDashBoard.dart';
// import 'package:transact/utils/bottomButton.dart';

// import 'package:transact/utils/grouped_orient.dart';
// import 'package:transact/utils/radioButtonGroup.dart';
// import 'package:transact/utils/routes.dart';
// import 'package:transact/utils/utils.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class SupplierDetails extends StatefulWidget {
//   @override
//   _SupplierDetailsState createState() => _SupplierDetailsState();
// }

// class _SupplierDetailsState extends State<SupplierDetails> {
//   bool store = false;
//   bool card = false;
//   bool delivery = false;
//   bool willDeliver = false;
//  String selling="Product";
//   String ownDelivery="No";
//  ProgressDialog pr;
// final storeName = TextEditingController();
//   final storeAddress = TextEditingController();
//   final phoneNo = TextEditingController();
//   bool physicalStore=false;
//   String physicalStoreSelected="No";
//   final email = TextEditingController();
//   final addAbn = TextEditingController();
//   int deliverySetting=0;

// updateElementoryProfile() async
// {
// pr.show();
// var body = {
//       "IsPhysicalStoreExist": "$physicalStore",
//       "DeliverySetting": "$deliverySetting",
//       "SellingProductType":  selling=="Product"?"0":"1",
//       "Storename": "${storeName.text.trim()}",
//       "Address": "${storeAddress.text.trim()}",
//       "Phone": "${phoneNo.text.trim()}",
//       "Email": "${email.text.trim()}",
//        "Adn": "${addAbn.text.trim()}",

//     };
//     print(body);
//     var header={
//       "Authorization": AuthenticationUser.getAuthentication(),
//     };
//     print(header);
//     var response = await http.post(
//       "${API.UpdateElementory}",
//       body: body,
//       headers: header,
//     );
//     print(json.decode(response.body));
//     var Json=json.decode(response.body);
//     if(response.statusCode==200)
//     {

//       if(Json['Data']['WithError']==false)
//       {
//         pr.dismiss();
//         AppRoutes.push(context, SupplierDashBoard());
//       }
//       else
//       {
//         pr.dismiss();
//         Fluttertoast.showToast(
//               msg: "${Json['Data']['ShortMessage']}",
//               textColor: Colors.white,
//               backgroundColor: Colors.blueGrey);
//       }

//     }
//     else
//     {
//       pr.dismiss();
//        Fluttertoast.showToast(
//               msg: "Response Status Code: ${response.statusCode}",
//               textColor: Colors.white,
//               backgroundColor: Colors.blueGrey);
//     }
// }
//   @override
//   Widget build(BuildContext context) {
//      pr = new ProgressDialog(context,type: ProgressDialogType.Normal);
//        pr.style(
//           message: 'Please wait...',
//           borderRadius: 10.0,
//           backgroundColor: Colors.white,
//           progressWidget: CircularProgressIndicator(),
//           elevation: 10.0,
//           insetAnimCurve: Curves.easeInOut,
//           progressTextStyle: TextStyle(
//               color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
//           messageTextStyle: TextStyle(
//               color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
//         );
//     return SafeArea(
//       child: Scaffold(
//         bottomNavigationBar: Container(
//           decoration: BoxDecoration(),
//          // margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//           child: BottomButton(
//             name: "PROCEED",
//             ontap: () {
//               print(physicalStore);
//               if(physicalStore==false)
//               {
//                 print(storeName.text.trim());
//                 if(storeName.text.isEmpty)
//                 {
//                   Fluttertoast.showToast(
//               msg: "Please enter Store Name",
//               textColor: Colors.white,
//               backgroundColor: Colors.blueGrey);
//                 }
//                 else
//                 {
//                   updateElementoryProfile();
//                 }
//               }
//               else if(storeName.text.isEmpty || storeAddress.text.isEmpty || email.text.isEmpty || addAbn.text.isEmpty ||phoneNo.text.isEmpty)
//               {
//                 Fluttertoast.showToast(
//               msg: "Please enter the Required Fields",
//               textColor: Colors.white,
//               backgroundColor: Colors.blueGrey);

//               }
//               else
//               {
//                 updateElementoryProfile();
//               }

//             },
//           ),
//         ),
//         backgroundColor: Color(0xffF5F7FA),
//         body: SingleChildScrollView(
//           child: Container(
//             alignment: Alignment.center,
//             // height: MediaQuery.of(context).size.height,
//             // width: MediaQuery.of(context).size.width,
//             child: Column(
//               children: <Widget>[
//                 Column(
//                   children: <Widget>[
//                     _headerText(),
//                     _card1(),
//                     _card2(),
//                     card == true
//                         ? store == true ? _store() : _store()
//                         : Container(),
//                     _card3(),
//                     delivery == true ? _delivery() : Container(),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _headerText() {
//     return Container(
//       margin: EdgeInsets.all(20),
//       child: RichText(
//         textAlign: TextAlign.center,
//         text: TextSpan(children: <TextSpan>[
//           TextSpan(
//               text: "Supplier Store Details\n",
//               style: TextStyle(
//                   fontSize: 18,
//                   fontFamily: 'antipastro',
//                   color: HexColor("#3B444B"))),
//           TextSpan(
//               text: "Please provide your store details. ",
//               style: TextStyle(
//                   fontSize: 16,
//                   fontFamily: 'antipastro',
//                   color: HexColor("#3B444B")))
//         ]),
//       ),
//     );
//   }

//   Widget _card1() {
//     return Container(
//       margin: EdgeInsets.only(bottom: 8),
//       width: MediaQuery.of(context).size.width / 1.2,
//       child: Column(children: <Widget>[
//         Container(
//           decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border.all(color: HexColor("#3B444B")),
//               borderRadius: BorderRadius.circular(10)),
//           padding: EdgeInsets.all(10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text("What are you selling?", style: TextStyle(fontSize: 16)),
//               Row(children: [
//                 RadioButtonGroup(
//                     orientation: GroupedButtonsOrientation.HORIZONTAL,
//                     labelStyle: TextStyle(fontWeight: FontWeight.bold),
//                     activeColor: Colors.black,
//                     picked: selling,
//                     labels: <String>[
//                       "Product",
//                       "Service"

//                     ],
//                     onSelected: (String selected) {

//                         setState(() {
//                          selling=selected;
//                         });
//                         // print(sellingProduct);
//                         //  print(sellingService);

//                       print(selected);
//                     },

//                     ),
//                 // RadioButtonGroup(
//                 //     orientation: GroupedButtonsOrientation.HORIZONTAL,
//                 //     labelStyle: TextStyle(fontWeight: FontWeight.bold),
//                 //     activeColor: Colors.black,
//                 //     labels: <String>[
//                 //       "SERVICE",
//                 //     ],
//                 //     onSelected: (String selected) => print(selected)),
//               ]),
//             ],
//           ),
//         ),
//       ]),
//     );
//   }

//   Widget _card2() {
//     return Container(
//         margin: EdgeInsets.only(bottom: 8),
//         width: MediaQuery.of(context).size.width / 1.2,
//         child: Column(children: <Widget>[
//           Container(
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border.all(color: HexColor("#9D9D9D")),
//                 borderRadius: BorderRadius.circular(10)),
//             padding: EdgeInsets.all(10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text("Do you have a physical store?",
//                     style: TextStyle(fontSize: 16)),
//                 RadioButtonGroup(
//                     orientation: GroupedButtonsOrientation.HORIZONTAL,
//                     labelStyle: TextStyle(fontWeight: FontWeight.bold),
//                     activeColor: Colors.black,
//                     //picked: physicalStoreSelected,
//                     labels: <String>[
//                       "Yes",
//                       "No",
//                     ],

//                     onSelected: (String selected) {
//                       selected == "Yes"
//                           ? setState(() {
//                               store = true;
//                               card = true;
//                               physicalStore=true;
//                             })
//                           : setState(() {
//                               store = false;
//                               card = true;
//                               physicalStore=false;
//                             });
//                     }),
//               ],
//             ),
//           ),
//         ]));
//   }

//   Widget _card3() {
//     return Container(
//         margin: EdgeInsets.only(bottom: 8),
//         width: MediaQuery.of(context).size.width / 1.2,
//         child: Column(children: <Widget>[
//           Container(
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border.all(color: HexColor("#9D9D9D")),
//                 borderRadius: BorderRadius.circular(10)),
//             padding: EdgeInsets.all(10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text("Do you provide your own delivery?",
//                     style: TextStyle(fontSize: 16)),
//                 RadioButtonGroup(
//                     orientation: GroupedButtonsOrientation.HORIZONTAL,
//                     labelStyle: TextStyle(fontWeight: FontWeight.bold),
//                     activeColor: Colors.black,
//                     //picked: ownDelivery,
//                     labels: <String>[
//                       "Yes",
//                       "No",
//                     ],
//                     onSelected: (String selected) {

//                       selected == "Yes"
//                           ? setState(() {
//                               delivery = true;
//                               willDeliver = true;
//                               deliverySetting=0;
//                             })
//                           : setState(() {
//                               delivery = true;
//                               willDeliver = false;
//                               deliverySetting=1;
//                             });

//                       // selected == "Yes"
//                       //     ? setState(() {
//                       //         delivery = true;

//                       //         willDeliver = true;
//                       //       })
//                       //     : setState(() {
//                       //         delivery = true;
//                       //         willDeliver = false;
//                       //       });
//                             print(delivery);
//                     }),
//               ],
//             ),
//           ),
//         ]));
//   }

//   Widget _delivery() {
//     return Container(
//         decoration: BoxDecoration(
//             color: Colors.white,
//             border: Border.all(color: HexColor("#9D9D9D")),
//             borderRadius: BorderRadius.circular(10)),
//         margin: EdgeInsets.only(bottom: 8),
//         width: MediaQuery.of(context).size.width*.82,
//         child: Column(
//           children: <Widget>[
//             willDeliver == false
//                 ? RadioButtonGroup(
//                     orientation: GroupedButtonsOrientation.VERTICAL,
//                     labelStyle: TextStyle(fontSize: 12),
//                     activeColor: Colors.black,
//                     labels: <String>[
//                       "Buyer will collect it from the store",
//                       "Seller will send it through third party courier",
//                     ],
//                     onSelected: (String selected) {
//                       if(selected=="Buyer will collect it from the store")
//                       {
//                         print("collect from store");
//                         setState(() {
//                           deliverySetting=1;
//                         });
//                       }
//                       else
//                       {
//                         setState(() {
//                           deliverySetting=2;
//                         });
//                         print("seller sent it");
//                       }
//                       //print("$selected");
//                     })
//                 : Container(
//                     padding: EdgeInsets.symmetric(vertical: 18),
//                     child: Text("Seller will deliver the product or service")),
//           ],
//         ));
//   }

//   Widget _store() {
//     return Container(
//         padding: EdgeInsets.only(top: 10),
//         decoration: BoxDecoration(
//             color: Colors.white,
//             border: Border.all(color: HexColor("#9D9D9D")),
//             borderRadius: BorderRadius.circular(6)),
//         margin: EdgeInsets.only(bottom: 8),
//         width: MediaQuery.of(context).size.width / 1.2,
//         child: Column(
//           children: <Widget>[
//             Text(
//               "Fill the store details",
//               textAlign: TextAlign.center,
//             ),
//             Container(
//                 margin: EdgeInsets.only(top: store == true ? 15 : 5),
//                 child: _textField('images/cart5.png', 'Store Name', 2,storeName)),
//             store == true
//                 ? Column(
//                     children: <Widget>[
//                       _textField('images/mapmark.png', 'Store Address', 2,storeAddress),
//                       _textField('images/phone.png', 'Phone Number', 2,phoneNo),
//                       _textField('images/email.png', 'Email', 2,email),
//                       _textField('images/work.png', 'Add ABN', 2,addAbn),
//                       Container(
//                         height: 10,
//                       )
//                     ],
//                   )
//                 : Container(
//                     height: 20,
//                   )
//           ],
//         ));
//   }

//   Widget _textField(String image, String label, id,_controller) {
//     return Container(
//       margin: id == 1
//           ? EdgeInsets.symmetric(vertical: 6)
//           : EdgeInsets.symmetric(vertical: 2),
//       height: 40,
//       padding: EdgeInsets.symmetric(horizontal: 20),
//       child: TextFormField(
//         controller: _controller,
//         decoration: InputDecoration(
//             filled: true,
//             fillColor: HexColor("#FFFFFF"),
//             labelText: "$label",
//             labelStyle: TextStyle(fontSize: 14, color: Colors.black54),
//             border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(color: HexColor("#707070"))),
//             focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(width: 1, color: HexColor("#707070"))),
//             prefixIcon: Container(
//               padding: EdgeInsets.all(12),
//               child: Image(
//                 image: AssetImage("$image"),
//               ),
//             )),
//       ),
//     );
//   }
// }
