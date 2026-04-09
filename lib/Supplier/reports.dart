import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:transact/AppBar.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/Model/ordermodel.dart';
import 'package:transact/Model/totalexpansemodel.dart';
import 'package:transact/Seller/HistorySeller.dart';
import 'package:transact/Seller/expansedetail.dart';
import 'package:transact/Supplier/History.dart';
import 'package:transact/Supplier/wallet.dart';
import 'package:transact/utils/bottomButton.dart';
import 'package:transact/utils/fonts.dart';
import 'package:transact/utils/graphs.dart';
import 'package:http/http.dart' as http;
import 'package:transact/utils/routes.dart';
import 'dart:convert';
import 'package:transact/utils/togglebuttons.dart';
import 'package:transact/utils/utils.dart';

class Reports extends StatefulWidget {
  @override
  _ReportsSellerState createState() => _ReportsSellerState();
}

class _ReportsSellerState extends State<Reports> {
  List<String> _catagory = [
    'Transaction',
    'Profit/Loss',
    'Sale Purchase',
    'Total Expense'
  ];
  ProgressDialog pr;
  OrderModel orderModel=OrderModel();
  TotalExpanseModel totalExpanseModel=TotalExpanseModel();
  DateTime d=DateTime.now();
  DateTime sDate=DateTime.now(), eDate=DateTime.now();
  DateTime currentDate = DateTime.now();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedCatagory;
  String _value = 'Select Date';
  TextEditingController _dateController;
  List<bool> _selection = [true, false, false, false];
  bool bottomSheet = false;
  bool profit=false,texpanse=true;
  bool expanseCheck=false,saleCheck=false,purchaseCheck=false;
  String totalPurchase = "0",
      totalSale = "0",
      totalSaleCount = "0",
      totalPurchaseCount = "0";

getPurchaseHistory(
  DateTime sDate, DateTime eDate
) async {
  if(sDate==null || eDate==null)
  {
    Fluttertoast.showToast(
          msg: "Please select date first",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
  }
  else
  {
    pr.show();
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    print(header);
    var response = await http.get(
      "${API.TotalPurchaseHistory}?startDate=$sDate&endDate=$eDate",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == false) {
        pr.dismiss();
        setState(() {
          orderModel=OrderModel.fromJson(Json['Data']);
          purchaseCheck=true;
        });
      } else {
        pr.dismiss();
        Fluttertoast.showToast(
            msg: "${Json['data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);

        setState(() {
          orderModel = OrderModel();
        });
      }
    } else {
      pr.dismiss();
      Fluttertoast.showToast(
          msg: "response status: ${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  } 
  }



getSaleHistory(
  DateTime sDate, DateTime eDate
) async {
  if(sDate==null || eDate==null)
  {
    Fluttertoast.showToast(
          msg: "Please select date first",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
  }
  else
  {
    pr.show();
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    print(header);
    var response = await http.get(
      "${API.TotalSaleHistory}?startDate=$sDate&endDate=$eDate",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == false) {
        pr.dismiss();
        setState(() {
          orderModel = OrderModel.fromJson(Json['Data']);
          saleCheck=true;
        });
      } else {
        pr.dismiss();
        Fluttertoast.showToast(
            msg: "${Json['data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);

        setState(() {
          orderModel = OrderModel();
        });
      }
    } else {
      pr.dismiss();
      Fluttertoast.showToast(
          msg: "response status: ${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  } 
  }



getExpanseReport(
  DateTime sDate, DateTime eDate
) async {
  if(sDate==null || eDate==null)
  {
    Fluttertoast.showToast(
          msg: "Please select date first",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
  }
  else
  {
    pr.show();
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    print(header);
    var response = await http.get(
      "${API.TotalExpanse}?startingDate=$sDate&endingDate=$eDate",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == false) {
        pr.dismiss();
        setState(() {
          totalExpanseModel = TotalExpanseModel.fromJson(Json['Data']);
          expanseCheck=true;
        });
      } else {
        pr.dismiss();
        Fluttertoast.showToast(
            msg: "${Json['data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);

        setState(() {
          totalExpanseModel = TotalExpanseModel();
          expanseCheck=false;
        });
      }
    } else {
      pr.dismiss();
      Fluttertoast.showToast(
          msg: "response status: ${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  } 
  }
 getRep(DateTime sDate, DateTime eDate) async {
    print("start date: " + sDate.toString());
    print("end date: " + eDate.toString());
    // pr.show();
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    print(header);
    var response = await http.get(
      "${API.ReportApi}?startDate=$sDate&endDate=$eDate",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      //pr.dismiss();
      setState(() {
        totalPurchase = Json['TotalPurchaseAmount'].toString();
        totalSale = Json['TotalSaleAmount'].toString();
        totalPurchaseCount = Json['TotalPurchaseCount'].toString();
        totalSaleCount = Json['TotalSaleCount'].toString();

      });
      print(totalPurchase + totalPurchaseCount + totalSale + totalSaleCount);
    } else {
      
       Fluttertoast.showToast(
          msg: "${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }

  getReport(DateTime sDate, DateTime eDate) async {
    print("start date: " + sDate.toString());
    print("end date: " + eDate.toString());
    pr.show();
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    print(header);
    var response = await http.get(
      "${API.ReportApi}?startDate=$sDate&endDate=$eDate",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      pr.dismiss();
      setState(() {
        totalPurchase = Json['TotalPurchaseAmount'].toString();
        totalSale = Json['TotalSaleAmount'].toString();
        totalPurchaseCount = Json['TotalPurchaseCount'].toString();
        totalSaleCount = Json['TotalSaleCount'].toString();

      });
      print(totalPurchase + totalPurchaseCount + totalSale + totalSaleCount);
    } else {
      pr.dismiss();
       Fluttertoast.showToast(
          msg: "${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRep(sDate,eDate);
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
      message: 'Uploading...',
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
          key: _scaffoldKey,
          bottomSheet: bottomSheet == true ? _bottomSheet() : null,
          backgroundColor: HexColor("#F5F7FA"),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: CustomeAppBar(
              homepage: false,
              title: "Reports",
              // suffixIcon: "images/applyfilter.png",
              // suffix: true,
              // suffixOnTap: () {
              //   setState(() {
              //     bottomSheet = true;
              //   });
              // },
              // child: Buttons(),
              // child: ToggleButton(
              //   isSelected: _selection,
              //   child1Title: "Today",
              //   child2Title: "Weekly",
              //   child3Title: "Monthly",
              //   child4Title: "Products",
              //   buttonCount: 4,
              //   onPress: (int index) {
              //     setState(() {
              //       _selection[index] = !_selection[index];
              //       for (int buttonIndex = 0;
              //           buttonIndex < _selection.length;
              //           buttonIndex++) {
              //         if (buttonIndex == index) {
              //           _selection[buttonIndex] = true;
              //         } else {
              //           _selection[buttonIndex] = false;
              //         }
              //       }
              //     });
              //   },
              // ),
            ),
          ),
         
          body: Column(
            children: <Widget>[
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
                            print((picker.adapter as DateTimePickerAdapter)
                                .value);
                            setState(() {
                              sDate = (picker.adapter as DateTimePickerAdapter)
                                  .value;
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
                            print((picker.adapter as DateTimePickerAdapter)
                                .value);
                            setState(() {
                              // sDate =
                              //     "${(picker.adapter as DateTimePickerAdapter).value.year}-${(picker.adapter as DateTimePickerAdapter).value.month}-01";
                              eDate = (picker.adapter as DateTimePickerAdapter)
                                  .value;
                              // "${(picker.adapter as DateTimePickerAdapter).value.year}-${(picker.adapter as DateTimePickerAdapter).value.month}-${(picker.adapter as DateTimePickerAdapter).value.day}";
                            });
                            if (eDate.millisecondsSinceEpoch <=
                                sDate.millisecondsSinceEpoch) {
                              Fluttertoast.showToast(
                                  msg:
                                      "End date must be greater than the starting date");
                            } else {
                              if (eDate.day > currentDate.day ||
                                  sDate.day > currentDate.day) {
                                Fluttertoast.showToast(
                                    msg:
                                        "End Date not be greater than current Date");
                                eDate = null;
                                sDate = null;
                              } else {
                                getReport(sDate,
                                    eDate);
                                //pr.show();
                                // if(sales==true)
                                // {
                                //   if(sDate.toString().isEmpty || eDate.toString().isEmpty)
                                //   {
                                //     print("no data selected");
                                //   }
                                //   else
                                //   {
                                //   //   getsaleHistory(
                                //   // context, sDate.toString(), eDate.toString());
                                //   }

                                // }
                                // else
                                // {
                                //   getpurchaseHistory(
                                //   context, sDate.toString(), eDate.toString());
                                // }

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
             
              _salenPurchase(),
              _selection[0]
                  ? Column(children: <Widget>[
                      //BarChartSample5(),
                      _orderReceive("Order Received", "$totalSaleCount"),
                      _orderReceive("Order Sent", "$totalPurchaseCount"),
                    ])
                  : Column(children: <Widget>[
                      _orderReceive("Order Received", "149"),
                      _orderReceive("Order Sent", "691"),
                     // BarChartSample5()
                    ]),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: ()
                        {
                          AppRoutes.push(context, ExpenseDetail());
                        },
                        child: Container(
                          margin: EdgeInsets.only(top:10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white,
                          ),
                          width: MediaQuery.of(context).size.width*.8,
                          height: MediaQuery.of(context).size.height*.1,
                          child: Center(
                            child: Text("Expense Detail",style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: ()
                        {
                          AppRoutes.push(context, Wallet());
                        },
                        child: Container(
                          margin: EdgeInsets.only(top:10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white,
                          ),
                          width: MediaQuery.of(context).size.width*.8,
                          height: MediaQuery.of(context).size.height*.1,
                          child: Center(
                            child: Text("Account Detail",style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),),
                          ),
                        ),
                      ),
                    ],
                  ),
           
            //   expanseCheck==true?
            //   Padding(
            //     padding: EdgeInsets.only(left:14,right:8),
            //     child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: <Widget>[
            //       Text("Date",style: TextStyle(
            //         color: Colors.black,fontSize: 18,
            //         fontWeight: FontWeight.bold
            //       ),),
            //       Text("      Quantity",style: TextStyle(
            //         color: Colors.black,fontSize: 18,
            //         fontWeight: FontWeight.bold
            //       ),),
            //        Text("Price",style: TextStyle(
            //         color: Colors.black,fontSize: 18,
            //         fontWeight: FontWeight.bold
            //       ),),
            //        Text("Total ",style: TextStyle(
            //         color: Colors.black,fontSize: 18,
            //         fontWeight: FontWeight.bold
            //       ),),
            //     ],
            //   ),
            //   )
            //   :
            //   saleCheck==true?
            //    Padding(
            //     padding: EdgeInsets.only(left:14,right:8),
            //     child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: <Widget>[
            //       Text("Date",style: TextStyle(
            //         color: Colors.black,fontSize: 18,
            //         fontWeight: FontWeight.bold
            //       ),),
            //       Text("      Order Number",style: TextStyle(
            //         color: Colors.black,fontSize: 18,
            //         fontWeight: FontWeight.bold
            //       ),),
            //        Text("Total Bill",style: TextStyle(
            //         color: Colors.black,fontSize: 18,
            //         fontWeight: FontWeight.bold
            //       ),),
                   
            //     ],
            //   ),
            //   ):
           
            //  purchaseCheck==true?
            //      Padding(
            //     padding: EdgeInsets.only(left:14,right:8),
            //     child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: <Widget>[
            //       Text("Date",style: TextStyle(
            //         color: Colors.black,fontSize: 18,
            //         fontWeight: FontWeight.bold
            //       ),),
            //       Text("      Order Number",style: TextStyle(
            //         color: Colors.black,fontSize: 18,
            //         fontWeight: FontWeight.bold
            //       ),),
            //        Text("Total Bill",style: TextStyle(
            //         color: Colors.black,fontSize: 18,
            //         fontWeight: FontWeight.bold
            //       ),),
                   
            //     ],
            //   ),
            //   ):
            //   Text(""),
              // Expanded(
              //   child: ListView.builder(itemBuilder: (BuildContext context,int index)
              //   {
              //     return 
              //     saleCheck==true?
              //     totalSaleList(index):
              //     purchaseCheck==true?
              //     totalSaleList(index)
              //     :
              //     totalExpanseList(index);
              //   },
              //   itemCount: 
              //   saleCheck==true?
              //   orderModel.result!=null?orderModel.result.length:0
              //   :
              //   purchaseCheck==true?
              //   orderModel.result!=null?orderModel.result.length:0
              //   :
              //   totalExpanseModel.result!=null?totalExpanseModel.result.length:0,
              //   ),
              // ),
           
            ],
          )

          ),
    );
  }

Widget totalSaleList(int index)
{
  return Container(
    
    color: Colors.white,
    width: MediaQuery.of(context).size.width,
    margin: EdgeInsets.only(left:10,right:2,top:10),
    height: 40,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 3,
              child:Text("${orderModel.result[index].date}",style: TextStyle(
                    color: Colors.black,fontSize: 14,
                    //fontWeight: FontWeight.bold
                  ),),
            ),
             Expanded(
              flex: 4,
              child:Text("${orderModel.result[index].orderNumber}",style: TextStyle(
                    color: Colors.black,fontSize: 14,
                    //fontWeight: FontWeight.bold
                  ),),
            ),
             Expanded(
              flex: 2,
              child:Text("    \$${orderModel.result[index].totalBill}",style: TextStyle(
                    color: Colors.black,fontSize: 14,
                    //fontWeight: FontWeight.bold
                  ),),
            ),
           
          ],
        ),
      ],
    ),
  );
}


Widget totalExpanseList(int index)
{
  return Container(
    
    color: Colors.white,
    width: MediaQuery.of(context).size.width,
    margin: EdgeInsets.only(left:10,right:2,top:10),
    height: 40,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 4,
              child:Text("${totalExpanseModel.result[index].date}",style: TextStyle(
                    color: Colors.black,fontSize: 14,
                    //fontWeight: FontWeight.bold
                  ),),
            ),
             Expanded(
              flex: 3,
              child:Text("${totalExpanseModel.result[index].qty}",style: TextStyle(
                    color: Colors.black,fontSize: 14,
                    //fontWeight: FontWeight.bold
                  ),),
            ),
             Expanded(
              flex: 3,
              child:Text("${totalExpanseModel.result[index].price}",style: TextStyle(
                    color: Colors.black,fontSize: 14,
                    //fontWeight: FontWeight.bold
                  ),),
            ),
            Expanded(
              flex: 1,
              child:Text("${totalExpanseModel.result[index].total}",style: TextStyle(
                    color: Colors.black,fontSize: 14,
                    //fontWeight: FontWeight.bold
                  ),),
            ),
          ],
        ),
      ],
    ),
  );
}

 Widget Buttons() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 2),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .06,
      decoration: BoxDecoration(
          color:  HexColor("#3B444B"),
          // border: Border.all(color: Colors.blueGrey, width: 1),
          // borderRadius: BorderRadius.all(Radius.circular(10))
          ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                setState(() {
                 profit=false;
                 texpanse=true;
                 saleCheck=false;
                 purchaseCheck=false;
                 expanseCheck=true;
                });
                getExpanseReport(sDate,eDate);
               // getRejectedList();
              },
              child: Container(
                width: MediaQuery.of(context).size.width * .23,
                height: MediaQuery.of(context).size.height * .06,
                decoration: BoxDecoration(
                    color:
                    texpanse==true?
                    Colors.white
                    :
                       HexColor("#3B444B") ,
                    border: Border.all(color: Colors.blueGrey, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(
                  child: Text(
                    "T.Expanse",
                    style: TextStyle(
                        color: 
                        texpanse==true?
                        HexColor("#3B444B")
                        :
                        Colors.white,
                           
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                 profit=true;
                 texpanse=false;
                });
               // getRejectedList();
              },
              child: Container(
                width: MediaQuery.of(context).size.width * .23,
                height: MediaQuery.of(context).size.height * .06,
                decoration: BoxDecoration(
                    color:
                       profit==true?
                    Colors.white
                    :
                       HexColor("#3B444B"),
                    border: Border.all(color: Colors.blueGrey, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(
                  child: Text(
                    "Profit/Loss",
                    style: TextStyle(
                         color: 
                        profit==true?
                        HexColor("#3B444B")
                        :
                        Colors.white,
                            
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
         
          ],
        ),
      ),
    );
  }

  Widget _salenPurchase() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _amountButton("Total Sales", "images/hand.png"),
          _amountButton("Purchase", "images/cart.png"),
        ],
      ),
    );
  }

  Widget _amountButton(String text, String image) {
    return GestureDetector(
      onTap: () {
      AppRoutes.push(context, SupplierHistory());
      },
      child: Container(
        height: MediaQuery.of(context).size.height * .2,
        width: MediaQuery.of(context).size.width / 2.9,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
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
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: HexColor("#77E086"), width: 6),
                shape: BoxShape.circle,
              ),
              child: Image(
                height: 32.0,
                width: 32.0,
                image: AssetImage("$image"),
              ),
            ),
            
            Text(
              "$text",
              textAlign: TextAlign.center,
              style: style.copyWith(fontSize: 16),
            ),
            text=="Total Sales"?
            Text("\$${totalSale.toString()}",
                textAlign: TextAlign.center,
                style: style.copyWith(color: HexColor("#6B8995")))

            :
            Text("\$${totalPurchase.toString()}",
                textAlign: TextAlign.center,
                style: style.copyWith(color: HexColor("#6B8995")))
          ],
        ),
      ),
    );
  }

  Widget _orderReceive(String text, String number) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Image(
              height: 30.0,
              width: 30.0,
              image: AssetImage("images/cart.png"),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              "$text",
              style: style.copyWith(fontFamily: "CaviarDreams", fontSize: 18),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 17),
              decoration: BoxDecoration(
                  color: HexColor("#D6D6D6"),
                  borderRadius: BorderRadius.circular(10)),
              height: 32.0,
              width: 32.0,
              child: Text(
                "$number",
                style: style.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: HexColor("#3B444B")),
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
      height: MediaQuery.of(context).size.height * .6,
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2)],
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(35), topLeft: Radius.circular(35))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Report Filter",
            style: TextStyle(fontSize: 18),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Select Date",
                  style: TextStyle(fontSize: 13, color: HexColor("#3B444B")),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: SizedBox(
                        child: _datePicker(),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "to",
                          textAlign: TextAlign.center,
                        )),
                    Expanded(
                      flex: 7,
                      child: SizedBox(
                        child: _datePicker(),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border.all(color: HexColor("#707070")),
                            borderRadius: BorderRadius.circular(2)),
                        child: Image(
                          color: HexColor("#3B444B"),
                          image: AssetImage("images/applyfilter.png"),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: _textField(),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: HexColor("#707070"))),
                        child: DropdownButton(
                          isDense: true,
                          isExpanded: true,
                          icon: Container(
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.arrow_drop_down),
                          ),
                          hint: Text('Reports'), // Not necessary for Option 1
                          value: _selectedCatagory,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedCatagory = newValue;
                            });
                          },
                          items: _catagory.map((catagory) {
                            return DropdownMenuItem(
                              child: new Text(catagory),
                              value: catagory,
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: BottomButton(
              name: "Search",
              ontap: () {
                setState(() {
                  bottomSheet = false;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _datePicker() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      // height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(),
      child: TextFormField(
        showCursor: false,
        autofocus: false,
        onTap: () {
          _selectDate();
        },
        readOnly: true,
        controller: _dateController,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            isDense: true,
            filled: true,
            hintText: _value,
            // labelText: "Date",
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3),
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
    if (picked != null)
      setState(() {
        _value = DateFormat("dd-MM-yyyy").format(picked).toString();
      });
  }

  Widget _textField() {
    return Container(
      height: 48,
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
      child: TextFormField(
          onFieldSubmitted: (String text) {
            print("$text");
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: HexColor("#FFFFFF"),
            hintText: "Search here",
            hintStyle: TextStyle(fontSize: 14, color: Colors.black54),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2.0),
                borderSide: BorderSide(color: HexColor("#707070"))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2.0),
                borderSide: BorderSide(width: 1, color: HexColor("#707070"))),
            prefixIcon: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Icon(Icons.search)),
          )),
    );
  }
}
