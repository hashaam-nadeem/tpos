import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:transact/AppBar.dart';
import 'package:http/http.dart'as http;
import 'package:transact/Model/apismodel.dart';
import 'dart:convert';

import 'package:transact/Model/getauthentication.dart';
import 'package:transact/Model/totalexpansemodel.dart';
class ExpenseDetail extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ExpenseDetail();
  }
  
}
class _ExpenseDetail extends State<ExpenseDetail>
{
ProgressDialog pr;
double total=0.0;
DateTime sDate=DateTime.now(),eDate=DateTime.now();
DateTime currentDate = DateTime.now();
TotalExpanseModel totalExpanseModel=TotalExpanseModel();
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
    setState(() {
          total=0.0;
        });
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
          //expanseCheck=true;
        });
         for(int i=0;i<totalExpanseModel.result.length;i++)
        {
          setState(() {
            total=total+totalExpanseModel.result[i].total;
          });
        }
      } else {
        pr.dismiss();
        setState(() {
          total=0.0;
        });
        Fluttertoast.showToast(
            msg: "${Json['data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);

        setState(() {
          totalExpanseModel = TotalExpanseModel();
        //  expanseCheck=false;
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

  getReport(
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
    setState(() {
          total=0.0;
        });
    //pr.show();
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
      //  pr.dismiss();
        setState(() {
          totalExpanseModel = TotalExpanseModel.fromJson(Json['Data']);
          //expanseCheck=true;
        });
        for(int i=0;i<totalExpanseModel.result.length;i++)
        {
          setState(() {
            total=total+totalExpanseModel.result[i].total;
          });
        }
      } else {
        //pr.dismiss();
        setState(() {
          total=0.0;
        });
        Fluttertoast.showToast(
            msg: "${Json['data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);

        setState(() {
          totalExpanseModel = TotalExpanseModel();
        //  expanseCheck=false;
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

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getReport(sDate,eDate);
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
    // TODO: implement build
    return Scaffold(
     appBar: PreferredSize(
            preferredSize: Size.fromHeight(120),
            child: CustomeAppBar(
              homepage: false,
              title: "Expense Detail",
              
            ),
          ),
          bottomNavigationBar: totalPrice(),
         body: Container(
           width: MediaQuery.of(context).size.width,
           height: MediaQuery.of(context).size.height,
           child: Column(
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
                                getExpanseReport(sDate,
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
             
             Padding(
                padding: EdgeInsets.only(left:14,right:8),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Date",style: TextStyle(
                    color: Colors.black,fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),),
                  Text("      Quantity",style: TextStyle(
                    color: Colors.black,fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),),
                   Text("Price",style: TextStyle(
                    color: Colors.black,fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),),
                   Text("Total ",style: TextStyle(
                    color: Colors.black,fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),),
                ],
              ),
              ),


             Expanded(
                child: ListView.builder(itemBuilder: (BuildContext context,int index)
                {
                  return 
              
                  totalExpanseList(index);
                },
                itemCount: 
                totalExpanseModel.result!=null?totalExpanseModel.result.length:0,
                ),
              ),
              
             ],
           ),
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
              flex: 4,
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
              flex: 2,
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
 Widget totalPrice()
 {
   return Container(
     width: MediaQuery.of(context).size.width,
     height: MediaQuery.of(context).size.height*.06,
     child: Center(
       child: Padding(
         padding: EdgeInsets.only(left:10,right:10),
         child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: <Widget>[
         Text("Total",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
            Text("\$ $total",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),

         ],
       ),
       ),
     ),
   );
 }
}