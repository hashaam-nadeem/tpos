import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/Model/headersmodel.dart';
import 'package:transact/utils/bottomButton.dart';
import 'package:transact/utils/fonts.dart';
import 'package:transact/utils/routes.dart';
import 'package:transact/utils/utils.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import '../AppBar.dart';
import 'addhead.dart';
class HeadDetail extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HeadDetail();
  }
  
}
class _HeadDetail extends State<HeadDetail>
{

   final RefreshController _refreshController = RefreshController();
HeadersModel headersModel=HeadersModel();
bool type=false;
ProgressDialog pr;
//final RefreshController _refreshController = RefreshController();

   getExpenseHeaders() async {
    // pr.show();
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.get(
      "${API.HeadList}?type=1",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      //pr.dismiss();
      if (Json['Data']['WithError'] == false) {
        setState(() {
          headersModel = HeadersModel.fromJson(Json['Data']);
        });
       
      } else {
        //pr.dismiss();
        Fluttertoast.showToast(
            msg: "${Json['data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      }
    } else {
      //pr.dismiss();
      Fluttertoast.showToast(
          msg: "${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }
 getIncomeHeaders() async {
   pr.show();
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.get(
      "${API.HeadList}?type=1",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      pr.dismiss();
      if (Json['Data']['WithError'] == false) {
        setState(() {
          headersModel = HeadersModel.fromJson(Json['Data']);
        });
       
      } else {
        pr.dismiss();
        Fluttertoast.showToast(
            msg: "${Json['data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      }
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
    getExpenseHeaders();
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
            name: "+ ADD NEW HEAD",
            ontap: () {
               AppRoutes.push(context, CreateHead());
            },
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
              //  Row(
              //    mainAxisAlignment: MainAxisAlignment.center,
              //    children: <Widget>[
              //       Container(
              //     width: MediaQuery.of(context).size.width*.5,
              //     height: MediaQuery.of(context).size.height*.08,
              //      decoration: BoxDecoration(
              //           color: Colors.white,
              //           border: Border.all(color:Colors.blueGrey),
              //           borderRadius: BorderRadius.all(Radius.circular(10))
              //         ),
              //         child: Center(
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //             children: <Widget>[
              //              GestureDetector(
              //                onTap: ()
              //                {
              //                  getIncomeHeaders();
              //                   setState(() {
              //                    type=!type;
              //                  });
              //                },
              //                child:  Container(
              //                 width: MediaQuery.of(context).size.width*.2,
              //                 height: MediaQuery.of(context).size.height*.06,
              //                  decoration: BoxDecoration(
              //           color: type==true?
              //           Colors.white
              //           :HexColor("#3B444B"),
              //           border: Border.all(color:Colors.blueGrey),
              //           borderRadius: BorderRadius.all(Radius.circular(10))
              //         ),
              //         child: Center(
              //           child: Text("Expense",style: TextStyle(color: type==true?
              //           HexColor("#3B444B")
              //           :Colors.white,fontSize: 14),),
              //         ),
              //               ),
              //              ),
              //              GestureDetector(
              //                onTap: ()
              //                {
              //                  getExpenseHeaders();
              //                  setState(() {
              //                    type=!type;
              //                  });
              //                },
              //                child:  Container(
              //                 width: MediaQuery.of(context).size.width*.2,
              //                 height: MediaQuery.of(context).size.height*.06,
              //                  decoration: BoxDecoration(
              //           color: type==false?Colors.white:HexColor("#3B444B"),
              //           border: Border.all(color:Colors.blueGrey),
              //           borderRadius: BorderRadius.all(Radius.circular(10))
              //         ),
              //         child: Center(
              //           child: Text("Income",style: TextStyle(color: type==false?
              //           HexColor("#3B444B")
              //           :Colors.white,fontSize: 14),),
              //         ),
              //               ),
              //              ),
                          
              //             ],
              //           ),
              //         ),
              //   ),
                
              //    ],
              //  ),
               
                Expanded(
                  child: _expenseCardList()
                ),
              ],
            ),
          ),
    );
  }
  Widget _expenseCardList() {
    return 
    SmartRefresher(
      child: ListView.builder(
      itemCount:headersModel.result!=null?headersModel.result.length:0,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(index.toString()),
          child:_expensCard(index)
        );
      },
    ),
    onRefresh: ()async
    {
       await Future.delayed(Duration(seconds: 1));
              getExpenseHeaders();
              _refreshController.refreshCompleted();
    },
      controller: _refreshController,
    );
  }

 Widget _expensCard(int index) {
    return Container(
     // margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.grey[200],
          blurRadius: 5,
        )
      ]),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 5, bottom: 5, top: 2),
            child: Text(
              "${headersModel.result[index].name}",
              style: style,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 5, bottom: 5, top: 1),
            child: Row(
              children: <Widget>[
                // Image(

                //   image: AssetImage("images/blankImage1.png"),
                // ),
                // journalModel.result[index].imageUrl==null?
                // Image.asset("images/blankImage1.png",
                // height: MediaQuery.of(context).size.height * .065,
                //   width: MediaQuery.of(context).size.width / 5,)
                // :
                // Image.network("${API.API_URL}${journalModel.result[index].imageUrl}",
                
                // height: MediaQuery.of(context).size.height * .065,
                //   width: MediaQuery.of(context).size.width / 5,
                // ),
                SizedBox(
                  width: 3,
                ),
                headersModel.result[index].type==1?
                Text(
                  "Expanse",
                  style: style.copyWith(fontSize: 12),
                )
                :
                Text(
                  "Expense",
                  style: style.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomRight,
          //   child: Text(
          //     "\$${ journalModel.result[index].price}",
          //     style: style,
          //   ),
          // )
        ],
      ),
    );
  }

}