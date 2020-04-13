import 'package:flutter/material.dart';
import 'package:transact/AppBar.dart';
import 'package:transact/Supplier/Messages.dart';
import 'package:transact/utils/routes.dart';
import 'package:transact/utils/utils.dart';

class BuyerConversation extends StatefulWidget {
  @override
  _BuyerConversationState createState() => _BuyerConversationState();
}

class _BuyerConversationState extends State<BuyerConversation> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("#F5F7FA"),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: CustomeAppBar(
            title: "Conversation",
            type: 'Supplier',
          ),
        ),
        body: SafeArea(
            child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: 10,
          itemBuilder: (BuildContext cntext, int index) {
            return _chatThread();
          },
        )),
      ),
    );
  }

  Widget _chatThread() {
    return GestureDetector(
      onTap: () {
        AppRoutes.push(context, ChatPage());
      },
      child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          margin: EdgeInsets.only(bottom: 5),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  child: CircleAvatar(
                    child: Center(
                      child: Image.asset('images/dp.png'),
                    ),
                    radius: 25,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("jane jallow",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: HexColor("#3B444B"),
                                )),
                            Row(
                              children: <Widget>[
                                Text('10:45',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: HexColor("#8B8B8B"),
                                    )),
                                GestureDetector(
                                  onTap: () {},
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: HexColor("#8B8B8B"),
                                    size: 18,
                                  ),
                                )
                              ],
                            )
                          ],
                        )),
                    Container(
                      margin: EdgeInsets.all(5),
                      child:
                          Text("You're one of peter's compressions plays, huh?",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 13,
                                color: HexColor("#8B8B8B"),
                              )),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
