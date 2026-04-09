import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transact/AppBar.dart';
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:firebase_cloud_messaging/firebase_cloud_messaging.dart';
import 'dart:async';
import 'package:transact/Model/getauthentication.dart';

class AdminChat extends StatefulWidget {
  final String name;
  final String pic;
  final String peerid;
  final String userName;
   String type="driver";
   

  AdminChat({this.name,this.userName,this.pic,this.peerid,this.type});

  @override
  _CustomerChatBoxState createState() => _CustomerChatBoxState();
}

class _CustomerChatBoxState extends State<AdminChat> {
  final ScrollController listScrollController = new ScrollController();
  TextEditingController _controller = TextEditingController();
var token;
final String serverToken="AAAA650MzzU:APA91bGRkwiShIXSR2Yim26Eo_qG_ApsOk4F5tpPn9KPpA2KAzJquI35hNERF4UzZNJnW5lv1qme5O5c8Z_IJvb70ZGBToj4bv3OaTWWtpp5oQSJ3zTZOC6Li8g1ZMuI6V-uvcAYQtvW";
final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
getFcmToken() async
  {
    print(widget.peerid);
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.get(
      "${API.getFcm}?UserId=${widget.peerid}",
      headers: header,
    );
    var Json=json.decode(response.body);
    print(Json);
    if(response.statusCode==200)
    {
      if(Json['Data']['WithError']==false)
      {
        if(Json['Data']['Result']!=null)
        {
          setState(() {
            token=Json['Data']['Result'];
          });
          print(token);
        }
      }
    }
  }
  
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFcmToken();
  }

Future<Map<String, dynamic>> sendAndRetrieveMessage() async {
    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );

    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': '${_controller.text.trim()}',
            'title': '${User.userData.userResult.fullname}'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': token,
        },
      ),
    );

    final Completer<Map<String, dynamic>> completer =
    Completer<Map<String, dynamic>>();

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );
    return completer.future;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: CustomeAppBar(
              title: "${widget.name}",
              homepage: false,
            ),
          ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('Chat')
                    .document(User.userData.userResult.id)
                    .collection("chat_with")
                    .document(widget.peerid)
                    .collection("chats").orderBy("timestamp", descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        controller: listScrollController,
                        itemCount: snapshot.data == null
                            ? 0
                            : snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          return snapshot.data.documents[index]["id_from"] ==
                              User.userData.userResult.id
                              ? chatbox(
                              1, index, snapshot.data.documents[index],snapshot)
                              : chatbox(
                              2, index, snapshot.data.documents[index],snapshot);
                        });
                  }
                }),
            //height: MediaQuery.of(context).size.height/1.7,
          ),
          inputtext(),
        ],
      ),
    );
  }

  Widget inputtext() {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
// shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23),
      decoration: BoxDecoration(
        //color: Colors.green,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: Colors.white)),
            width: MediaQuery
                .of(context)
                .size
                .width / 1.2,
            child: TextFormField(
              controller: _controller,
              maxLines: 6,
              minLines: 1,
              showCursor:true  ,
              maxLengthEnforced: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none),
                hintText: 'Write something',
                contentPadding: EdgeInsets.only(left: 10),
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),

          IconButton(
            onPressed: () {
              sendMessage();
            },
            icon: Image.asset(
              'images/send.png',
              scale: 5,
            ),
          )
        ],

      ),
    );
  }



  sendMessage() {
    if (_controller.text.isNotEmpty) {
      String message = _controller.text;
      sendAndRetrieveMessage();
      _controller.clear();
      listScrollController.animateTo(listScrollController.position.maxScrollExtent,curve: Curves.easeOut, duration: Duration(milliseconds:200 ));
      //FocusScope.of(context).unfocus();
      int timeStamp = DateTime.now().millisecondsSinceEpoch;
      Firestore.instance.collection("ChatInbox").document(User.userData.userResult.id).collection("chat_user").document(widget.peerid).setData({
        "chat_with": widget.peerid,
        "timestamp": timeStamp,
        "type": "${widget.type}",
        "userName":"${widget.userName}",
        "pic": widget.pic,
        "last_message": "$message",
        "name": widget.userName
      });
      Firestore.instance.collection("ChatInbox").document(widget.peerid).collection("chat_user").document(User.userData.userResult.id).setData({
        "chat_with": User.userData.userResult.id,
        "timestamp": timeStamp,
        "type": "admin",
        "pic": User.userData.userResult.imageUrl,
        "last_message": "$message",
        "name": "${widget.userName}"
      });
      var timestamp = DateTime
          .now()
          .millisecondsSinceEpoch;
      Firestore.instance
          .collection("Chat")
          .document(widget.peerid)
          .collection("chat_with")
          .document(User.userData.userResult.id)
          .collection("chats")
          .document(timestamp.toString())
          .setData({
        "id_from": "${User.userData.userResult.id}",
        "id_to": "${widget.peerid}",
        "message": message,
        "timestamp": "$timestamp",
        "seen": false,
      }).whenComplete(() {});
      Firestore.instance
          .collection("Chat")
          .document(User.userData.userResult.id)
          .collection("chat_with")
          .document(widget.peerid)
          .collection("chats")
          .document(timestamp.toString())
          .setData({
        "id_from": "${User.userData.userResult.id}",
        "id_to": "${widget.peerid}",
        "message": message,
        "timestamp": "$timestamp",
        "seen": false,
      }).whenComplete(() {
        listScrollController.animateTo(listScrollController.position.maxScrollExtent,curve: Curves.easeOut, duration: Duration(milliseconds:200 ));
      });
    }
  }

  Widget chatbox(int val, int index, DocumentSnapshot snapshot,value) {
    return Row(
      mainAxisAlignment: val==1?MainAxisAlignment.end:MainAxisAlignment.start,
      children: <Widget>[
        val==2?index==0?Padding(
          padding: const EdgeInsets.only(left: 20,right: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              "${API.API_URL}${widget.pic}",height: 40,width: 40,
              fit: BoxFit.cover,
            ),
          ),
        ):value.data.documents[index-1]["id_from"]==User.userData.userResult.id?Padding(
          padding: const EdgeInsets.only(left: 20,right: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              "${widget.pic}",height: 40,width: 40,
              fit: BoxFit.cover,
            ),
          ),
        ):Padding(
          padding: const EdgeInsets.only(left: 20,right: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 40,width: 40,
            ),
          ),
        ):Container(),
        Flexible(
          child: Bubble(
            nip: val==1?BubbleNip.rightTop:BubbleNip.no,
            margin: BubbleEdges.only(left: val==1?MediaQuery.of(context).size.width/3.5:0,top: 10,right: val==2?MediaQuery.of(context).size.width/3.5:10),
            color: val==1?Colors.black:Colors.grey[200],
            child:  Padding(
              padding: const EdgeInsets.all(5),
              child: Text('${snapshot["message"]}', textAlign: val==1?TextAlign.left:TextAlign.left,style: TextStyle(color: val==1?Colors.white:Colors.grey[600],fontSize: 16),),
            ),



          ),
        )
      ],
    );


  }
}
