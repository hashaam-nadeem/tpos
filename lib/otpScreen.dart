
import 'package:flutter/material.dart';
class PinCodeEnterClass extends StatefulWidget {
  @override
  _PinCodeEnterClassState createState() => _PinCodeEnterClassState();
}
class _PinCodeEnterClassState extends State<PinCodeEnterClass> {
  FocusNode node1 = FocusNode();
  FocusNode node2 = FocusNode();
  FocusNode node3 = FocusNode();
  FocusNode node4 = FocusNode();
  FocusNode node5 = FocusNode();
  FocusNode node6 = FocusNode();
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  TextEditingController controller5 = TextEditingController();
  TextEditingController controller6 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: inputField(node1, node2, controller1),
          ),
          Expanded(
            child: inputField(node2, node3, controller2),
          ),
          Expanded(
            child: inputField(node3, node4, controller3),
          ),
          Expanded(child: inputField(node4, node5, controller4),),
          Expanded(
            child: inputField(node5, node6, controller5),
          ),
          Expanded(
            child: inputField(node6, node6, controller6),
          ),
        ],
      ),
    );
  }
  Widget inputField( FocusNode node, FocusNode nextnode, controll ){
    return Container(
      margin: EdgeInsets.all(5),
      color: Colors.white,
      alignment: Alignment.center,
      //width: MediaQuery.of(context).size.width*.15,
      //height: MediaQuery.of(context).size.width*.15,
      child: TextFormField(
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 15),
            counter: Container(height: 1,),
            hintText: '-',
            hintStyle: TextStyle(color: Colors.green)
        ),
        autofocus: true,
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.phone,
        onChanged: (value){
          node.unfocus();
          FocusScope.of(context).requestFocus(nextnode);
          // User.userData.smsCode = '${controller1.text}${controller2.text}${controller3.text}${controller4.text}${controller5.text}${controller6.text}';
        },
        controller: controll,
        focusNode: node,
      ),
    );
  }
}