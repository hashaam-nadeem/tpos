
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:transact/AppBar.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/Model/notificationmodel.dart';
import 'package:transact/utils/utils.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
class Notifications extends StatefulWidget {
  @override
  _Notifications createState() => _Notifications();
}

class _Notifications extends State<Notifications> {
  //////////////////////////font styles/////////////////////////
  NotificationModel notificationModel =NotificationModel();
  final RefreshController _refreshController = RefreshController();
    getNotification() async {
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.get(
      "${API.getAllNotification}",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == true) {
        Fluttertoast.showToast(
            msg: "${Json['Data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
            setState(() {
              notificationModel=NotificationModel();
            });
      } else {
        setState(() {
          notificationModel = NotificationModel.fromJson(Json['Data']);
          //User.userData.marketPlaceModel = marketPlaceModel;
        });
      }
    } else {
      Fluttertoast.showToast(
          msg: "${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }

  var style1 = TextStyle(
      fontFamily: "CaviarDreams",
      fontSize: 16,
      color: HexColor("#3B444B"),
      fontWeight: FontWeight.bold);
  var stylesmall = TextStyle(
      fontFamily: "CaviarDreams",
      fontSize: 10,
      color: HexColor("#6B6B6B"),
      fontWeight: FontWeight.bold);
  var style3 = TextStyle(
      fontFamily: "CaviarDreams",
      fontSize: 12,
      color: HexColor("#6B6B6B"),
      fontWeight: FontWeight.bold);
  //////////////////////////////////////////////////////////////

  var formattedDate = DateFormat("dd-mm-yyyy").format(DateTime.now());

  List<bool> _selection = [true,false];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotification();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: HexColor("#F5F7FA"),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: CustomeAppBar(
          title: "Notifications",
          type: 'Supplier',
          //child: _toggleButtons(),
        ),
      ),
      body: _listBuilder(),
    ));
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
                "Notification",
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
                " Reminder ",
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

  Widget _listData(int index) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
               "${notificationModel.result[index].title}",
                style: style1,
              ),
              Text(
                "${notificationModel.result[index].date}",
                style: stylesmall,
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
            child: Text(
                 "${notificationModel.result[index].message}",
              style: style3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _listBuilder() {
    
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
              onRefresh: () async {
                await Future.delayed(Duration(seconds: 1));
                getNotification();
                _refreshController.refreshCompleted();
              },
      child: ListView.builder(
        //reverse:true,
      itemCount: notificationModel.result!=null?notificationModel.result.length:0,
      itemBuilder: (context, index) {
        return _listData(index);
      }
    )
    );
}
}

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:transact/AppBar.dart';
// import 'package:transact/utils/utils.dart';
// import 'package:http/http.dart'as http;
// import 'dart:convert';
// class Notifications extends StatefulWidget {
//   @override
//   _NotificationsState createState() => _NotificationsState();
// }

// class _NotificationsState extends State<Notifications> {
//   //////////////////////////font styles/////////////////////////
//   var style1 = TextStyle(
//       fontFamily: "CaviarDreams",
//       fontSize: 16,
//       color: HexColor("#3B444B"),
//       fontWeight: FontWeight.bold);
//   var stylesmall = TextStyle(
//       fontFamily: "CaviarDreams",
//       fontSize: 10,
//       color: HexColor("#6B6B6B"),
//       fontWeight: FontWeight.bold);
//   var style3 = TextStyle(
//       fontFamily: "CaviarDreams",
//       fontSize: 12,
//       color: HexColor("#6B6B6B"),
//       fontWeight: FontWeight.bold);
//   //////////////////////////////////////////////////////////////

//   var formattedDate = DateFormat("dd-mm-yyyy").format(DateTime.now());

//   List<bool> _selection = [true,false];
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//       backgroundColor: HexColor("#F5F7FA"),
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(120),
//         child: CustomeAppBar(
//           title: "Notification",
//           type: 'Supplier',
//           child: _toggleButtons(),
//         ),
//       ),
//       body: _listBuilder(),
//     ));
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
//                 "Notification",
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
//                 " Reminder ",
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

//   Widget _listData() {
//     return Container(
//       color: Colors.white,
//       margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
//       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//       width: MediaQuery.of(context).size.width,
//       child: Column(
//         children: <Widget>[
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Text(
//                 _selection[0] ? "New Order" : "Reminder",
//                 style: style1,
//               ),
//               Text(
//                 "$formattedDate",
//                 style: stylesmall,
//               ),
//             ],
//           ),
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
//             child: Text(
//               "Lorem ipsum dolor sit amet, consectetur "
//               "adipiscing elit, sed do eiusmod tempor "
//               "incididunt ut labore et dolore magna aliqua. ",
//               style: style3,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _listBuilder() {
//     return ListView.builder(
//       itemCount: 10,
//       itemBuilder: (context, index) {
//         return _listData();
//       },
//     );
//   }
// }
