import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/utils/bottomButton.dart';
import 'package:transact/utils/grouped_orient.dart';
import 'package:transact/utils/radioButtonGroup.dart';
import 'package:transact/utils/utils.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import '../AppBar.dart';
class CreateHead extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CreateHead();
  }
  
}
class _CreateHead extends State<CreateHead>
{
  String selected="Income";
  int type=2;
    final name = TextEditingController();
ProgressDialog pr;

addHeader() async
{
  if(name.text.isEmpty )
  {
     Fluttertoast.showToast(
              msg: "Please enter the name",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
  }
  else
  {
    pr.show();
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var body={
      "Name":"${name.text.trim()}",
      "HeadType":"1",
    };
    var response = await http.post(
      "${API.addHeader}?type=1",
      headers: header,
      body: body
    );
    var Json=json.decode(response.body);
    print(Json);
    if(response.statusCode==200)
    {
      if(Json['Data']['WithError']==false)
      {
        pr.dismiss();
          Fluttertoast.showToast(
              msg: "${Json['Data']['ShortMessage']}",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
              Navigator.of(context).pop();
      }
      else
      {
        pr.dismiss();
          Fluttertoast.showToast(
              msg: "${Json['Data']['ShortMessage']}",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
      }
    }
    else
    {
      pr.dismiss();
      Fluttertoast.showToast(
              msg: "response status: ${response.statusCode}",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
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
    // TODO: implement build
    return Scaffold(
      backgroundColor: HexColor("#F5F7FA"),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: CustomeAppBar(
              homepage: false,
              title: "Head Detail",
            ),
          ),
           bottomNavigationBar: BottomButton(
            name: "Proceed",
            ontap: () {
              addHeader();
              // AppRoutes.push(context, AddExpense());
            },
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top:20),
                      width: MediaQuery.of(context).size.width*.8,
                      height: MediaQuery.of(context).size.height*.08,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color:Colors.blueGrey),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: TextField(
                        controller: name,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Name",
                        ),
                      ),                    
                      ),
                  ],
                ),
            //  Row(
            //    mainAxisAlignment: MainAxisAlignment.center,
            //    children: <Widget>[
            //       RadioButtonGroup(
            //         orientation: GroupedButtonsOrientation.HORIZONTAL,
            //         labelStyle: TextStyle(fontWeight: FontWeight.bold),
            //         activeColor: Colors.black,
            //         //picked: selected,
            //         labels: <String>[
            //           "Income",
            //           "Expense"
                      
            //         ],
            //         onSelected: (String selected) {
            //           if(selected=="Income")
            //           {
            //             setState(() {
            //               type=0;
            //             });
            //           }
            //           else
            //           {
            //             setState(() {
            //               type=1;
            //             // selling=selected;
            //             });
            //            } // print(sellingProduct);
            //             //  print(sellingService);
                      
                     
            //           print(selected);
            //         },
                    
            //         ),
               
            //    ],
            //  ),
             
              ],
            ),
          ),
    );
  }
  
}