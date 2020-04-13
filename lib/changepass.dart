import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:transact/utils/utils.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'AppBar.dart';
import 'Model/apismodel.dart';
import 'Model/getauthentication.dart';
class ChangePassword extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ChangePassword();
  }
  
}
class _ChangePassword extends State<ChangePassword>
{
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  ProgressDialog pr;

           changePass() async {

             if(password.text.isEmpty || confirmPassword.text.isEmpty)
             {
                Fluttertoast.showToast(
            msg: "enter required field",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
             }
             else if(password.text!=confirmPassword.text)
             {
               Fluttertoast.showToast(
            msg: "Password doesn't match",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
             }
             else
             {
               pr.show();

               var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var body={
      "Password":"${password.text.trim()}"
    };
    var response = await http.post(
      "${API.changePassowrd}",
      headers: header,
      body: body,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == true) {
        pr.dismiss();
       Fluttertoast.showToast(
            msg: "${Json['Data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
        //  Fluttertoast.showToast(
        //       msg: "no product found",
        //       textColor: Colors.white,
        //       backgroundColor: Colors.blueGrey);
        // setState(() {
        //   marketPlaceModel = new MarketPlaceModel();
        // });
      } else {
        pr.dismiss();
        Fluttertoast.showToast(
            msg: "${Json['Data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
        Navigator.of(context).pop();
        // setState(() {
        //   marketPlaceModel = MarketPlaceModel.fromJson(Json['Data']);
        //   wishCount=marketPlaceModel.result.length;
        // });
      }
    } else {
      pr.dismiss();
      Fluttertoast.showToast(
          msg: "response status:  ${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
             }

    
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
      message: 'Updating...',
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
    return Scaffold(

      appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: CustomeAppBar(
            homepage: false,
            title: "Update Password",
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(top:20),
          height: MediaQuery.of(context).size.width / 1.2,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: HexColor("#3B444B"),
              borderRadius: new BorderRadius.only(
                bottomLeft: const Radius.circular(120.0),
              )),
              child: Column(
                children: <Widget>[
                  _textField( "Password", 1, password),
                  _textField( "Confirm Password", 2, confirmPassword),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: ()
                        {
                          changePass();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top:12,right:12),
                          decoration: BoxDecoration(
                            color: HexColor("#FFFFFF"),
                            border: Border.all(color: HexColor("#707070")),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          width: MediaQuery.of(context).size.width*.27,
                          height: MediaQuery.of(context).size.height*.06,
                          child: Center(child: Text("Save"),),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
        ),
    );
  }
   Widget _textField(String label, id, _controller) {
    return Container(
      margin: id == 1
          ? EdgeInsets.only(top: 50, bottom: 10)
          : id == 3
              ? EdgeInsets.only(top: 20, bottom: 5)
              : EdgeInsets.symmetric(vertical: 2),
      height: MediaQuery.of(context).size.height * .08,
      width: MediaQuery.of(context).size.width*.7,
      child: TextFormField(
        controller: _controller,
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
            ),
      ),
    );
  }

}