import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:transact/AppBar.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/Model/journalmodel.dart';
import 'package:transact/Supplier/addExpesnse.dart';

import 'package:transact/utils/bottomButton.dart';
import 'package:transact/utils/datetimepicker.dart';
import 'package:transact/utils/routes.dart';
import 'package:transact/utils/utils.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
class Expenses extends StatefulWidget {
  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final format = DateFormat("yyyy-MM-dd HH:mm");
  final RefreshController _refreshController = RefreshController();
  var style = TextStyle(
      fontFamily: "CaviarDreams", fontSize: 18, fontWeight: FontWeight.bold);
  var formattedDateTime =
      DateFormat("dd-MM-yyyy  hh:mm a").format(DateTime.now());
      JournalModel journalModel=JournalModel();
      DateTime sDate;
      String day,month,year;
      getExpanses()async
      {
          var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.get(
      "${API.getGeneral}?type=1",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if(response.statusCode==200)
    {
      if(Json['Data']['WithError']==false)
      {
        setState(() {
          journalModel=JournalModel.fromJson(Json['Data']);
        });
        for(int i=0;i<journalModel.result.length;i++)
        {
          dateFunc(journalModel.result[i].date,i);
        }
      }
      else
      {
         Fluttertoast.showToast(
              msg: "${Json['Data']['ShortMessage']}",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
      }
    }
    else
    {
       Fluttertoast.showToast(
              msg: "response status: ${response.statusCode}",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
    }
      }
    
      @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getExpanses();
  }

  dateFunc(String date, int index) {
    String r1 = date.replaceAll('/', '');
    String r2 = r1.replaceAll('Date', '');
    String r3 = r2.replaceAll('(', '');
    String r4 = r3.replaceAll(')', '');
    int r5 = int.parse(r4);
    print(r5);
    var da = DateTime.fromMillisecondsSinceEpoch(r5);
    setState(() {
      day = da.day.toString();
      month = da.month.toString();
      year = da.year.toString();
    });
    print(da.minute);
    setState(() {
      journalModel.result[index].date =
          "$day/$month/$year";
    });
//    DateTime d = DateTime.parse(int.parse(r4).toDate());
//     print(dat.toString());
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: HexColor("#F5F7FA"),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: CustomeAppBar(
              homepage: false,
              title: "Expenses",
            ),
          ),
          bottomNavigationBar: BottomButton(
            name: "+ ADD NEW EXPENSE",
            ontap: () {
              AppRoutes.push(context, AddExpense());
            },
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                //_datePicker(),
                Expanded(
                  child:  Container(
                  //height: MediaQuery.of(context).size.height,
                  child: 
                  SmartRefresher(
                    controller: _refreshController,
                    onRefresh: ()async
                    {
                        await Future.delayed(Duration(seconds: 2));
                        getExpanses();
                        _refreshController.refreshCompleted();
                    },
                    child:
                  _expenseCardList())
                )
                ),
              ],
            ),
          )),
    );
  }

  Widget _expenseCardList() {
    return ListView.builder(
      itemCount: journalModel.result!=null?journalModel.result.length:0,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(index.toString()),
          child:_expensCard(index)
        );
      },
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
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: <Widget>[
              Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 5, bottom: 5, top: 2),
            child: Text(
              "${journalModel.result[index].name}",
              style: style,
            ),
          ),

          Text(
              "${journalModel.result[index].date}",
              style: style,
            ),
           ],
         ),
          Container(
            margin: EdgeInsets.only(left: 5, bottom: 5, top: 1),
            child: Row(
              children: <Widget>[
                // Image(
                  
                //   image: AssetImage("images/blankImage1.png"),
                // ),
                journalModel.result[index].imageUrl==null?
                Image.asset("images/blankImage1.png",
                height: MediaQuery.of(context).size.height * .065,
                  width: MediaQuery.of(context).size.width / 5,)
                :
                Image.network("${API.API_URL}${journalModel.result[index].imageUrl}",
                
                height: MediaQuery.of(context).size.height * .065,
                  width: MediaQuery.of(context).size.width / 5,
                ),
                SizedBox(
                  width: 3,
                ),
               Flexible(
                 child:  Text(
                  "${ journalModel.result[index].summary}",
                  style: style.copyWith(fontSize: 12),
                ),
               ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              "\$${ journalModel.result[index].total}",
              style: style,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "${ journalModel.result[index].num}",
              style: style,
            ),
          ),
        ],
      ),
    );
  }

  Widget _datePicker() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10.0, left: 10, right: 10),
      child: DateTimeField(
        decoration: InputDecoration(
            hintText: "Select Date and Time",
            fillColor: Colors.white,
            filled: true,
            isDense: true,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        format: format,
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            return DateTimeField.combine(date, time);
          } else {
            return currentValue;
          }
        },
      ),
    );
  }
}
