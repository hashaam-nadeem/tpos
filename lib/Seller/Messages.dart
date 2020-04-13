import 'package:flutter/material.dart';
import 'dart:math';

import 'package:transact/AppBar.dart';

class ChatPage extends StatefulWidget {
  static final String path = "lib/src/pages/misc/chat2.dart";
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String text;
  TextEditingController _controller;
  final List<String> avatars = [];
  final List<Message> messages = [
    Message(0, "But I may not go if the weather is bad."),
    Message(0, "I suppose I am."),
    Message(1, "Are you going to market today?"),
    Message(0, "I am good too"),
    Message(1, "I am fine, thank you. How are you?"),
    Message(1, "Hi,"),
    Message(0, "How are you today?"),
    Message(0, "Hello,"),
  ];
  final rand = Random();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: CustomeAppBar(
            title: "John Doe",
            type: 'Supplier',
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10.0);
                },
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  Message m = messages[index];
                  if (m.user == 0) return _buildMessageRow(m, current: true);
                  return _buildMessageRow(m, current: false);
                },
              ),
            ),
            _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  Container _buildBottomBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
        // horizontal: 16.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        //borderRadius: BorderRadius.circular(30.0),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 20.0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                print("Works");
              },
              child: Image(
                height: 30,
                width: 30,
                image: AssetImage("images/plus.png"),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: TextField(
              textInputAction: TextInputAction.send,
              controller: _controller,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 20.0,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  hintText: "Aa"),
              onEditingComplete: _save,
            ),
          ),
          IconButton(
            icon: Image(
              height: 30,
              width: 30,
              image: AssetImage("images/send.png"),
            ),
            color: Theme.of(context).primaryColor,
            onPressed: _save,
          )
        ],
      ),
    );
  }

  _save() async {
    if (_controller.text.isEmpty) return;
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      messages.insert(0, Message(rand.nextInt(2), _controller.text));
      _controller.clear();
    });
  }

  Row _buildMessageRow(Message message, {bool current}) {
    return Row(
      mainAxisAlignment:
          current ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment:
          current ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: current ? 30.0 : 20.0),
        const SizedBox(width: 5.0),
        !current
            ? CircleAvatar(
                backgroundImage: AssetImage(
                  current ? "images/dp.png" : "images/dp.png",
                ),
                radius: 15.0,
              )
            : Container(),
        const SizedBox(width: 5.0),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16.0,
          ),
          decoration: BoxDecoration(
              color:
                  current ? Theme.of(context).primaryColor : Colors.grey[200],
              borderRadius: BorderRadius.circular(10.0)),
          child: Text(
            message.description,
            style: TextStyle(
                color: current ? Colors.white : Colors.black, fontSize: 14.0),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        current
            ? CircleAvatar(
                backgroundImage: AssetImage(
                  current ? "images/dp.png" : "images/dp.png",
                ),
                radius: 15.0,
              )
            : Container(),
        SizedBox(width: current ? 20.0 : 30.0),
      ],
    );
  }
}

class Message {
  final int user;
  final String description;

  Message(this.user, this.description);
}
