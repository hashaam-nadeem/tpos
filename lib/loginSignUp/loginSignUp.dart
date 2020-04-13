import 'dart:convert';

import 'package:device_id/device_id.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_messaging/firebase_cloud_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:transact/Buyer/buyerHome.dart';
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/dataconnection.dart';
import 'package:transact/Model/userdatamodel.dart';
import 'package:transact/Seller/sellerHome.dart';

import 'package:transact/Seller/sellerStore.dart';
import 'package:http/http.dart' as http;
import 'package:transact/Supplier/conversation.dart';
import 'package:transact/Supplier/supplierDashBoard.dart';
import 'package:transact/Supplier/supplierStore.dart';
import 'package:transact/loginSignUp/emailVerification.dart';
import 'package:transact/otpScreen.dart';
import 'package:transact/utils/admin_chat.dart';
import 'package:transact/utils/routes.dart';
import 'package:transact/utils/utils.dart';

import '../changepass.dart';
import '../personalInfo.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  List<bool> _selection = [true, false, false];
  UserDataModel dataModel = UserDataModel();
  int id;
  bool register = false;
  bool forgot = false;
  bool dialog = false;
  bool verification = false;
  ProgressDialog pr;
  String deviceId;
  final userNameController = TextEditingController();
  final email = TextEditingController();
  final phoneNo = TextEditingController();

  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final referal = TextEditingController();

  final loginEmail = TextEditingController();
  final loginPass = TextEditingController();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String notificationToken;
  bool connectionCheck = false;
  InternetVerification internetVerification;

  void firebaseCloudMessaging_Listeners() {
    _firebaseMessaging.getToken().then((token) {
      print(token);
      notificationToken = token;
    }).catchError((onError) {
      print(onError);
    });
  }

  getdeviceid() async {
    deviceId = await DeviceId.getID;
    setState(() {
      User.userData.deviceId = deviceId;
    });

    print(deviceId);
    print(InternetVerification.getdataconnection());

    //InternetVerification.getdataconnection()==true?Fluttertoast.showToast(msg: "yeahhh i got it"):Fluttertoast.showToast(msg: "No internet connection");
  }
toVerifyEmail()async
{
  setState(() {
           User.userData.verifiedEmail=loginEmail.text;
         });
         print(User.userData.verifiedEmail);
  pr.show();
    var body = {
      "Email": "${loginEmail.text.trim()}",
      // "Password": "${loginPass.text.trim()}",
      // "DeviceNumber": "$deviceId",
      // "FCM": "$notificationToken",
    };
    print(body);
    var response = await http.post(
      "${API.EmailVerification}",
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
         AppRoutes.push(context, EmailVerification());
         //Navigator.of(context).pop();

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
  toVerifySignUpEmail()async
{
  setState(() {
           User.userData.verifiedEmail=email.text;
         });
         print(User.userData.verifiedEmail);
  pr.show();
    var body = {
      "Email": "${email.text.trim()}",
      // "Password": "${loginPass.text.trim()}",
      // "DeviceNumber": "$deviceId",
      // "FCM": "$notificationToken",
    };
    print(body);
    var response = await http.post(
      "${API.EmailVerification}",
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
         AppRoutes.push(context, EmailVerification());
         //Navigator.of(context).pop();

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
  
  forgotPassword()async
{
  // setState(() {
  //          User.userData.verifiedEmail=userNameController.text;
  //        });
        // print(User.userData.verifiedEmail);
  pr.show();
    var body = {
      "Email": "${loginEmail.text.trim()}",
      // "Password": "${loginPass.text.trim()}",
      // "DeviceNumber": "$deviceId",
      // "FCM": "$notificationToken",
    };
    print(body);
    var response = await http.post(
      "${API.ForgotPassword}",
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
              forgot=false;
            });
         //AppRoutes.push(context, EmailVerification());
         //Navigator.of(context).pop();

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
  signInSupplier() async {
    print("Supplier called");
    pr.show();
    var body = {
      "LoginName": "${loginEmail.text.trim()}",
      "Password": "${loginPass.text.trim()}",
      "DeviceNumber": "$deviceId",
      "FCM": "$notificationToken",
    };
    print(body);
    var response = await http.post(
      "${API.SignIn}",
      body: body,
    );
    print(json.decode(response.body));
    var Json = json.decode(response.body);
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == false) {
        pr.dismiss();
        setState(() {
          dataModel = UserDataModel.fromJson(Json['Data']);
          User.userData.userResult = dataModel.result;
          User.userData.token = dataModel.result.token;
        });

        if (User.userData.userResult.role == 0) {
          Fluttertoast.showToast(
              msg: "Please select Buyer to login as a Buyer",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
        } else if (User.userData.userResult.role == 2) {
          Fluttertoast.showToast(
              msg: "Please select Seller to login as a Seller",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
        } else {
          if (dataModel.result.profileCompleted == true) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => SupplierDashBoard()));
            //AppRoutes.push(context, SupplierDashBoard());
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => SupplierDetails()));
            //AppRoutes.push(context, SupplierDetails());
          }
        }
      } 
      else if(Json['Data']['Code']==800 && Json['Data']['WithError'] == true)
      {
        pr.dismiss();
        
        // setState(() {
        //   verification=true;
        // });
        _showDialog();
        // Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (BuildContext context) => EmailVerification()));
      }
      
      else {
        pr.dismiss();
        Fluttertoast.showToast(
            msg: "${Json['Data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      }
    } else {
      pr.dismiss();
      Fluttertoast.showToast(
          msg: "${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }

  signInSeller() async {
    print("Seller called");
    pr.show();
    var body = {
      "LoginName": "${loginEmail.text.trim()}",
      "Password": "${loginPass.text.trim()}",
      "DeviceNumber": "$deviceId",
      "FCM": "$notificationToken"
    };
    print(body);
    var response = await http.post(
      "${API.SignIn}",
      body: body,
    );
    print(json.decode(response.body));
    var Json = json.decode(response.body);
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == false) {
        pr.dismiss();
        setState(() {
          dataModel = UserDataModel.fromJson(Json['Data']);
          User.userData.userResult = dataModel.result;
          User.userData.token = dataModel.result.token;
        });

        if (User.userData.userResult.role == 0) {
          Fluttertoast.showToast(
              msg: "Please select Buyer to login as a Buyer",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
        } else if (User.userData.userResult.role == 1) {
          Fluttertoast.showToast(
              msg: "Please select Supplier to login as a Supplier",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
        } else {
          if (dataModel.result.profileCompleted == true) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => SellerHome()));
            //AppRoutes.push(context, SellerHome());
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => SellerDetails()));
            //AppRoutes.push(context, SellerDetails());
          }
        }
      } 
            else if(Json['Data']['Code']==800 && Json['Data']['WithError'] == true)
      {
        pr.dismiss();
        // setState(() {
        //   verification=true;
        // });
        _showDialog();
        // Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (BuildContext context) => EmailVerification()));
      }
      else {
        pr.dismiss();
        Fluttertoast.showToast(
            msg: "${Json['Data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      }
    } 
    // else if(response.statusCode==800)
    // {
    //   Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //                 builder: (BuildContext context) => EmailVerification()));
    // }
    else {
      pr.dismiss();
      Fluttertoast.showToast(
          msg: "${response.statusCode}",
          textColor: Colors.blueGrey,
          backgroundColor: Colors.white);
    }
  }

  signInBuyer() async {
    print("Buyer called");
    pr.show();
    var body = {
      "LoginName": "${loginEmail.text.trim()}",
      "Password": "${loginPass.text.trim()}",
      "DeviceNumber": "$deviceId",
      "FCM": "$notificationToken"
    };
    print(body);
    var response = await http.post(
      "${API.SignIn}",
      body: body,
    );
    print(json.decode(response.body));
    var Json = json.decode(response.body);
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == false) {
        pr.dismiss();
        setState(() {
          dataModel = UserDataModel.fromJson(Json['Data']);
          User.userData.userResult = dataModel.result;
          User.userData.token = dataModel.result.token;
          User.userData.getSellerProduct=true;
        });
        if (dataModel.result.role == 0) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => BuyerHome()));
        } else if (dataModel.result.role == 1) {
          Fluttertoast.showToast(
              msg: "Please select Supplier to login as a Supplier",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
        } else {
          Fluttertoast.showToast(
              msg: "Please select Seller to login as a Seller",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
        }
        // AppRoutes.push(context, BuyerHome());
      } 
      else if(Json['Data']['Code']==800 && Json['Data']['WithError'] == true)
      {
        pr.dismiss();
        // setState(() {
        //   verification=true;
        // });
        _showDialog();
        // Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (BuildContext context) => EmailVerification()));
      }
      else {
        pr.dismiss();
        Fluttertoast.showToast(
            msg: "${Json['Data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      }
    } else {
      pr.dismiss();
      Fluttertoast.showToast(
          msg: "${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }

  signUpBuyer() async {
    print("Buyer called");
    pr.show();
    var body = {
      "Username": "${userNameController.text.trim()}",
      "Email": "${email.text.trim()}",
      "Password": "${password.text.trim()}",
      "ConfirmPassword": "${confirmPassword.text.trim()}",
      "DeviceId": deviceId,
      "Referral": "${referal.text.trim()}",
      "Role": "0",
      "PhoneNumber":"${phoneNo.text.trim()}",
      "FCM": "$notificationToken"
    };
    var response = await http.post(
      "${API.SignUp}",
      body: body,
    );
    print(json.decode(response.body));
    var Json = json.decode(response.body);
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == false) {
        pr.dismiss();
        _showDialog();
        // setState(() {
        //   dataModel = UserDataModel.fromJson(Json['Data']);
        //   User.userData.userResult = dataModel.result;
        //   User.userData.token = dataModel.result.token;
        // });
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (BuildContext context) => EmailVerification()));
        
      } else {
        pr.dismiss();
        Fluttertoast.showToast(
            msg: "${Json['Data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      }
    } else {
      pr.dismiss();
      Fluttertoast.showToast(
          msg: "${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }

  signUpSeller() async {
    print("Seller called");
    pr.show();
    var body = {
      "Username": "${userNameController.text.trim()}",
      "Email": "${email.text.trim()}",
      "Password": "${password.text.trim()}",
      "ConfirmPassword": "${confirmPassword.text.trim()}",
      "DeviceId": deviceId,
      "Referral": "${referal.text.trim()}",
      "Role": "2",
      "PhoneNumber":"${phoneNo.text.trim()}",
      "FCM": "$notificationToken"
    };
    var response = await http.post(
      "${API.SignUp}",
      body: body,
    );
    print(json.decode(response.body));
    var Json = json.decode(response.body);
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == false) {
        pr.dismiss();
        // setState(() {
        //   dataModel = UserDataModel.fromJson(Json['Data']);
        //   User.userData.userResult = dataModel.result;
        //   User.userData.token = dataModel.result.token;
        // });
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (BuildContext context) => EmailVerification()));
         _showDialog();
      } else {
        pr.dismiss();
        Fluttertoast.showToast(
            msg: "${Json['Data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      }
    } else {
      pr.dismiss();
      Fluttertoast.showToast(
          msg: "${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }

  signUpSupplier() async {
    print("supplier called");
    pr.show();
    var body = {
      "Username": "${userNameController.text.trim()}",
      "Email": "${email.text.trim()}",
      "Password": "${password.text.trim()}",
      "ConfirmPassword": "${confirmPassword.text.trim()}",
      "DeviceId": deviceId,
      "Referral": "${referal.text.trim()}",
      "Role": "1",
       "PhoneNumber":"${phoneNo.text.trim()}",
      "FCM": "$notificationToken"
    };
    var response = await http.post(
      "${API.SignUp}",
      body: body,
    );
    print(json.decode(response.body));
    var Json = json.decode(response.body);
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == false) {
        pr.dismiss();
        // setState(() {
        //   dataModel = UserDataModel.fromJson(Json['Data']);
        //   User.userData.userResult = dataModel.result;
        //   User.userData.token = dataModel.result.token;
          // Navigator.push(context,
          //   MaterialPageRoute(builder: (BuildContext context) => EmailVerification()));
          Fluttertoast.showToast(
            msg: "${Json['Data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
          _showDialog();
        //});
      } else {
        pr.dismiss();
        Fluttertoast.showToast(
            msg: "${Json['Data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      }
    } else {
      pr.dismiss();
      Fluttertoast.showToast(
          msg: "${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

      },
      onLaunch: (Map<String, dynamic> message) async {

        print("onLaunch: $message");

      },
      onResume: (Map<String, dynamic> message) async {
        var route=MaterialPageRoute(
            builder: (BuildContext context)=>new Conversation()
        );
        Navigator.of(context).push(route);
        print("onResume: $message");

      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    getdeviceid();
    firebaseCloudMessaging_Listeners();
  }

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
    return Scaffold(
      backgroundColor: HexColor("#F5F7FA"),
      body: SafeArea(
        child: forgot == true
            ? _recoverPassword()
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: HexColor("#3B444B"),
                        child: Column(
                          children: <Widget>[
                            _logo(),
                            _loginText(),
                            _toggleButton(),
                          ],
                        ),
                      ),
                      register == false ? _loginForm() : _signUpForm(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _signUpForm() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.24,
      child: Column(
        children: <Widget>[
          _textField("images/user.png", "Full Name", 3, userNameController),
          _textField("images/email.png", "Email", 4, email),
          _textField("images/phone.png", "Phone Number", 5, phoneNo),
          _textField("images/key.png", "Password", 6, password),
          _textField("images/key.png", "Confirm Password", 7, confirmPassword),
          _textField("images/link.png", "Referral", 8, referal),
          _signUpButton(),
          _policy(),
          _goToLogin(),
        ],
      ),
    );
  }

  Widget _loginForm() {
    return Container(
      width: MediaQuery.of(context).size.width * .8,
      child: Column(
        children: <Widget>[
          _textField("images/email.png", "Email", 1, loginEmail),
          _textField("images/key.png", "Password", 2, loginPass),
          _forgot(),
          _loginButton(),
          _gotoSignUp(),
        ],
      ),
    );
  }

  Widget _toggleButton() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: ToggleButtons(
        borderColor: Colors.white,
        borderRadius: BorderRadius.circular(30),
        hoverColor: Colors.transparent,
        fillColor: Colors.white,
        isSelected: _selection,
        onPressed: (int index) {
          setState(() {
            for (int buttonIndex = 0;
                buttonIndex < _selection.length;
                buttonIndex++) {
              if (buttonIndex == index) {
                setState(() {
                  loginEmail.clear();
                  loginPass.clear();
                  userNameController.clear();
                  email.clear();
                  phoneNo.clear();
                  password.clear();
                  confirmPassword.clear();
                  referal.clear();
                  _selection[buttonIndex] = true;
                });
                print(_selection);
              } else {
                _selection[buttonIndex] = false;
              }
            }
          });
        },
        renderBorder: false,
        children: <Widget>[
          AnimatedContainer(
            duration: Duration(microseconds: 10),
            margin: EdgeInsets.all(2),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: _selection[0] == true
                    ? HexColor('#FC9F74')
                    : Colors.transparent),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                '  Buyer  ',
                style: TextStyle(
                    fontSize: 18,
                    color: _selection[0] == true ? Colors.white : Colors.black),
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(microseconds: 10),
            margin: EdgeInsets.all(2),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: _selection[1] == true ? Colors.green : Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                '  Seller  ',
                style: TextStyle(
                    fontSize: 18,
                    color: _selection[1] == true ? Colors.white : Colors.black),
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(microseconds: 10),
            margin: EdgeInsets.all(2),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: _selection[2] == true ? Colors.redAccent : Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Supplier',
                style: TextStyle(
                    fontSize: 18,
                    color: _selection[2] == true ? Colors.white : Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textField(String image, String label, id, _controller) {
    return Container(
      margin: id == 1
          ? EdgeInsets.only(top: 50, bottom: 10)
          : id == 3
              ? EdgeInsets.only(top: 20, bottom: 5)
              : EdgeInsets.symmetric(vertical: 2),
      height: MediaQuery.of(context).size.height * .08,
      child: TextFormField(
        obscureText: label=="Password"?
        true
        :label=="Confirm Password"?true:false,
        keyboardType: label=="Phone Number"?
        TextInputType.number
        :TextInputType.text,
        maxLength: label=="Phone Number"?15:50,
        controller: _controller,
        decoration: InputDecoration(
            filled: true,
            counterText: "",
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
              child: Image.asset("$image",color: Colors.grey,),
              // Image(
              //   width: 20,
              //   //height: 40,
              //   image: AssetImage(),
              // ),
            )),
      ),
    );
  }

  Widget _forgot() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          setState(() {
            forgot = true;
          });
        },
        child: Text(
          "\nForgot Password ?",
          style: TextStyle(fontSize: 14, color: HexColor("#29346E")),
        ),
      ),
    );
  }

  Widget _loginButton() {
    return GestureDetector(
      onTap: () {
        if (loginEmail.text.isEmpty || loginPass.text.isEmpty) {
          Fluttertoast.showToast(
              msg: "Please enter the required field",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
        } else {
          if (_selection[2]) {
            print(loginEmail.text.trim());
            print(loginPass.text.trim());
            signInSupplier();
          } else if (_selection[0]) {
            print(loginEmail.text.trim());
            print(loginPass.text.trim());
            signInBuyer();
          } else {
            signInSeller();
            print(loginEmail.text.trim());
            print(loginPass.text.trim());
          }
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * .05),
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _selection[0]
              ? HexColor("#FC9F74")
              : _selection[1] ? HexColor("#03C03C") : Colors.redAccent,
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                "Login",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 19,
                      color: _selection[0]
                          ? HexColor("#FC9F74")
                          : _selection[1]
                              ? HexColor("#03C03C")
                              : Colors.redAccent,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _gotoSignUp() {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Don't have an account?",
          style: TextStyle(fontSize: 14, color: HexColor("#29346E")),
        ),
        FlatButton(
          onPressed: () {
            setState(() {
              loginEmail.clear();
              loginPass.clear();
              userNameController.clear();
              email.clear();
              phoneNo.clear();
              password.clear();
              confirmPassword.clear();
              referal.clear();
              register = true;
            });
          },
          child: Text("Register",
              style: TextStyle(fontSize: 15, color: HexColor("#000000"))),
        )
      ],
    ));
  }

  Widget _logo() {
    return GestureDetector(
        onTap: () {
          AppRoutes.push(context, ChangePassword());
        },
        child: Container(
          height: register == false
              ? MediaQuery.of(context).size.height * 0.24
              : MediaQuery.of(context).size.height * 0.20,
          width: register == false
              ? MediaQuery.of(context).size.width * 0.5
              : MediaQuery.of(context).size.width * 0.5,
          margin: EdgeInsets.only(top: 15),
          child: Image(
            image: AssetImage("images/newlogo.png"),
          ),
        ));
  }

  Widget _loginText() {
    return Container(
      margin: EdgeInsets.only(
          top: register == false ? 10 : 10,
          bottom: register == false ? 20 : 20),
      child: Text(
        register == false ? "LOGIN" : "SIGNUP",
        style: TextStyle(
            fontFamily: 'antipasto',
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _signUpButton() {
    return GestureDetector(
      onTap: () {
        print(userNameController.text.trim());
        print(email.text.trim());
        print(phoneNo.text.trim());
        print(password.text.trim());
        print(confirmPassword.text.trim());
        print(referal.text.trim());
        if (userNameController.text.isEmpty ||
            email.text.isEmpty ||
            phoneNo.text.isEmpty ||
            password.text.isEmpty ||
            confirmPassword.text.isEmpty) {
          Fluttertoast.showToast(
              msg: "Please enter the required field",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
        } else {
         // print(loginEmail.text);
           
          if (_selection[0] == true) {
            signUpBuyer();
          } else if (_selection[1] == true) {
            signUpSeller();
          } else {
            signUpSupplier();
          }
        }

        //_showDialog();
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: _selection[0]
                ? HexColor("#FC9F74")
                : _selection[1] ? HexColor("#03C03C") : Colors.redAccent),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                "Register",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: _selection[0]
                          ? HexColor("#FC9F74")
                          : _selection[1]
                              ? HexColor("#03C03C")
                              : Colors.redAccent,
                      size: 19,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _goToLogin() {
    return Container(
        margin: EdgeInsets.only(bottom: 10, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Already a member ?",
              style: TextStyle(fontSize: 14, color: HexColor("#29346E")),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  loginEmail.clear();
                  loginPass.clear();
                  userNameController.clear();
                  email.clear();
                  phoneNo.clear();
                  password.clear();
                  confirmPassword.clear();
                  referal.clear();
                  register = false;
                });
              },
              child: Text(" LOGIN",
                  style: TextStyle(fontSize: 15, color: HexColor("#000000"))),
            )
          ],
        ));
  }

  Widget _policy() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        width: double.infinity,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: <TextSpan>[
            TextSpan(
              text: 'By continuing you agree to Transact \n',
              style: TextStyle(fontSize: 12, color: HexColor("#707070")),
            ),
            TextSpan(
                text: "User Agreement ",
                style: TextStyle(fontSize: 12, color: HexColor("#FF4545")),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => print("User Agreement")),
            TextSpan(
              text: 'and',
              style: TextStyle(fontSize: 12, color: HexColor("#707070")),
            ),
            TextSpan(
                text: " Privacy Policy",
                style: TextStyle(fontSize: 12, color: HexColor("#FF4545")),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => print("privacy policy\n")),
          ]),
        ));
  }

  Widget _recoverPassword() {
    return SingleChildScrollView(
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
            verification == true ? PinCodeEnterClass() : _emailbox(),
            _continueButton2(),
          ],
        ),
      ),
    );
  }

  Widget _logo2() {
    return Container(
      //  padding: EdgeInsets.all(30),
      child: Image(
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width * .5,
        color: Colors.black,
        image: AssetImage("images/newlogo.png"),
      ),
    );
  }

  Widget _emailbox() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      width: MediaQuery.of(context).size.width / 1.4,
      child: _textField("images/email.png", "Enter Email", 9, loginEmail),
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: 300.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      "VERIFICATION",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 5.0,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text("Please select a verification method",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      // forgot = true;
                      // verification = true;
                      Navigator.pop(context);
                    });
                  },
                  child: Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: HexColor("#F5F7FA")),
                        child: Center(
                          child: Text(
                            "Send to mobile",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if(register==true)
                      {
                        toVerifySignUpEmail();
                      }
                      else
                      {
                         toVerifyEmail();
                      }
                     
                                           // AppRoutes.push(context, EmailVerification());
                    });
                  },
                  child: Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        height: 50,
                        // width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: HexColor("#F5F7FA")),

                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Send to email",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    decoration: BoxDecoration(
                      color: HexColor("#3B444B"),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0)),
                    ),
                    child: Text(
                      "BACK",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }


  Widget _continueButton2() {
    return GestureDetector(
      onTap: () {
        setState(() {
          forgotPassword();
         // forgot = false;
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

  Widget _cancelButton() {
    return Align(
      alignment: Alignment.topLeft,
      child: GestureDetector(
        onTap: () {
          setState(() {
            forgot = false;
            verification = false;
          });
        },
        child: Container(
          height: 25,
          width: 25,
          margin: EdgeInsets.all(15),
          child: Image.asset("images/cross.png"),
        ),
      ),
    );
  }

  Widget _text() {
    return Container(
      // margin: EdgeInsets.only(top: 15),
      child: Column(
        children: <Widget>[
          Text(
            verification == true ? "Verification" : " Forgot Password",
            style: TextStyle(fontSize: 18, color: HexColor("#000000")),
          ),
          Container(
            margin: EdgeInsets.all(25),
            child: Text(
              verification == true
                  ? "Enter the OTP that is sent to\n +92 000 000 00"
                  : " Enter Your Email Address\nPassword Change link send to your email address.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: HexColor("#000000")),
            ),
          ),
        ],
      ),
    );
  }
}
