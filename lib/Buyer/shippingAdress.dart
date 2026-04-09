import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:transact/AppBar.dart';
import 'package:transact/Buyer/checkOut.dart';
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/Model/personalInfomodel.dart';
import 'package:transact/utils/bottomButton.dart';
import 'package:transact/utils/routes.dart';
import 'package:transact/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BuyerShippingAdress extends StatefulWidget {
  @override
  _BuyerShippingAdressState createState() => _BuyerShippingAdressState();
}

class _BuyerShippingAdressState extends State<BuyerShippingAdress> {
  var switchh = true;
  List<String> _country = ["London", "Sydney", "China", "France"];
  List<String> _state = ["UK", "America", "italy", "France"];
  List<String> _city = ["Lahore", "Sydney", "Islamabad", "France"];
  TextEditingController name = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController address = TextEditingController();
  String _selectedCatagory1;
  String _selectedCategory2;
  String _selectedCatagory3;
  var addnew = false;
  GetPersonalInfo   getPersonalInfo=GetPersonalInfo();
  ProgressDialog pr;
getPersonal() async
  {
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
        setState(() {
          getPersonalInfo=GetPersonalInfo.fromJson(Json['Data']);
        });
      }
      else
      {
        setState(() {
          getPersonalInfo=GetPersonalInfo();
        });
        //  Fluttertoast.showToast(
        //     msg: "${Json['data']['ShortMessage']}",
        //     textColor: Colors.white,
        //     backgroundColor: Colors.blueGrey);
      }
    }
    else
    {
          Fluttertoast.showToast(
          msg: "response status: ${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }
  
  updateProduct() async {
    //int id=User.userData.orderModel.result[User.userData.index].lineDetail[selectedIndex].id;
    //print("selected id: " + id.toString());
    //int r=_productRating.toInt();
    if (name.text.isEmpty &&
        contact.text.isEmpty &&
        country.text.isEmpty &&
        city.text.isEmpty &&
        state.text.isEmpty &&
        address.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please enter the required field",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    } else {
      pr.show();
      var header = {
        "Authorization": "${AuthenticationUser.getAuthentication()}",
      };

      print(header);
      var body = {
        "Country": "${country.text}",
        "State": "${state.text}",
        "City": "${city.text.trim()}",
        "Address": "${address.text}",
        "Contact": "${contact.text}",
        "Fullname": "${name.text.trim()}",
      };
      print(body);
      var response =
          await http.post("${API.UpdateProfile}", headers: header, body: body);

      print(json.decode(response.body));
      var Json = json.decode(response.body);
      if (response.statusCode == 200) {
        if (Json['Data']['WithError'] == false) {
          // pr.dismiss();
          //length++;
          pr.dismiss();
          Fluttertoast.showToast(
              msg: "${Json['Data']['ShortMessage']}",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
          setState(() {
            User.userData.userResult.fullname = name.text.trim();
            User.userData.userResult.phoneNo = contact.text.trim();
            // User.userData.userResult. = name.text.trim();
            // User.userData.userResult.fullname = name.text.trim();
            // User.userData.userResult.fullname = name.text.trim();
            // User.userData.userResult.fullname = name.text.trim();
          });
          Navigator.of(context).pop();
        } else {
          pr.dismiss();
          Fluttertoast.showToast(
              msg: "${Json['Data']['ShortMessage']}",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
        }
      } else {
        pr.dismiss();

        //pr.dismiss();
        Fluttertoast.showToast(
            msg: "response status: ${response.statusCode}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      }
    }
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getPersonal();
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
            //  bottomSheet: _bottomSheet(),
            backgroundColor: HexColor("#F5F7FA"),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: CustomeAppBar(
                homepage: false,
                title: "Details",
              ),
            ),
            bottomNavigationBar: _bottomBar(),
            body: SingleChildScrollView(
              child: Container(child: _addAddress()),
            )));
  }

  Widget _addAddress() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _title("Full Name"),
             User.userData.getPersonalInfo.result!=null?
              _textField("${User.userData.getPersonalInfo.result.fullName}", name)
              :
              _textField("full Name", name),
              _title("Phone Number"),
               User.userData.getPersonalInfo.result!=null?
              _textField("${User.userData.getPersonalInfo.result.contact}", contact)
              :
              _textField("phone no", contact),
              _title("Country"),
                             User.userData.getPersonalInfo.result!=null?
              _textField("${User.userData.getPersonalInfo.result.country}", country)
              :
              _textField("enter country", country),
              //_dropdown(1),
              _title("State"),
                             User.userData.getPersonalInfo.result!=null?
               _textField("${User.userData.getPersonalInfo.result.state}", state)
               :
              _textField("enter state", state),
              //_dropdown(2),
              _title("City"),
                             User.userData.getPersonalInfo.result!=null?
              _textField("${User.userData.getPersonalInfo.result.city}", city)
              :
              _textField("enter city", city),
              //_dropdown(3),
              _title("Address"),
                             User.userData.getPersonalInfo.result!=null?
              _textField("${User.userData.getPersonalInfo.result.address}", address)
              :
              _textField("enter Address", address),
            ]));
  }

  Widget _title(String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Text("$text",
          style: TextStyle(
              color: HexColor("#9E9E9E"),
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget _dropdown(id) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 5, bottom: 10),
        height: 40,
        child: DropdownButton(
            isDense: true,
            isExpanded: true,
            icon: Container(
              alignment: Alignment.centerRight,
              child: Icon(Icons.arrow_drop_down),
            ),
            hint: Text(id == 1
                ? 'Select Country'
                : id == 2
                    ? "Select State"
                    : "Select City"), // Not necessary for Option 1
            value: id == 1
                ? _selectedCatagory1
                : id == 2 ? _selectedCategory2 : _selectedCatagory3,
            onChanged: (newValue) {
              setState(() {
                id == 1
                    ? _selectedCatagory1 = newValue
                    : id == 2
                        ? _selectedCategory2 = newValue
                        : _selectedCatagory3 = newValue;
              });
            },
            items: id == 1
                ? _country.map((catagory1) {
                    return DropdownMenuItem(
                      child: new Text(catagory1),
                      value: catagory1,
                    );
                  }).toList()
                : id == 2
                    ? _state.map((catagory2) {
                        return DropdownMenuItem(
                          child: new Text(catagory2),
                          value: catagory2,
                        );
                      }).toList()
                    : _city.map((catagory2) {
                        return DropdownMenuItem(
                          child: new Text(catagory2),
                          value: catagory2,
                        );
                      }).toList()));
  }

  Widget _textField(String text, _controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      height: 40,
      width: double.infinity,
      child: TextFormField(
        controller: _controller,
        keyboardType: _controller==contact?
        TextInputType.number
        :TextInputType.multiline,
        cursorColor: HexColor("#9E9E9E"),
        style: TextStyle(
            fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: "$text",
          focusColor: Colors.orange,
        ),
      ),
    );
  }

  Widget _bottomBar() {
    return Container(
      height: MediaQuery.of(context).size.height * .07,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 20, bottom: 5),
              child: BottomButton(
                name: "Clear",
                ontap: () {
                  setState(() {
                    name.clear();
                    contact.clear();
                    country.clear();
                    state.clear();
                    city.clear();
                    address.clear();
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 10, bottom: 5),
              child: BottomButton(
                name: "Save",
                ontap: () {
                  updateProduct();
                  // AppRoutes.replace(context, CheckOut());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
