import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:share/share.dart';
import 'package:transact/Buyer/shippingAdress.dart';
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/Model/personalInfomodel.dart';
import 'package:transact/Seller/settings.dart';
import 'package:transact/utils/routes.dart';
import 'package:transact/utils/shippingaddress.dart';
import 'package:transact/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BuyerSettings extends StatefulWidget {
  @override
  _BuyerSettingsState createState() => _BuyerSettingsState();
}

class _BuyerSettingsState extends State<BuyerSettings> {
  bool switchControl = false;
  GetPersonalInfo   getPersonalInfo=GetPersonalInfo();
  ProgressDialog pr;
  File image;
  var style1 =
      TextStyle(fontFamily: "CaviarDreams", fontSize: 20, color: Colors.white);

      getPersonal() async
  {
    pr.show();
     var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.get(
      "${API.getPerosalInformation}",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if(response.statusCode==200)
    {
     
      if(Json['Data']['WithError']==false)
      {
         pr.dismiss();
        setState(() {
          getPersonalInfo=GetPersonalInfo.fromJson(Json['Data']);
          User.userData.getPersonalInfo=getPersonalInfo;
        });
                AppRoutes.push(context, BuyerShippingAdress());
      }
      else
      {
        pr.dismiss();

        setState(() {
          getPersonalInfo=GetPersonalInfo();
        });
        AppRoutes.push(context, BuyerShippingAdress());
        //  Fluttertoast.showToast(
        //     msg: "${Json['data']['ShortMessage']}",
        //     textColor: Colors.white,
        //     backgroundColor: Colors.blueGrey);
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
  
            updateNotification(bool value) async {
    pr.show();
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var body = {
      "PushNotificationEnabled": "$value",
      "SecurityPinEnabled": "",
      "DeliveryCost": "",
      "MinimumOrder": "",
    };

    print(header);
    print(body);
    var response = await http.post(
      "${API.UpdateUserSetting}",
      headers: header,
      body:body,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if(response.statusCode==200)
    {
      if(Json['Data']['WithError']==false)
      {
        pr.dismiss();
        setState(() {
          User.userData.userResult.notificationEnabled=value;
        });
        Fluttertoast.showToast(
              msg: "${Json['Data']['ShortMessage']}",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
               //AppRoutes.replace(context, SellerHome());
              // Navigator.of(context).pop();
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
      Fluttertoast.showToast(
              msg: "Response Status: ${response.statusCode}",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
    }
  }

   getImage() async
      {
        var Image=await ImagePicker.pickImage(source: ImageSource.gallery).then((onValue)
        {
          setState(() {
            image=onValue;
          });
          if(image==null)
          {
             Fluttertoast.showToast(
              msg: "no image selected",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
          }
          else
          {
            uploadImage(onValue);
          }
         // print(image);
        });
      }
      uploadImage(File file) async
      {
        pr.show();
        print(file);
        String img;
        String fileName = file.path.split('/').last;
      FormData data = FormData.fromMap({
        "imageFile": await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });
      print(fileName.toString());
      print(data);
      Dio dio = new Dio();
 dio.options.headers["Authorization"] = "${AuthenticationUser.getAuthentication()}";
  dio.options.headers["flag"] = "1";
      dio.post("${API.UploadImage}", data: data).then((imagecall) {
        print("this the image url -----======== $imagecall");
        setState(() {
          img = imagecall.data['Data']['Result'].toString();
          User.userData.userResult.imageUrl=img;
        });
        pr.dismiss();
        //  Fluttertoast.showToast(
        //       msg: "Image Updated",
        //       textColor: Colors.white,
        //       backgroundColor: Colors.blueGrey);
        print("Image url: " + img);
        myProfileImage(img);
     //   callAPiImage(context, imageurl);
      }).catchError((onError)
      {
        pr.dismiss();
         Fluttertoast.showToast(
              msg: "$onError",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
      });
      
      }
    myProfileImage(String img)async
   {
     pr.show();
        var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var body = {
      "ImageUrl": "$img",
    };

    print(header);
    print(body);
    var response = await http.post(
      "${API.UpdateP}",
      headers: header,
      body:body,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if(response.statusCode==200)
    {
      if(Json['Data']['WithError']==false)
      {
        pr.dismiss();
        // setState(() {
        //   User.userData.userResult.notificationEnabled=value;
        // });
        Fluttertoast.showToast(
              msg: "${Json['Data']['ShortMessage']}",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
               //AppRoutes.replace(context, SellerHome());
              // Navigator.of(context).pop();
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
              msg: "Response Status: ${response.statusCode}",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
    }

   }
  
  @override
  Widget build(BuildContext context) {
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
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 3.2,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(bottom: 20),
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(color: HexColor("#3B444B"), boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 20.0,
                )
              ]),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: <Widget>[
                           Center(
                    child: Column(
                      children: <Widget>[
                       GestureDetector(
                         onTap: ()
                         {
                           getImage();
                         },
                         child: 
                         
                         
                         Container(
                                // margin: EdgeInsets.only(left: 20,right: 10),
                                width:70,
                                height: 70,

                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 2)),
                                child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
                                    child: Container(
                                      child:
                                          User.userData.userResult.imageUrl==null
                                                  
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Image(
                                                    image: AssetImage(
                                                        'images/myImage.jpg'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Image(
                                                    image: NetworkImage(
                                                        '${API.API_URL}${User.userData.userResult.imageUrl}'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                    )),
                              ),
                         ),
                        User.userData.userResult.fullname==null?
                        Text(
                          "Username",
                          style: style1,
                        )
                        :
                        Text(
                          "${User.userData.userResult.fullname}",
                          style: style1,
                        ),
                        User.userData.userResult.email==null?
                         Text(
                          "Johndoe@mail.com",
                          style: style1.copyWith(fontSize: 12),
                        )
                        :
                        Text(
                          "${User.userData.userResult.email}",
                          style: style1.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
              
                       
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: _otherInfo(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _otherInfo() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Account",
                    style: style1.copyWith(color: Colors.black),
                  ),
                ),
                _buildRow("images/userman.png", "Personal Information", 1),
                //_buildRow("images/cards.png", "Bank Account Details", 2),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              AppRoutes.push(context, SellerReferral());
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "User ID & Referral",
                  style: style1.copyWith(color: Colors.black),
                ),
                Icon(Icons.arrow_forward_ios,
                    color: HexColor("#3B444B"), size: 20),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Shipping details",
                    style: style1.copyWith(color: Colors.black),
                  ),
                ),
                _buildRow("images/adress.png", "Shipping Adress", 3),
                _buildRow("images/currency.png", "Currency", 4),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Others",
                    style: style1.copyWith(color: Colors.black),
                  ),
                ),
                _buildRow("images/privacy.png", "Privacy Policy", 5),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 10),
                                height: 20,
                                width: 20,
                                child: Image.asset("images/notification.png"),
                              ),
                              Text("Notification",
                                  style: style1.copyWith(
                                      fontSize: 15,
                                      fontFamily: "CaviarDreams",
                                      color: HexColor("#3B444B"))),
                            ],
                          ),
                        ),
                        Switch(
                          onChanged: (value)
                          {
                            toggleSwitch(value);
                          },
                          value:  User.userData.userResult.notificationEnabled,
                        )
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

    void toggleSwitch(bool value) {
    
    updateNotification(value);
    // switchControl == false
    //     ? setState(() {
    //         switchControl = true;
    //         print("true");
            
    //       })
    //     : setState(() {
    //         switchControl = false;
    //         print("false");
    //         updateNotification();
    //       });
  }

  Widget _buildRow(String image, String text, int id) {
    return InkWell(
      onTap: () {
        // id == 1 ? getPersonal() : null;
        if(id==1)
        {
          getPersonal();
        }
        if (id == 3) {
          AppRoutes.push(context, ShippingAddress());
        }
      },
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      height: 20,
                      width: 20,
                      child: Image.asset("$image"),
                    ),
                    Text("$text",
                        style: style1.copyWith(
                            fontSize: 15,
                            fontFamily: "CaviarDreams",
                            color: HexColor("#3B444B"))),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  color: HexColor("#3B444B"), size: 20),
            ],
          )),
    );
  }
}

class Referral extends StatefulWidget {
  @override
  _ReferralState createState() => _ReferralState();
}

class _ReferralState extends State<Referral> {
  TextEditingController BuyerIDController;
  TextEditingController ReferralController;
  var style1 =
      TextStyle(fontFamily: "CaviarDreams", fontSize: 18, color: Colors.white);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 3.2,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(bottom: 20),
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(color: HexColor("#3B444B"), boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 20.0,
                )
              ]),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.all(15),
                      child: CircleAvatar(
                        backgroundImage: AssetImage("images/myImage.jpg"),
                        radius: 32,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 2, bottom: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Buyer ID",
                      style: style1.copyWith(
                          fontFamily: "antipasto",
                          fontSize: 22,
                          color: HexColor("#2E5A7D")),
                    ),
                  ),
                  _text("Buyer ID *"),
                  _textField("000 111 222", 1),
                  _text("Referral code and share link *"),
                  _textField("johndoe123", 2)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _textField(String hint, int id) {
    return TextField(
      readOnly: true,
      controller: id == 1 ? BuyerIDController : ReferralController,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          isDense: true,
          prefixIcon: id == 2
              ? GestureDetector(
                  onTap: () {
                    Share.share(
                        "Join Transact with this promo $ReferralController",
                        subject: "Refferal");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: HexColor("#3B444B"),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8))),
                    child: Container(
                      height: 20,
                      width: 20,
                      padding: EdgeInsets.all(10),
                      child: Image.asset("images/link.png"),
                    ),
                  ),
                )
              : null,
          hintText: "$hint",
          hintStyle: style1.copyWith(fontSize: 12, color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
    );
  }

  Widget _text(String text) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 2),
      alignment: Alignment.centerLeft,
      child: Text(
        "$text",
        style: style1.copyWith(color: Colors.black, fontSize: 14),
      ),
    );
  }
}
