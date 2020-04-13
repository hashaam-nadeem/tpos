import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/loginSignUp/loginSignUp.dart';
import 'package:transact/utils/routes.dart';
import 'package:transact/utils/utils.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
class EmailVerification extends StatefulWidget {
  @override
  _EmailVerificationState createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  ProgressDialog pr;
TextEditingController code=TextEditingController();
  toVerifyEmail()async
{
  if(code.text.isEmpty)
  {
    Fluttertoast.showToast(
            msg: "Enter code first.",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
  }
  else
  {
    pr.show();
    var body = {
      "Email": "${User.userData.verifiedEmail}",
      "Code":"${code.text.trim()}"
      // "Password": "${loginPass.text.trim()}",
      // "DeviceNumber": "$deviceId",
      // "FCM": "$notificationToken",
    };
    print(body);
    var response = await http.post(
      "${API.VerifyEmail}",
      body: body,
    );
    print(json.decode(response.body));
    var Json = json.decode(response.body);
    if(response.statusCode==200)
    {

       if (Json['Data']['WithError'] == false)
       {
         pr.dismiss();
         Fluttertoast.showToast(
            msg: "${Json['Data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
         setState(() {
           User.userData.verifiedEmail=email.text.trim();
         });
         AppRoutes.makeFirst(context, Login());
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
  
  TextEditingController email=TextEditingController();
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
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(bottom: 10),
            width: MediaQuery.of(context).size.width,
            color: HexColor("#F5F7FA"),
            child: Stack(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      _cancelButton(),
                      _logo2(),
                      _text(),
                      _forgotCard(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textField(String image, String label, id) {
    return Container(
      margin: id == 1
          ? EdgeInsets.only(top: 50, bottom: 10)
          : id == 3
              ? EdgeInsets.only(top: 20, bottom: 5)
              : EdgeInsets.symmetric(vertical: 2),
      height: 50,
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: code,
        decoration: InputDecoration(
            filled: true,
            fillColor: HexColor("#FFFFFF"),
            labelText: "$label",
            labelStyle: TextStyle(fontSize: 14, color: HexColor("#3B444B")),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: HexColor("#707070"))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 1, color: HexColor("#707070"))),
            prefixIcon: Container(
              height: 10,
              width: 10,
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
              child: Image(
                width: 20,
                //height: 40,
                image: AssetImage("$image"),
              ),
            )),
      ),
    );
  }

  Widget _emailbox() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      width: MediaQuery.of(context).size.width / 1.4,
      child: _textField("images/key.png", "Enter Code", 9),
    );
  }

  Widget _cancelButton() {
    return Align(
      alignment: Alignment.topLeft,
      child: GestureDetector(
        onTap: () {
          setState(() {
            Navigator.pop(context);
          });
        },
        child: Container(
          height: 20,
          width: 20,
          margin: EdgeInsets.all(15),
          child: Image.asset("images/cross.png"),
        ),
      ),
    );
  }

  Widget _logo2() {
    return Container(
      //  padding: EdgeInsets.all(30),
      child: Image(
        height: MediaQuery.of(context).size.height * .3,
        width: MediaQuery.of(context).size.width * .3,
        //color: Colors.black,
        image: AssetImage("images/applogo.png"),
      ),
    );
  }

  Widget _text() {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            "Verification",
            style: TextStyle(fontSize: 18, color: HexColor("#000000")),
          ),
          Container(
            margin: EdgeInsets.all(25),
            child: Text(
              " Enter the verification code sent to ${User.userData.verifiedEmail}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: HexColor("#000000")),
            ),
          ),
        ],
      ),
    );
  }

  Widget _forgotCard() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(10),
        color: HexColor("#F5F7FA"),
        child: Column(
          children: <Widget>[
            _emailbox(),
            _continueButton2(),
          ],
        ),
      ),
    );
  }

  Widget _continueButton2() {
    return GestureDetector(
      onTap: () {
        setState(() {
          toVerifyEmail();
          print(User.userData.verifiedEmail);
          //AppRoutes.makeFirst(context, Login());
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        height: 50,
        // width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: HexColor("#3B444B")),

        child: Align(
          alignment: Alignment.center,
          child: Text(
            "Continue",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
