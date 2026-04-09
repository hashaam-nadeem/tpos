

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transact/AppBar.dart';
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/utils/admin_chat.dart';
import 'package:transact/utils/routes.dart';
import 'package:transact/utils/utils.dart';



List<String> monthList = ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];
class Conversation extends StatefulWidget {
  @override
  _CustomerChatInboxState createState() => _CustomerChatInboxState();
}

class _CustomerChatInboxState extends State<Conversation> {
  int pageselect = 1;
  TextEditingController controller = new TextEditingController();
  String search = "";
  List<String> customers = [];
  List<String> driverList = [];


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
    new GlobalKey<ScaffoldState>();
    return Scaffold(
      //key: _scaffoldKey,
      // drawer: DrawerPage(context),
      appBar:  PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: CustomeAppBar(
            title: "Conversation",
            type: 'Supplier',
            homepage: false,
          ),
        ),
      body: Container(
        child: Column(
          children: <Widget>[
            // upperCard(),
            Expanded(
              child: search.isNotEmpty&&pageselect==1? searchDriverList() : pageselect ==1&&search.isEmpty?driverInboxList():pageselect==2&&search.isEmpty?adminInboxList():search.isNotEmpty&&pageselect==2?searchCustomerList():Container(),
            )
          ],
        ),
      ),
    );
  }

  Widget driverInboxList() {
    return Container(
        margin: EdgeInsets.only(bottom: 20),
        child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('ChatInbox').document(User.userData.userResult.id).collection("chat_user")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return snapshot?.data?.documents?.isEmpty??true?Center(child: Text("No Chat",style: TextStyle(color: Colors.black,fontSize: 20,letterSpacing: 2,fontWeight: FontWeight.bold),),):ListView.builder(
                    itemCount: snapshot.data.documents.isEmpty
                        ? 0 : snapshot.data.documents.length, itemBuilder: (BuildContext context, int index) =>
                    cardDriver(index,snapshot.data.documents[index]));
              }
            }));
  }
  Widget adminInboxList() {
    return Container(
        margin: EdgeInsets.only(bottom: 20),
        child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('ChatInbox').document(User.userData.userResult.id).collection("chat_user")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              else {
                return snapshot.data.documents.isEmpty?Center(child: Text("No Chat",style: TextStyle(color: Colors.black,fontSize: 20,letterSpacing: 2,fontWeight: FontWeight.bold),),):ListView.builder(
                    itemCount: snapshot.data.documents.isEmpty 
                        ? 0 : snapshot.data.documents.length, itemBuilder: (BuildContext context, int index) =>
                    cardCustomer(index,snapshot.data.documents[index]));
              }
            }));
  }



  Widget searchDriverList() {
    print(search);
    return Container(
        margin: EdgeInsets.only(bottom: 20),
        child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('Drivers')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<dynamic> data = snapshot.data.documents;

                return ListView.builder(
                    itemCount: snapshot.data==null ? 0 :  data.length??0,
                    itemBuilder: (BuildContext context, int index) {
                      return data[index]["name"].toString().toLowerCase().contains(search.toLowerCase())?driverCard(index, data[index]):Container();
                    });
              }
            }));
  }
  Widget searchCustomerList() {
    print(search);
    return Container(
        margin: EdgeInsets.only(bottom: 20),
        child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('Customers')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<dynamic> data = snapshot.data.documents;

                return ListView.builder(
                    itemCount: snapshot.data==null ? 0 :  data.length??0,
                    itemBuilder: (BuildContext context, int index) {
                      return data[index]["name"].toString().toLowerCase().contains(search.toLowerCase())?driverCard(index, data[index]):Container();
                    });
              }
            }));
  }

  Widget upperCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 7,
      child: Container(
        height: 150,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            // Container(
            //   height: 50,
            //   width: MediaQuery.of(context).size.width / 1.4,
            //   child: CardNavigation(
            //       title1: "Driver",
            //       title2: "Customer",
            //       onPressed: (int val) {
            //         setState(() {
            //           this.pageselect = val;
            //         });
            //       }),
            // ),
            SizedBox(
              height: 10,
            ),
            Container(
                height: 60,
                width: MediaQuery.of(context).size.width / 1.4,
                child: Card(
                  child: new ListTile(
                    leading: new Icon(Icons.search,color: Colors.black,),
                    title: new TextField(
                      controller: controller,
                      decoration: new InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color:Colors.black)

                      ),
                      onChanged: (value){
                        setState(() {
                          search=value;
                        });
                      },
                    ),
                    trailing:  search.isNotEmpty? new IconButton(icon: new Icon(Icons.cancel,color: Colors.black,), onPressed: () {
                      controller.clear();
                      onSearchTextChanged('');
                    },):Icon(null),
                  ),
                )),
          ],
        ),
      ),

      // color: Colors.purple,
    );
  }

  onSearchTextChanged(String text) async {
    if (text.isEmpty) {
      setState(() {
        search = text;
      });
    }
  }

  Widget cardDriver(int index,DocumentSnapshot snapshot) {
    return InkWell(
      onTap: () {
        AppRoutes.push(context, AdminChat(peerid: snapshot["chat_with"],pic: snapshot["pic"],name: snapshot["name"],type: "admin",));
      },
      child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.5,color: Colors.grey[300]),
              )
          ),
          padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
          child: Container(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "${DateTime.fromMillisecondsSinceEpoch(snapshot["timestamp"]??1000000).day}-${monthList[DateTime.fromMillisecondsSinceEpoch(snapshot["timestamp"]??1000000).month-1]}-${DateTime.fromMillisecondsSinceEpoch(snapshot["timestamp"]??1000000).year}",
                      style: TextStyle(color: Colors.black,fontSize: 15),),
                    Text(
                      "   ${DateTime.fromMillisecondsSinceEpoch(snapshot["timestamp"]??1000000).hour}:${DateTime.fromMillisecondsSinceEpoch(snapshot["timestamp"]??1000000).minute}",
                      style: TextStyle(color: Colors.grey,fontSize: 15),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 20),
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          //  color: Colors.yellow,
                            borderRadius: BorderRadius.all(Radius.circular(30))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child:  Image.network(
                            '${API.API_URL}${snapshot["pic"]}',
                            fit: BoxFit.cover,
                          ),
                        )),
                    Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '${snapshot["name"].toString()[0].toUpperCase()}${snapshot["name"].toString().substring(1)}',
                                  style: TextStyle(
                                      letterSpacing: 1.2,
                                      color: HexColor("#3B444B"),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width/1.5,
                                  child: Text('${snapshot["last_message"]}',
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),


                              ],
                            ),

                          ],
                        )),
                  ],
                ),
              ],
            ),
          )),
    );
  }
  Widget cardCustomer(int index,DocumentSnapshot snapshot) {
    return InkWell(
      onTap: () {
        AppRoutes.push(context, AdminChat(peerid: snapshot["chat_with"],pic: snapshot["pic"],name: snapshot["name"],type: "customer",));
      },
      child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.5,color: Colors.grey[300]),
              )
          ),
          padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
          child: Container(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "${DateTime.fromMillisecondsSinceEpoch(snapshot["timestamp"]??1000000).day}-${monthList[DateTime.fromMillisecondsSinceEpoch(snapshot["timestamp"]??1000000).month-1]}-${DateTime.fromMillisecondsSinceEpoch(snapshot["timestamp"]??1000000).year}",
                      style: TextStyle(color: Colors.black,fontSize: 15),),
                    Text(
                      "   ${DateTime.fromMillisecondsSinceEpoch(snapshot["timestamp"]??1000000).hour}:${DateTime.fromMillisecondsSinceEpoch(snapshot["timestamp"]??1000000).minute}",
                      style: TextStyle(color: Colors.grey,fontSize: 15),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 20),
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          //  color: Colors.yellow,
                            borderRadius: BorderRadius.all(Radius.circular(30))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child:  Image.network(
                            '${snapshot["pic"]}',
                            fit: BoxFit.cover,
                          ),
                        )),
                    Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '${snapshot["name"].toString()[0].toUpperCase()}${snapshot["name"].toString().substring(1)}',
                                  style: TextStyle(
                                      letterSpacing: 1.2,
                                      color: Colors.green,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width/1.5,
                                  child: Text('${snapshot["last_message"]}',
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),


                              ],
                            ),

                          ],
                        )),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Widget driverCard(int index, var snapshot) {
    return InkWell(
      onTap: () {
        AppRoutes.push(context, AdminChat(peerid: snapshot["driver_id"],pic: snapshot["profile_image"],name: snapshot["name"],type:"driver",));
      },
      child: Card(
          child: Container(
            height: 70,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      //  color: Colors.yellow,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Image.network(
                          "${API.API_URL}${snapshot["profile_image"]}",
                          fit: BoxFit.cover,
                        ))),
                Container(
                    margin: EdgeInsets.only(left: 10),
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '${snapshot["name"]}',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                      ],
                    )),
              ],
            ),
          )),
    );
  }
  Widget customerCard(int index, var snapshot) {
    return InkWell(
      onTap: () {
        AppRoutes.push(context, AdminChat(peerid: snapshot["driver_id"],pic: snapshot["profile_image"],name: snapshot["name"],type:"admin",));
      },
      child: Card(
          child: Container(
            height: 70,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      //  color: Colors.yellow,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Image.network(
                          "${snapshot["profile_image"]}",
                          fit: BoxFit.cover,
                        ))),
                Container(
                    margin: EdgeInsets.only(left: 10),
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '${snapshot["name"]}',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                      ],
                    )),
              ],
            ),
          )),
    );
  }


}


// import 'package:flutter/material.dart';
// import 'package:transact/AppBar.dart';
// import 'package:transact/Supplier/Messages.dart';
// import 'package:transact/utils/routes.dart';
// import 'package:transact/utils/utils.dart';

// class Conversation extends StatefulWidget {
//   @override
//   _ConversationState createState() => _ConversationState();
// }

// class _ConversationState extends State<Conversation> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: HexColor("#F5F7FA"),
//         appBar: PreferredSize(
//           preferredSize: Size.fromHeight(70),
//           child: CustomeAppBar(
//             title: "Conversation",
//             type: 'Supplier',
//           ),
//         ),
//         body: SafeArea(
//             child:  ListView.builder(
//               physics: BouncingScrollPhysics(),
//             itemCount:10,
//             itemBuilder:(BuildContext cntext,int index){
//               return _chatThread();
            
           
//           },
//         )),
//       ),
//     );
//   }

//   Widget _chatThread() {
//     return GestureDetector(
//       onTap: (){
//         AppRoutes.push(context, ChatPage());
//       },
//           child: Container(
//           width: MediaQuery.of(context).size.width,
//           color: Colors.white,
//           margin: EdgeInsets.only(bottom: 5),
//           padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//           child: Row(
//             children: <Widget>[
//               Expanded(
//                 flex: 1,
//                 child: Container(
//                   child: CircleAvatar(
//                     child: Center(
//                       child: Image.asset('images/dp.png'),
//                     ),
//                     radius: 25,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 4,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Container(
//                         margin: EdgeInsets.all(5),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: <Widget>[
//                             Text("jane jallow",
//                                 textAlign: TextAlign.start,
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: HexColor("#3B444B"),
//                                 )),
//                             Row(
//                               children: <Widget>[
//                                 Text('10:45',
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       color: HexColor("#8B8B8B"),
//                                     )),
//                                 GestureDetector(
//                                   onTap: () {},
//                                   child: Icon(
//                                     Icons.arrow_forward_ios,
//                                     color: HexColor("#8B8B8B"),
//                                     size: 18,
//                                   ),
//                                 )
//                               ],
//                             )
//                           ],
//                         )),
//                     Container(
//                       margin: EdgeInsets.all(5),
//                       child:
//                           Text("You're one of peter's compressions plays, huh?",
//                               textAlign: TextAlign.start,
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: HexColor("#8B8B8B"),
//                               )),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           )),
//     );
//   }
// }
