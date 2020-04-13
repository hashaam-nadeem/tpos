import 'package:flutter/material.dart';
import 'package:transact/AppBar.dart';
import 'package:transact/Supplier/conversation.dart';
import 'package:transact/utils/bottomButton.dart';
import 'package:transact/utils/routes.dart';

import 'package:transact/utils/utils.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  TextEditingController _emailController;
  TextEditingController _descriptionController;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: CustomeAppBar(
            title: "Contact Us",
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _contactUsText(),
              _contactDetails(),
              _sendMessgeSection(),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                width: MediaQuery.of(context).size.width / 2,
                child: BottomButton(
                  name: "Send Message",
                  ontap: () {},
                ),
              ),
              _title("OR"),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                width: MediaQuery.of(context).size.width / 2,
                child: BottomButton(
                  name: "Live Chat",
                  ontap: () {
                    AppRoutes.push(context, Conversation());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contactUsText() {
    return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
        width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context,).size.height*.25,
        color: Colors.white,
        child: Text(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n\n Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
          style: TextStyle(
              color: HexColor('#6B6B6B'),
              fontSize: 12,
              fontWeight: FontWeight.bold),
        ));
  }

  Widget _textFormField(String text, TextAlign align, int maxlin) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: TextFormField(
        controller:
            text == "Your Email" ? _emailController : _descriptionController,
        keyboardType: TextInputType.multiline,
        textAlign: align,
        maxLines: maxlin,
        decoration: InputDecoration(
            isDense: true,
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            hintText: "$text",
            hintStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }

  Widget _title(String text) {
    return Container(
      child: Text("$text",
          style: TextStyle(
              color: HexColor("#000000"),
              fontFamily: 'Roboto',
              fontSize: 15,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget _title2(String text) {
    return Container(
      margin: EdgeInsets.only(top: 5, left: 5),
      child: Text("$text",
          style: TextStyle(
              color: HexColor("#6B6B6B"),
              fontFamily: 'Roboto',
              fontSize: 12,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget _contactDetails() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _title("Email"),
          _title2(
            "John Doe",
          ),
          _title("Phone #"),
          _title2("+912343565788"),
        ],
      ),
    );
  }

  Widget _sendMessgeSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _title("Your Message"),
          _textFormField("Your Email", TextAlign.center, 1),
          _textFormField("Write here....", TextAlign.start, 6),
        ],
      ),
    );
  }
}
