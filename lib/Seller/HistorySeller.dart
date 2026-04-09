import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:transact/AppBar.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/Model/historymodel.dart';
import 'package:transact/utils/bottomButton.dart';
import 'package:transact/utils/dashedLine.dart';
import 'package:transact/utils/routes.dart';
import 'package:transact/utils/selectDate.dart';
import 'package:transact/utils/tableDataHeader.dart';
import 'package:transact/utils/togglebuttons.dart';
import 'package:transact/utils/utils.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
class SellerHistory extends StatefulWidget {
  @override
  _SellerHistory createState() => _SellerHistory();
}

class _SellerHistory extends State<SellerHistory> {
  ProgressDialog pr;
  bool order=false;
  var style = TextStyle(
      fontFamily: "CaviarDreams", fontSize: 16, fontWeight: FontWeight.bold);
  var style2 = TextStyle(
      fontFamily: "CaviarDreams",
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: HexColor("#6B6B6B"));
  int selectedIndex=0;
  List<bool> _selection = [
    true,
    false,
  ];
  bool sales = true, purchase = false;
  DateTime sDate=DateTime.now(), eDate=DateTime.now();
  DateTime currentDate = DateTime.now();
  HistoryModel historyModel=HistoryModel();
double total=0.0;
  getsaleHistory(
      BuildContext context, String sDate, String eDate) async {
        
    if(sDate.isEmpty || eDate.isEmpty)
    {
       Fluttertoast.showToast(
          msg: "Please select date",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
    else
    {
      pr.show();
      var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
      var response = await http.get(
          "${API.saleHistory}?startDate=$sDate&endDate=$eDate",
          headers: header,
          );
      // Checking Response Status (if response == 200 )
      if (response.statusCode == 200) {
     
        var jsonResponse = json.decode(response.body);
        print("Getting order history category response: $jsonResponse");
        if (jsonResponse['Data']['WithError'] == true) {
          pr.dismiss();
          
          print(' no data found');
           Fluttertoast.showToast(
          msg: "${jsonResponse['Data']['ShortMessage']}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
        } else {
           setState(() {
        total=0.0;
      });
      if(jsonResponse['Data']['Result']==null)
      {
       Fluttertoast.showToast(
          msg: "no History found",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey); 
      }
      else
      {
        pr.dismiss();
          setState(() {
            historyModel =
                HistoryModel.fromJson(jsonResponse["Data"]);
          });
         for(int i=0;i<historyModel.result.length;i++)
         {
           setState(() {
             total=total+historyModel.result[i].totalBill;
           });
         }
      }
          
        }

        // print(_categoriesModel.result.length);

      } else {
        pr.dismiss();
         Fluttertoast.showToast(
          msg: "response status: ${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
        print(
            " failed to get order history  with status: ${response.statusCode}");
        json.decode(response.body);
        }
    }
    
      // Catch Error
    
  }


  getsale(
      BuildContext context, String sDate, String eDate) async {
        
    if(sDate.isEmpty || eDate.isEmpty)
    {
       Fluttertoast.showToast(
          msg: "Please select date",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
    else
    {
     // pr.show();
      var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
      var response = await http.get(
          "${API.saleHistory}?startDate=$sDate&endDate=$eDate",
          headers: header,
          );
      // Checking Response Status (if response == 200 )
      if (response.statusCode == 200) {
     
        var jsonResponse = json.decode(response.body);
        print("Getting order history category response: $jsonResponse");
        if (jsonResponse['Data']['WithError'] == true) {
          //pr.dismiss();
          
          print(' no data found');
           Fluttertoast.showToast(
          msg: "${jsonResponse['Data']['ShortMessage']}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
        } else {
           setState(() {
        total=0.0;
      });
      if(jsonResponse['Data']['Result']==null)
      {
       Fluttertoast.showToast(
          msg: "no History found",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey); 
      }
      else
      {
       // pr.dismiss();
          setState(() {
            historyModel =
                HistoryModel.fromJson(jsonResponse["Data"]);
          });
         for(int i=0;i<historyModel.result.length;i++)
         {
           setState(() {
             total=total+historyModel.result[i].totalBill;
           });
         }
      }
          
        }

        // print(_categoriesModel.result.length);

      } else {
        pr.dismiss();
         Fluttertoast.showToast(
          msg: "response status: ${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
        print(
            " failed to get order history  with status: ${response.statusCode}");
        json.decode(response.body);
        }
    }
    
      // Catch Error
    
  }

  getpurchaseHistory(
      BuildContext context, String sDate, String eDate) async {

    if(sDate.isEmpty || eDate.isEmpty)
    {
       Fluttertoast.showToast(
          msg: "Please select date",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
    else
    {
      pr.show();
      var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
      var response = await http.get(
          "${API.PurchaseHistory}?startDate=$sDate&endDate=$eDate",
          headers: header,
          );
      // Checking Response Status (if response == 200 )
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print("Getting order history category response: $jsonResponse");
        if (jsonResponse['Data']['WithError'] == true) {
          pr.dismiss();
          
          print(' no data found');
           Fluttertoast.showToast(
          msg: "${jsonResponse['Data']['ShortMessage']}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
        } else {
          pr.dismiss();
           setState(() {
        total=0.0;
      });
          if(jsonResponse['Data']['Result']==null)
      {
       Fluttertoast.showToast(
          msg: "no History found",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey); 
      }
      else
      {
        pr.dismiss();
          setState(() {
            historyModel =
                HistoryModel.fromJson(jsonResponse["Data"]);
          });
         for(int i=0;i<historyModel.result.length;i++)
         {
           setState(() {
             total=total+historyModel.result[i].totalBill;
           });
         }
      }

        }

        // print(_categoriesModel.result.length);

      } else {
        pr.dismiss();
         Fluttertoast.showToast(
          msg: "response status: ${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
        print(
            " failed to get order history  with status: ${response.statusCode}");
        json.decode(response.body);
        }
    }
    
      // Catch Error
    
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getsale(context, sDate.toString(), eDate.toString());
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
        backgroundColor: HexColor("#F5F7FA"),
        // bottomNavigationBar: BottomButton(
        //   name: "Print Receipt",
        //   image: Image(
        //     image: AssetImage("images/print.png"),
        //   ),
        //   ontap: () {
        //     print("working");
        //   },
        // ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: CustomeAppBar(
            homepage: false,
            title: "History",
            child: Buttons()
          
            // ToggleButton(
            //     isSelected: _selection,
            //     buttonCount: 2,
            //     child1Title: "   Sales   ",
            //     child2Title: "Purchase",
            //     onPress: (int index) {
            //       setState(() {
            //         _selection[index] = !_selection[index];
            //         if(_selection[index]==true)
            //         {
            //           print("sales");
            //         }
            //         else
            //         {
            //           print("purchase");
            //         }
            //       });
            //       for (int buttonIndex = 0;
            //           buttonIndex < _selection.length;
            //           buttonIndex++) {
            //         if (buttonIndex == index) {
            //           _selection[buttonIndex] = true;
            //           //print("sales");
            //         } else {
            //          // print("purchase");
            //           _selection[buttonIndex] = false;
            //         }
            //       }
            //     }),
          
          ),
        ),
        body: order==false?
           Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              //SelectDate(),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     Buttons(),
              //   ],
              // ),
              SizedBox(
                height: 5,
              ),
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Picker(
                        hideHeader: true,
                        adapter: DateTimePickerAdapter(),
                        title: Text("Select Date"),
                        selectedTextStyle: TextStyle(color: Colors.blue),
                        onConfirm: (Picker picker, List value) {
                          print(
                              (picker.adapter as DateTimePickerAdapter).value);
                          setState(() {
                            sDate =
                                (picker.adapter as DateTimePickerAdapter).value;
                            // "${(picker.adapter as DateTimePickerAdapter).value.year}-${(picker.adapter as DateTimePickerAdapter).value.month}-${(picker.adapter as DateTimePickerAdapter).value.day}";
                            eDate = null;
                          });
                          //getMerchantOrderHistory(context, sDate, eDate);
                        }).showDialog(context);
                  },
                  child: Card(
                    elevation: 10,
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      height: 30,
                      width: MediaQuery.of(context).size.width / 2.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              sDate != null
                                  ? Flexible(
                                      child: Text("$sDate",
                                          overflow: TextOverflow.clip,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.bold)),
                                    )
                                  : Text("Start Date",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.bold)),
                              Icon(
                                FontAwesomeIcons.calendar,
                                color: Colors.grey[600],
                                size: 15,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Picker(
                        hideHeader: true,
                        adapter: DateTimePickerAdapter(),
                        title: Text("Select Date"),
                        selectedTextStyle: TextStyle(color: Colors.blue),
                        onConfirm: (Picker picker, List value) {
                          print(
                              (picker.adapter as DateTimePickerAdapter).value);
                          setState(() {
                            // sDate =
                            //     "${(picker.adapter as DateTimePickerAdapter).value.year}-${(picker.adapter as DateTimePickerAdapter).value.month}-01";
                            eDate =
                                (picker.adapter as DateTimePickerAdapter).value;
                            // "${(picker.adapter as DateTimePickerAdapter).value.year}-${(picker.adapter as DateTimePickerAdapter).value.month}-${(picker.adapter as DateTimePickerAdapter).value.day}";
                          });
                          if (eDate.millisecondsSinceEpoch <=
                              sDate.millisecondsSinceEpoch) {
                            Fluttertoast.showToast(
                                msg:
                                    "End date must be greater than the starting date");
                          } else {
                            if(
                              eDate.day >
                              currentDate.day||sDate.day>currentDate.day )
                            {
                              Fluttertoast.showToast(
                                  msg:
                                      "End Date not be greater than current Date");
                              eDate = null;
                              sDate=null;
                            }
                            else
                            {
                              //pr.show();
                              if(sales==true)
                              {
                                if(sDate.toString().isEmpty || eDate.toString().isEmpty)
                                {
                                  print("no data selected");
                                }
                                else
                                {
                                  getsaleHistory(
                                context, sDate.toString(), eDate.toString());
                                }
                                
                              }
                              else
                              {
                                getpurchaseHistory(
                                context, sDate.toString(), eDate.toString());
                              }
                              
                            }
                            
                          }
                        }).showDialog(context);
                  },
                  child: Card(
                    elevation: 10,
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      height: 30,
                      width: MediaQuery.of(context).size.width / 2.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              eDate != null
                                  ? Flexible(
                                      child: Text("$eDate",
                                          overflow: TextOverflow.clip,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.bold)))
                                  : Text("End Date",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.bold)),
                              Icon(
                                FontAwesomeIcons.calendar,
                                color: Colors.grey[600],
                                size: 15,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
             SizedBox(
                height: 5,
              ),
              TableDataHeader(
                c1: _selection[0]
                    ? "Sales Order #"
                    : _selection[1] ? "Purchase Order #" : "Order #",
                c2: "Date",
                c3: "Transation",
              ),
              Expanded(child: _listData()),
              TableDataHeader(
                c1: "Total",
                c2: "",
                c3: "\$ $total",
              ),
            ],
          ),
        )
        :_order()
     
      ),
    );
  }

  Widget _rowText(String text, String textcolor) {
    return Text(
      "$text",
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: textcolor == "white" ? Colors.white : Colors.black),
    );
  }
 Widget _order() {
    return Container(
      child: Column(
        children: <Widget>[_orderDetails(), _customerDetails()],
      ),
    );
  }

Widget _orderDetails() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .5,
        // margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                onTap: ()
                {
                  setState(() {
                    order=false;
                  });
                },
                child: Icon(Icons.cancel),

              ),
            ],
          ),
              Text(
                "Order Detail",
                style: style.copyWith(color: HexColor("#6B6B6B"), fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Text(
                "  Order# ",
                style: style.copyWith(color: Colors.black, fontSize: 17),
              ),
              Text(
                "${historyModel.result[selectedIndex].orderNumber}",
                style: style.copyWith(color: Colors.black, fontSize: 14),
              ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Text(
                "  by  ",
                style: style.copyWith(color: Colors.black, fontSize: 17),
              ),
              Text(
                "${historyModel.result[selectedIndex].customerName}",
                style: style.copyWith(color: Colors.black, fontSize: 14),
              ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Text(
                "  Payment Method:  ",
                style: style.copyWith(color: Colors.black, fontSize: 17),
              ),
              historyModel.result[selectedIndex].paymentMethod==0?
              Text(
                "Cash",
                style: style.copyWith(color: Colors.black, fontSize: 14),
              ):
              historyModel.result[selectedIndex].paymentMethod==1?
              Text(
                "Card",
                style: style.copyWith(color: Colors.black, fontSize: 14),
              ):
              Text(
                "Bank",
                style: style.copyWith(color: Colors.black, fontSize: 14),
              ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right:10),
                    child: Text(
                "${historyModel.result[selectedIndex].totalBill}",
                style: style.copyWith(color: Colors.black, fontSize: 14),
              ),
                  ),
                ],
              ),
              _divider(),
              Expanded(
                child: ListView.builder(
                    itemCount:
                        historyModel.result[selectedIndex].lineDetail != null
                            ? historyModel.result[selectedIndex].lineDetail.length
                            : 0,
                    itemBuilder: (BuildContext context, int index) {
                      return productsDetail(index);
                    }),
              ),
            ]));
  }

Widget _divider() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      height: 1,
      color: HexColor("#707070"),
    );
  }
    Widget productsDetail(int index) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Wrap(
                  children: <Widget>[
                    // Image(
                    //   height: MediaQuery.of(context).size.height * .14,
                    //   width: MediaQuery.of(context).size.width * .3,
                    //   image: AssetImage("images/iphone.png"),
                    // ),
                    historyModel.result[selectedIndex].lineDetail[index]
                                .imageUrl !=
                            null
                        ? Image.network(
                            "${API.API_URL}${historyModel.result[selectedIndex].lineDetail[index].imageUrl}",
                            height: MediaQuery.of(context).size.height * .14,
                            width: MediaQuery.of(context).size.width * .3,
                          )
                        : Image.asset(
                            "images/iphone.png",
                            height: MediaQuery.of(context).size.height * .14,
                            width: MediaQuery.of(context).size.width * .3,
                          ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "${historyModel.result[selectedIndex].lineDetail[index].productName}",
                          style: style.copyWith(color: HexColor("#6B6B6B")),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "${historyModel.result[selectedIndex].lineDetail[index].qty}",
                          textAlign: TextAlign.start,
                          style: style2,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Text(
                "\$${historyModel.result[selectedIndex].lineDetail[index].total}",
                style: style,
              ),
            ],
          ),
        ],
      ),
    );
  }

 Widget _customerDetails() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 1),
              child: Text(
                "Customer Details",
                style: style2.copyWith(fontSize: 16),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${historyModel.result[selectedIndex].customerName}",
                    style: style2.copyWith(
                       // fontFamily: "antipasto",
                        fontSize: 18,
                        color: Colors.black),
                  ),
                  Text(
                    "Customer Name",
                    style: style2.copyWith(fontSize: 12),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  historyModel.result[selectedIndex].deliveryType==0?
                  Text(
                    "Seller",
                    style: style2.copyWith(
                        fontFamily: "antipasto",
                        fontSize: 18,
                        color: Colors.black),
                  )
                  :
                  historyModel.result[selectedIndex].deliveryType==1?
                  Text(
                    "Online",
                    style: style2.copyWith(
                        fontFamily: "antipasto",
                        fontSize: 18,
                        color: Colors.black),
                  ):
                  historyModel.result[selectedIndex].deliveryType==1?
                  Text(
                    "Self PickUp",
                    style: style2.copyWith(
                        fontFamily: "antipasto",
                        fontSize: 18,
                        color: Colors.black),
                  ):
                  Text(
                    "Free",
                    style: style2.copyWith(
                        fontFamily: "antipasto",
                        fontSize: 18,
                        color: Colors.black),
                  ),
                 
                  Text(
                    "Delivery",
                    style: style2.copyWith(fontSize: 12),
                  ),
                ],
              )
           
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              children: <Widget>[
                Image(
                    height: 20,
                    width: 20,
                    image: AssetImage("images/call.png")),
                historyModel.result[selectedIndex].customerNumber != null
                    ? Text(
                        "  ${historyModel.result[selectedIndex].customerNumber}")
                    : Text("  contact no")
              ],
            ),
          ),
          // Container(
          //   margin: EdgeInsets.only(top: 10, bottom: 10),
          //   child: Row(
          //     children: <Widget>[
          //       Image(
          //           height: 20, width: 20, image: AssetImage("images/msg.png")),
          //       Text("  Chat"),
          //     ],
          //   ),
          // ),
          
        ],
      ),
    );
  }
 
////////////////////////////  List to be implemented ////////////////////

  Widget _listData() {
    return GestureDetector(
      onTap: () {
        if(sales==true)
        {
       
          //AppRoutes.push(context, SalesHistory());
        }
        else
        {
         // AppRoutes.push(context, PurchaseHistory());
        }
        
      },
      child: Container(
        // height: MediaQuery.of(context).size.height * .6,
        decoration: BoxDecoration(),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: historyModel.result!=null?historyModel.result.length:0,
          itemBuilder: (context, int index) {
            return
            
          GestureDetector(
            onTap: ()
            {
                 setState(() {
                   order=true;
            selectedIndex=index;
          });
            },
            child:    Container(
              margin: EdgeInsets.symmetric(vertical: 2,horizontal: 1),
              padding: EdgeInsets.all(8),
              height: MediaQuery.of(context).size.height * 0.08,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(child: _rowText("${historyModel.result[index].orderNumber}", "")),
                  Expanded(child: _rowText("${historyModel.result[index].date}", "")),
                  Expanded(child: _rowText("\$${historyModel.result[index].totalBill}", "")),
                ],
              ),
            )
          
          );
          },
        ),
      ),
    );
  }
    Widget Buttons() {
    return Container(
      margin: EdgeInsets.only( bottom: 10),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .08,
      decoration: BoxDecoration(
         // color: Colors.white,
         // border: Border.all(color: Colors.blueGrey, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                setState(() {
                  sales = true;
                  purchase = false;
                  
                });
                getsaleHistory(context, sDate.toString(), eDate.toString());
                //getPendingList();
              },
              child: Container(
                width: MediaQuery.of(context).size.width * .2,
                height: MediaQuery.of(context).size.height * .06,
                decoration: BoxDecoration(
                    color: sales == true ? HexColor("#3B444B") : Colors.white,
                    border: Border.all(color: Colors.blueGrey, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                child: Center(
                  child: Text(
                    "Sales",
                    style: TextStyle(
                        color: sales == true
                            ? Colors.white
                            : HexColor("#3B444B"),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  sales = false;
                  purchase = true;
                  // rejected = false;
                  // delivered = false;
                });
                getpurchaseHistory(context, sDate.toString(), eDate.toString());
               // getInProcessList();
              },
              child: Container(
                width: MediaQuery.of(context).size.width * .2,
                height: MediaQuery.of(context).size.height * .06,
                decoration: BoxDecoration(
                    color:
                        purchase == true ? HexColor("#3B444B") : Colors.white,
                    border: Border.all(color: Colors.blueGrey, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                child: Center(
                  child: Text(
                    "Purchase",
                    style: TextStyle(
                        color: purchase == true
                            ? Colors.white
                            : HexColor("#3B444B"),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            // GestureDetector(
            //   onTap: () {
            //     setState(() {
            //       pending = false;
            //       inProcess = false;
            //       rejected = true;
            //       delivered = false;
            //     });
            //     getRejectedList();
            //   },
            //   child: Container(
            //     width: MediaQuery.of(context).size.width * .2,
            //     height: MediaQuery.of(context).size.height * .06,
            //     decoration: BoxDecoration(
            //         color:
            //             rejected == true ? HexColor("#3B444B") : Colors.white,
            //         border: Border.all(color: Colors.blueGrey, width: 1),
            //         borderRadius: BorderRadius.all(Radius.circular(10))),
            //     child: Center(
            //       child: Text(
            //         "Rejected",
            //         style: TextStyle(
            //             color: rejected == true
            //                 ? Colors.white
            //                 : HexColor("#3B444B"),
            //             fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //   ),
            // ),
            // GestureDetector(
            //   onTap: () {
            //     setState(() {
            //       pending = false;
            //       inProcess = false;
            //       rejected = false;
            //       delivered = true;
            //     });
            //     getDeliveredList();
            //   },
            //   child: Container(
            //     width: MediaQuery.of(context).size.width * .2,
            //     height: MediaQuery.of(context).size.height * .06,
            //     decoration: BoxDecoration(
            //         color:
            //             delivered == true ? HexColor("#3B444B") : Colors.white,
            //         border: Border.all(color: Colors.blueGrey, width: 1),
            //         borderRadius: BorderRadius.all(Radius.circular(10))),
            //     child: Center(
            //       child: Text(
            //         "Delivered",
            //         style: TextStyle(
            //             color: delivered == true
            //                 ? Colors.white
            //                 : HexColor("#3B444B"),
            //             fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //   ),
            // ),
         
          ],
        ),
      ),
    );
  }

}

class SalesHistory extends StatefulWidget {
  @override
  _SalesHistoryState createState() => _SalesHistoryState();
}

class _SalesHistoryState extends State<SalesHistory> {
  var style = TextStyle(
      fontFamily: "CaviarDreams", fontSize: 16, fontWeight: FontWeight.bold);
  var style2 = TextStyle(
      fontFamily: "CaviarDreams",
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: HexColor("#6B6B6B"));
  var formattedTime = new DateFormat("dd-MM-yyyy").format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomButton(
          name: "Print Receipt",
          image: Image(
            image: AssetImage("images/print.png"),
          ),
          ontap: () {
            print("working");
          },
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: CustomeAppBar(
            title: "Sales History",
            homepage: false,
          ),
        ),
        body: Column(
          children: <Widget>[
            _orderNumber(),
            _orderDetails(),
          ],
        ),
      ),
    );
  }

  Widget _orderNumber() {
    var style = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    var style2 = TextStyle(
        fontSize: 12, fontWeight: FontWeight.bold, color: HexColor("#6B6B6B"));
    return Container(
        margin: EdgeInsets.all(10),
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: Text("$formattedTime",
                    style: TextStyle(color: HexColor("#9E9E9E"), fontSize: 12)),
              ),
              Text(
                "Order #  CK1FF25",
                style: style,
              ),
              Text(
                "by john Doe",
                style: style2,
              ),
              Row(children: <Widget>[
                Text(
                  "Payment Method",
                  style: style2,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Cash",
                  style: style,
                )
              ]),
              Align(
                alignment: Alignment.bottomRight,
                child: Text("\$945", style: style),
              ),
            ]));
  }

  Widget _orderDetails() {
    return Container(
        margin: EdgeInsets.all(10),
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Order Detail",
                style: style.copyWith(color: HexColor("#6B6B6B")),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Wrap(
                      children: <Widget>[
                        Image(
                          height: MediaQuery.of(context).size.height * .14,
                          width: MediaQuery.of(context).size.width * .3,
                          image: AssetImage("images/iphone.png"),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "iphone 8",
                              style: style.copyWith(color: HexColor("#6B6B6B")),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              "1 x \$200",
                              textAlign: TextAlign.start,
                              style: style2,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Text(
                    "\$968",
                    style: style,
                  ),
                ],
              ),
              _divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Wrap(
                      children: <Widget>[
                        Image(
                          height: MediaQuery.of(context).size.height * .14,
                          width: MediaQuery.of(context).size.width * .3,
                          image: AssetImage("images/iphone.png"),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "iphone 8",
                              style: style.copyWith(color: HexColor("#6B6B6B")),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              "1 x \$200",
                              textAlign: TextAlign.start,
                              style: style2,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Text(
                    "\$968",
                    style: style.copyWith(color: HexColor("#3B444B")),
                  ),
                ],
              ),
              _divider(),
              Container(
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Text("Sub Total   \$924",
                    style: style.copyWith(color: HexColor("#3B444B"))),
              ),
              MySeparator(),
              Container(
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Text("Total   \$924",
                    style: style.copyWith(color: HexColor("#3B444B"))),
              ),
            ]));
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      height: 1,
      color: HexColor("#707070"),
    );
  }
}

class PurchaseHistory extends StatefulWidget {
  @override
  _PurchaseHistoryState createState() => _PurchaseHistoryState();
}

class _PurchaseHistoryState extends State<PurchaseHistory> {
  var style = TextStyle(
      fontFamily: "CaviarDreams", fontSize: 16, fontWeight: FontWeight.bold);
  var style2 = TextStyle(
      fontFamily: "CaviarDreams",
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: HexColor("#6B6B6B"));
  var formattedTime = new DateFormat("dd-MM-yyyy").format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomButton(
          name: "Print Receipt",
          image: Image(
            image: AssetImage("images/print.png"),
          ),
          ontap: () {
            print("working");
          },
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: CustomeAppBar(
            title: "Purchase History",
            homepage: false,
          ),
        ),
        body: Column(
          children: <Widget>[
            _orderNumber(),
            _orderDetails(),
          ],
        ),
      ),
    );
  }

  Widget _orderNumber() {
    var style = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    var style2 = TextStyle(
        fontSize: 12, fontWeight: FontWeight.bold, color: HexColor("#6B6B6B"));
    return Container(
        margin: EdgeInsets.all(10),
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: Text("$formattedTime",
                    style: TextStyle(color: HexColor("#9E9E9E"), fontSize: 12)),
              ),
              Text(
                "Order #  CK1FF25",
                style: style,
              ),
              Text(
                "by john Doe",
                style: style2,
              ),
              Row(children: <Widget>[
                Text(
                  "Payment Method",
                  style: style2,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "COD",
                  style: style,
                )
              ]),
              Align(
                alignment: Alignment.bottomRight,
                child: Text("\$945", style: style),
              ),
            ]));
  }

  Widget _orderDetails() {
    return Container(
        margin: EdgeInsets.all(10),
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Order Detail",
                style: style.copyWith(color: HexColor("#6B6B6B")),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Wrap(
                      children: <Widget>[
                        Image(
                          height: MediaQuery.of(context).size.height * .14,
                          width: MediaQuery.of(context).size.width * .3,
                          image: AssetImage("images/iphone.png"),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "iphone 8",
                              style: style.copyWith(color: HexColor("#6B6B6B")),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              "1 x \$200",
                              textAlign: TextAlign.start,
                              style: style2,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Text(
                    "\$968",
                    style: style,
                  ),
                ],
              ),
              _divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Wrap(
                      children: <Widget>[
                        Image(
                          height: MediaQuery.of(context).size.height * .14,
                          width: MediaQuery.of(context).size.width * .3,
                          image: AssetImage("images/iphone.png"),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "iphone 8",
                              style: style.copyWith(color: HexColor("#6B6B6B")),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              "1 x \$200",
                              textAlign: TextAlign.start,
                              style: style2,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Text(
                    "\$968",
                    style: style.copyWith(color: HexColor("#3B444B")),
                  ),
                ],
              ),
              _divider(),
              Container(
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Text("Sub Total   \$924",
                    style: style.copyWith(color: HexColor("#3B444B"))),
              ),
              MySeparator(),
              Container(
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Text("Total   \$924",
                    style: style.copyWith(color: HexColor("#3B444B"))),
              ),
            ]));
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      height: 1,
      color: HexColor("#707070"),
    );
  }


  
}
