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
import 'package:transact/Seller/deliveryCost.dart';
import 'package:transact/Seller/settings.dart';
import 'package:transact/Supplier/headdetail.dart';
import 'package:transact/changepass.dart';
import 'package:transact/utils/routes.dart';
import 'package:transact/utils/shippingaddress.dart';
import 'package:transact/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../personalInfo.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool switchControl = false;
File image;
ProgressDialog pr;
GetPersonalInfo   getPersonalInfo=GetPersonalInfo();
  var style1 =
      TextStyle(fontFamily: "CaviarDreams", fontSize: 20, color: Colors.white);

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

            getdeliveryCost() async {
    pr.show();
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    print(header);
    var response = await http.get(
      "${API.getUserSettings}",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == true) {
        pr.dismiss();
        Fluttertoast.showToast(
            msg: "no Delivery Cost found",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      } else {
        pr.dismiss();
        setState(() {
          User.userData.deliveryCost = "${Json['Data']['Result']['DeliveryCost']}";
          User.userData.minOrder = "${Json['Data']['Result']['MinOrder']}";
        //   User.userData.deliveryCost = Json['Data']['Result']['DeliveryCost'];
        //  User.userData.sellerDeivery = Json['Data']['Result']['SellerDelivery'];
        //   User.userData.buyerPickup = Json['Data']['Result']['BuyerPickup'];
        //    User.userData.onlineDelivery = Json['Data']['Result']['OnlineDelivery'];
        //    User.userData.isdeliveryFree = Json['Data']['Result']['IsDeliveryFree'];
        //    User.userData.addressLine=Json['Data']['Result']['Address'];
           AppRoutes.push(context, DeliveryCost());
          
          //AppRoutes.replace(context, BuyerAdress());
          // cartFount=true;
          // cartModel=CartModel.fromJson(Json['Data']);
        });
        // for(int i=0;i<cartModel.result.length;i++)
        // {
        //   setState(() {
        //     total=total+cartModel.result[i].lineTotal;
        //   });
        // }
      }
    } else {
      pr.dismiss();
      Fluttertoast.showToast(
          msg: "Status Code: ${response.statusCode}",
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
  
    //   imageApiCall(String imge) async
    //   {
    //     var header={
    //   "Authorization": AuthenticationUser.getAuthentication(),
    // };
    // print(header);
    //      var body = {
    //  "imageFile":"${imge.toString()}",
    //  "flag":"1"
    // };
    // print(body);
    // var response = await http.post(
    //   "${API.UploadImage}",
    //   body: body,
    //   headers: header,
    // );
    // print(json.decode(response.body));
    //   }
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
                  )
               
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  _userStatus(),
                  _otherInfo(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _userStatus() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "User Status",
                textAlign: TextAlign.start,
                style: style1.copyWith(color: Colors.black),
              ),
              Row(
                children: <Widget>[
                  Text(
                    "Trial 30 days",
                    style: style1.copyWith(
                        height: 1.5, color: HexColor("#6D6D6D"), fontSize: 14),
                  ),
                  SizedBox(width: 15),
                  Text(
                    "(25 days left)",
                    style: style1.copyWith(
                        color: HexColor("#6D6D6D"), fontSize: 10),
                  )
                ],
              )
            ],
          ),
          InkWell(
            onTap: () {
              print("working");
            },
            child: Container(
              height: MediaQuery.of(context).size.height * .05,
              width: MediaQuery.of(context).size.width * .22,
              decoration: BoxDecoration(
                color: HexColor("#DB2B42"),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Center(
                child: Text(
                  "Subscribe",
                  style: style1.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _otherInfo() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Push Notification",
                style: style1.copyWith(color: Colors.black),
              ),
              Switch(
                onChanged: (value)
                {
                  toggleSwitch(value);
                },
                value: User.userData.userResult.notificationEnabled,
              )
            ],
          ),
          InkWell(
            onTap: () {
              AppRoutes.push(context, SellerReferral());
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Supplier ID & Referral",
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
                    "Account",
                    style: style1.copyWith(color: Colors.black),
                  ),
                ),
                _buildRow("images/userman.png", "Personal Information"),
                _buildRow("images/cards.png", "Bank Account Details"),
                _buildRow("images/userman.png", "Expense Category"),
               // _buildRow("images/cart4.png", "Shop Details"),
                _buildRow("images/givinghand.png", "Delivery Cost"),
                //_buildRow("images/givinghand.png", "Shipping Address"),
              ],
            ),
          ),
          changePass(),
        ],
      ),
    );
  }
Widget changePass()
{
  return GestureDetector(
    onTap: ()
    {
      AppRoutes.push(context, ChangePassword());
    },
    child:   Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height*.07,
    decoration: BoxDecoration(
      color: Colors.white,
      //border: Border.all(color:Colors.green,width:1),
      borderRadius: BorderRadius.all(Radius.circular(8))
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
             Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Change password",
             style: style1.copyWith(color: Colors.black)
            ,),
            Icon(Icons.settings),
          ],
        ),
      
      ],
    ),
  )
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
          User.userData.getPersonalInfo=getPersonalInfo;
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
  
  Widget _buildRow(String image, String text) {
    return InkWell(
      onTap: () {
        print("$text");
       
        text == "Personal Information"
            ? getPersonal()
            : print("$text");
            if(text=="Expense Category")
            {
              AppRoutes.push(context, HeadDetail());
            }
            else if(text=="Delivery Cost")
            {
              getdeliveryCost();
            }
            // else if(text=="Shipping Address")
            // {
            //   AppRoutes.push(context, ShippingAddress());
            // }
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
  TextEditingController IDController;
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
                      "Supplier ID",
                      style: style1.copyWith(
                          fontFamily: "antipasto",
                          fontSize: 22,
                          color: HexColor("#2E5A7D")),
                    ),
                  ),
                  _text("Supplier ID *"),
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
      controller: id == 1 ? IDController : ReferralController,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          isDense: true,
          prefixIcon: id == 2
              ? GestureDetector(
                  onTap: () {
                    Share.share(
                        "Join Transact with this promo IDController",
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
