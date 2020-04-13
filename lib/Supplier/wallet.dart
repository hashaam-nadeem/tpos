


import 'package:flutter/material.dart';
import 'package:transact/AppBar.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/Supplier/walletDetail.dart';
import 'package:transact/utils/routes.dart';
import 'package:transact/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Wallet extends StatefulWidget {
  @override
  _Wallet createState() => _Wallet();
}

class _Wallet extends State<Wallet> {
  String _value = "Select Date";
  var style = TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: HexColor("#1C1C1C"));
  List<bool> _selection = [true, false];
  double sale = 0, received = 0, remaining = 0;

  getwallet() async {
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    print(header);
    var response = await http.get(
      "${API.walletapi}",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      setState(() {
        sale = Json['Data']['Result']['Sale'];
        received = Json['Data']['Result']['Received'];
        remaining = Json['Data']['Result']['Remaining'];
      });
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getwallet();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: HexColor("#F5F7FA"),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(120),
            child: CustomeAppBar(
              title: "Wallet",
              //child: _toggleButtons(),
            ),
          ),
          body: _body()),
    );
  }

  Widget _toggleButtons() {
    return Container(
      alignment: Alignment.center,
      height: 40,
      width: MediaQuery.of(context).size.width * .7,
      child: ToggleButtons(
        fillColor: Colors.white,
        borderColor: Colors.white,
        selectedBorderColor: Colors.white,
        borderWidth: 1.5,
        borderRadius: BorderRadius.circular(3),
        isSelected: _selection,
        children: <Widget>[
          Container(
              margin: EdgeInsets.symmetric(horizontal: 17),
              child: Text(
                "  Sales  ",
                style: TextStyle(
                  fontSize: 14,
                  color: _selection.elementAt(0) == true
                      ? Colors.black
                      : Colors.white,
                ),
                textAlign: TextAlign.center,
              )),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 17),
              child: Text(
                "Purchase",
                style: TextStyle(
                  fontSize: 14,
                  color: _selection.elementAt(1) == true
                      ? Colors.black
                      : Colors.white,
                ),
                textAlign: TextAlign.center,
              )),
        ],
        onPressed: (int index) {
          setState(() {
            _selection[index] = !_selection[index];
          });
          for (int buttonIndex = 0;
              buttonIndex < _selection.length;
              buttonIndex++) {
            if (buttonIndex == index) {
              _selection[buttonIndex] = true;
            } else {
              _selection[buttonIndex] = false;
            }
          }
        },
      ),
    );
  }

  Widget _body() {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .18,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              new BoxShadow(
                color: Colors.grey,
                blurRadius: 1.0,
                //spreadRadius: 1
              ),
            ]),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              margin: EdgeInsets.only(top: 60, bottom: 10),
              width: MediaQuery.of(context).size.width / 1.3,
              height: MediaQuery.of(context).size.height * .17,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                new BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5.0,
                ),
              ]),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text("Total Sale",
                        textAlign: TextAlign.center, style: style),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        height: 60,
                        width: 60,
                        image: AssetImage("images/hand.png"),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "\$$sale",
                        style: style.copyWith(color: HexColor("#6B8995")),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  color: Colors.white,
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                    ),
                  ]),
              child: Center(
                child: Column(
                  children: <Widget>[
                    // Container(
                    //     margin:
                    //         EdgeInsets.symmetric(vertical: 10, horizontal: 60),
                    //     child: _datePicker()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _amountButton(
                             "Received Amount" ,
                            "images/hands.png"),
                        _amountButton(
                             "Remaining Amount",
                                
                            "images/givinghand.png"),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _datePicker() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width / 1.2,
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(boxShadow: []),
      child: TextFormField(
        readOnly: true,
        onTap: () {
          _selectDate();
        },
        decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            filled: true,
            hintText: _value,
            // labelText: "Date",
            fillColor: Colors.white,
            suffixIcon: Icon(
              Icons.calendar_today,
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide())),
      ),
    );
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2012),
        lastDate: new DateTime.now());
    if (picked != null) setState(() => _value = picked.toString());
  }

  Widget _amountButton(String text, String image) {
    return GestureDetector(
      onTap: () {
        // AppRoutes.push(
        //     context,
        //     WalletDetail(
        //       title: _selection[0] && text == "Received Amount"
        //           ? "Received Amount"
        //           : _selection[0] && text == "Remaining Amount"
        //               ? "Remaining Amount"
        //               : _selection[1] && text == "Paid Amount"
        //                   ? "Paid Amount"
        //                   : "Payable Amount",
        //     ));
      },
      child: Container(
        height: MediaQuery.of(context).size.height * .2,
        width: MediaQuery.of(context).size.width / 2.9,
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            boxShadow: [
              new BoxShadow(
                color: Colors.grey,
                blurRadius: 5.0,
              ),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Image(
              height: 60,
              width: 60,
              image: AssetImage("$image"),
            ),
            Text(
              "$text",
              textAlign: TextAlign.center,
              style: style.copyWith(fontSize: 16),
            ),
            text=="Received Amount"?
            Text("\$$received",
                textAlign: TextAlign.center,
                style: style.copyWith(color: HexColor("#6B8995")))
                : Text("\$$remaining",
                textAlign: TextAlign.center,
                style: style.copyWith(color: HexColor("#6B8995")))
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:transact/AppBar.dart';
// import 'package:transact/Supplier/walletDetail.dart';
// import 'package:transact/utils/routes.dart';
// import 'package:transact/utils/utils.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:transact/Model/apismodel.dart';
// import 'package:transact/Model/getauthentication.dart';

// class Wallet extends StatefulWidget {
//   @override
//   _WalletState createState() => _WalletState();
// }

// class _WalletState extends State<Wallet> {
//   String _value = "Select Date";
//   var style = TextStyle(
//       fontSize: 20, fontWeight: FontWeight.bold, color: HexColor("#1C1C1C"));
//   List<bool> _selection = [true, false];

// getSupplierWallet()
// async
// {
//   var header = {
//       "Authorization": AuthenticationUser.getAuthentication(),
//     };
//     var response = await http.get(
//       "${API.SupplierWallet}",
//       headers: header,
//     );
//     var Json = json.decode(response.body);
//     print(json.decode(response.body));
// }
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getSupplierWallet();
    
//   }
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//           backgroundColor: HexColor("#F5F7FA"),
//           appBar: PreferredSize(
//             preferredSize: Size.fromHeight(120),
//             child: CustomeAppBar(
//               title: "Wallet",
//               child: _toggleButtons(),
//             ),
//           ),
//           body: _body()),
//     );
//   }

//   Widget _toggleButtons() {
//     return Container(
//       alignment: Alignment.center,
//       height: 40,
//       width: MediaQuery.of(context).size.width * .7,
//       child: ToggleButtons(
//         fillColor: Colors.white,
//         borderColor: Colors.white,
//         selectedBorderColor: Colors.white,
//         borderWidth: 1.5,
//         borderRadius: BorderRadius.circular(3),
//         isSelected: _selection,
//         children: <Widget>[
//           Container(
//               margin: EdgeInsets.symmetric(horizontal: 17),
//               child: Text(
//                 "  Sales  ",
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: _selection.elementAt(0) == true
//                       ? Colors.black
//                       : Colors.white,
//                 ),
//                 textAlign: TextAlign.center,
//               )),
//           Container(
//               margin: EdgeInsets.symmetric(horizontal: 17),
//               child: Text(
//                 "Purchase",
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: _selection.elementAt(1) == true
//                       ? Colors.black
//                       : Colors.white,
//                 ),
//                 textAlign: TextAlign.center,
//               )),
//         ],
//         onPressed: (int index) {
//           setState(() {
//             _selection[index] = !_selection[index];
//           });
//           for (int buttonIndex = 0;
//               buttonIndex < _selection.length;
//               buttonIndex++) {
//             if (buttonIndex == index) {
//               _selection[buttonIndex] = true;
//             } else {
//               _selection[buttonIndex] = false;
//             }
//           }
//         },
//       ),
//     );
//   }

//   Widget _body() {
//     return Container(
//       child: Stack(
//         children: <Widget>[
//           Container(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height * .18,
//             decoration: BoxDecoration(color: Colors.white, boxShadow: [
//               new BoxShadow(
//                 color: Colors.grey,
//                 blurRadius: 1.0,
//                 //spreadRadius: 1
//               ),
//             ]),
//           ),
//           Align(
//             alignment: Alignment.topCenter,
//             child: Container(
//               padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//               margin: EdgeInsets.only(top: 60, bottom: 10),
//               width: MediaQuery.of(context).size.width / 1.3,
//               height: MediaQuery.of(context).size.height * .17,
//               decoration: BoxDecoration(color: Colors.white, boxShadow: [
//                 new BoxShadow(
//                   color: Colors.grey,
//                   blurRadius: 5.0,
//                 ),
//               ]),
//               child: Column(
//                 children: <Widget>[
//                   Container(
//                     margin: EdgeInsets.only(bottom: 10),
//                     child: Text(_selection[0] ? "Total Sale" : "Total Purchase",
//                         textAlign: TextAlign.center, style: style),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Image(
//                         height: 60,
//                         width: 60,
//                         image: AssetImage("images/hand.png"),
//                       ),
//                       SizedBox(
//                         width: 15,
//                       ),
//                       Text(
//                         "\$4350",
//                         style: style.copyWith(color: HexColor("#6B8995")),
//                       )
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               alignment: Alignment.bottomCenter,
//               height: MediaQuery.of(context).size.height / 2,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30)),
//                   color: Colors.white,
//                   boxShadow: [
//                     new BoxShadow(
//                       color: Colors.grey,
//                       blurRadius: 5.0,
//                     ),
//                   ]),
//               child: Center(
//                 child: Column(
//                   children: <Widget>[
//                     Container(
//                         margin:
//                             EdgeInsets.symmetric(vertical: 10, horizontal: 60),
//                         child: _datePicker()),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         _amountButton(
//                             _selection[0] ? "Received Amount" : "Paid Amount",
//                             "images/hands.png"),
//                         _amountButton(
//                             _selection[0]
//                                 ? "Remaining Amount"
//                                 : "Payable Amount",
//                             "images/givinghand.png"),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _datePicker() {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 10),
//       width: MediaQuery.of(context).size.width / 1.2,
//       height: MediaQuery.of(context).size.height * 0.06,
//       decoration: BoxDecoration(boxShadow: []),
//       child: TextFormField(
//         readOnly: true,
//         onTap: () {
//           _selectDate();
//         },
//         decoration: InputDecoration(
//             isDense: true,
//             contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
//             filled: true,
//             hintText: _value,
//             // labelText: "Date",
//             fillColor: Colors.white,
//             suffixIcon: Icon(
//               Icons.calendar_today,
//             ),
//             border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide())),
//       ),
//     );
//   }

//   Future _selectDate() async {
//     DateTime picked = await showDatePicker(
//         context: context,
//         initialDate: new DateTime.now(),
//         firstDate: new DateTime(2012),
//         lastDate: new DateTime.now());
//     if (picked != null) setState(() => _value = picked.toString());
//   }

//   Widget _amountButton(String text, String image) {
//     return GestureDetector(
//       onTap: () {
//         AppRoutes.push(
//             context,
//             WalletDetail(
//               title: _selection[0] && text == "Received Amount"
//                   ? "Received Amount"
//                   : _selection[0] && text == "Remaining Amount"
//                       ? "Remaining Amount"
//                       : _selection[1] && text == "Paid Amount"
//                           ? "Paid Amount"
//                           : "Payable Amount",
//             ));
//       },
//       child: Container(
//         height: MediaQuery.of(context).size.height * .2,
//         width: MediaQuery.of(context).size.width / 2.9,
//         margin: EdgeInsets.symmetric(horizontal: 5),
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5),
//             color: Colors.white,
//             boxShadow: [
//               new BoxShadow(
//                 color: Colors.grey,
//                 blurRadius: 5.0,
//               ),
//             ]),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: <Widget>[
//             Image(
//               height: 60,
//               width: 60,
//               image: AssetImage("$image"),
//             ),
//             Text(
//               "$text",
//               textAlign: TextAlign.center,
//               style: style.copyWith(fontSize: 16),
//             ),
//             Text("\$999",
//                 textAlign: TextAlign.center,
//                 style: style.copyWith(color: HexColor("#6B8995")))
//           ],
//         ),
//       ),
//     );
//   }
// }
