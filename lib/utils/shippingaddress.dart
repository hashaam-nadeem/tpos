import 'package:dashed_container/dashed_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:transact/AppBar.dart';
import 'package:transact/Buyer/checkOut.dart';
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/addressesmodel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/utils/bottomButton.dart';
import 'package:transact/utils/locationPicker.dart';
import 'package:transact/utils/routes.dart';
import 'package:transact/utils/settinglocation.dart';
import 'package:transact/utils/utils.dart';
import 'package:transact/utils/fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import 'package:flutter/services.dart';

class ShippingAddress extends StatefulWidget {
  @override
  _ShippingAddress createState() => _ShippingAddress();
}

class _ShippingAddress extends State<ShippingAddress> {
  // String lat;
  // String long;
  var _selected;
  int selectedAddress = 0;
  double lat = 0.0;
  double long = 0.0;
  ProgressDialog pr;
  var switchh = true;
  AddressModel addressModel = AddressModel();
  List<String> _country = ["London", "Sydney", "China", "France"];
  List<String> _state = ["London", "Sydney", "China", "France"];
  List<String> _city = ["London", "Sydney", "China", "France"];
  String newlocation =
      "Address Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ";
//String country="",state="",city="",address="";
  bool isLoading = false;
  static const kGoogleApiKey = "AIzaSyBLkci3EngfM5b6hp7X5a9w7bv66xcWs7M";
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  TextEditingController enterCountry = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController address = TextEditingController();
  displayPrediction(Prediction p) async {
    PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(p.placeId).then((onValue) async {
      if (onValue.isDenied) {
      } else {
        double lat = onValue.result.geometry.location.lat;
        double lng = onValue.result.geometry.location.lng;
        var first;
        var addresses;
        print("address");
        final coordinates = new Coordinates(lat, lng);
        addresses =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);
        first = addresses.first;
        print("${first.featureName} : ${first.addressLine}");
        setState(() {
          // country=first.countryName;
          // state=first.adminArea;
          // city=first.locality;
          // address=first.addressLine;
        });
        //print(country);
        print(state);
        print(city);
        // print(address);
      }
    });
  }

  addNewAddress() async {
   
    if (enterCountry.text.isEmpty ||
        city.text.isEmpty ||
        state.text.isEmpty ||
        contact.text.isEmpty ||
        address.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "please enter the required field.",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    } else {
       pr.show();
      var header = {
        "Authorization": AuthenticationUser.getAuthentication(),
      };
      var body = {
        "Country": "${enterCountry.text.trim()}",
        "State": "${state.text.trim()}",
        "City": "${city.text.trim()}",
        "Address": "${address.text.trim()}",
        "Contact": "${contact.text.trim()}",
      };
      print(header);
      var response = await http.post(
        "${API.addAddress}",
        headers: header,
        body: body,
      );
      var Json = json.decode(response.body);
      print(json.decode(response.body));
      if (response.statusCode == 200) {
        pr.dismiss();
        if (Json['Data']['WithError'] == false) {
          Fluttertoast.showToast(
              msg: "${Json['Data']['ShortMessage']}",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
          //getdeliveryCost();
          setState(() {
            addnew=false;
            contact.clear();
            enterCountry.clear();
            state.clear();
            city.clear();
            address.clear();
          });
          getAddress();
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
            msg: "Response Status:  ${response.statusCode}.",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      }
    }
  }

  getdeliveryCost() async {
    pr.show();
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    print(header);
    var response = await http.get(
      "${API.getDeliveryCost}",
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
          User.userData.email = "${Json['Data']['Result']['Email']}";
          User.userData.contact = "${Json['Data']['Result']['Phone']}";
          User.userData.deliveryCost = Json['Data']['Result']['DeliveryCost'];
          AppRoutes.replace(context, CheckOut());
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

  getAddress() async {
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    print(header);
    var response = await http.get(
      "${API.getAddresses}",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == true) {
        Fluttertoast.showToast(
            msg: "no Address found",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      } else {
        setState(() {
          addressModel = AddressModel.fromJson(Json['Data']);
          User.userData.addressModel = addressModel;
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
      Fluttertoast.showToast(
          msg: "Status Code: ${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }

  Future search() async {
    this.setState(() {
      this.isLoading = true;
    });

    try {
      var longitude = long;
      var latitude = lat;

      var results = await Geocoder.local
          .findAddressesFromCoordinates(new Coordinates(latitude, longitude));
      this.setState(() {
        newlocation = results.first.addressLine;
      });
    } catch (e) {
      print("Error occured: $e");
    } finally {
      this.setState(() {
        this.isLoading = false;
      });
    }
  }

  Future<void> location() async {
    Position position;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final Geolocator geolocator = Geolocator();
      position = await geolocator.getLastKnownPosition(
          desiredAccuracy: LocationAccuracy.best);
    } on PlatformException {
      position = null;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      lat = position.latitude;
      long = position.longitude;
      print(lat);
    });
  }

  String _selectedCatagory;
  var addnew = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAddress();
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
            bottomNavigationBar: addnew==true?_bottomBar():null,
            body: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: addnew == false
                    ? _currentAdress()
                    : Container(child: _addAddress()),
              ),
            )));
  }

  Widget _currentAdress() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          Container(
            color: HexColor("#FAFAFA"),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  addnew = true;
                });
              },
              child: DashedContainer(
                  dashColor: Colors.blueAccent,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    alignment: Alignment.center,
                    child: Text(
                      "+ New Address",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Roboto",
                          color: HexColor("#42AFC9")),
                    ),
                  )),
            ),
          ),
          Container(
            color: HexColor("#FAFAFA"),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                // location();
                // search();
                AppRoutes.replace(context, SettingLocation());
              },
              child: DashedContainer(
                  dashColor: Colors.blueAccent,
                  child: Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      alignment: Alignment.center,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              height: 20,
                              width: 20,
                              child: Image.asset("images/location.png"),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Use My Location",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Roboto",
                                  color: HexColor("#42AFC9")),
                            ),
                          ),
                        ],
                      ))),
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return addressList(index);
            },
            itemCount:
                addressModel.result != null ? addressModel.result.length : 0,
          )),
          // Container(
          //   child: Row(
          //     children: <Widget>[
          //       Expanded(
          //         child: Container(
          //           height: 20,
          //           width: 20,
          //           child: Image.asset("images/location.png"),
          //         ),
          //       ),
          //       Expanded(
          //         flex: 6,
          //         child: Text(
          //           "John doe",
          //           textAlign: TextAlign.start,
          //           style: headingFont,
          //         ),
          //       ),
          //       Expanded(
          //         child: GestureDetector(
          //           onTap: () {},
          //           child: Container(
          //               child: Text(
          //             "EDIT",
          //             style: headingFont.copyWith(fontSize: 17),
          //           )),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          // Container(
          //   margin: EdgeInsets.only(left: 40, right: 10, top: 10),
          //   child: Text("$newlocation"),
          // ),
          // // Container(
          //   margin: EdgeInsets.only(top: 10, bottom: 5),
          //   child: Row(
          //     children: <Widget>[
          //       Expanded(
          //         child: Container(),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget addressList(int index) {
    return GestureDetector(
        onTap: () {
          setState(() {
            selectedAddress = index;
          });
        },
        child: Container(
          padding: EdgeInsets.all(10),
          color: selectedAddress == index ? HexColor("#FF6D2B") : Colors.white,
          margin: EdgeInsets.only(bottom: 12),
          width: MediaQuery.of(context).size.width,
          //height: MediaQuery.of(context).size.height*.2,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 20,
                        width: 20,
                        child: Image.asset("images/location.png"),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(
                        "${addressModel.result[index].country}",
                        textAlign: TextAlign.start,
                        style: headingFont,
                      ),
                    ),
                 
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 40, right: 10, top: 10),
                child: Text("${addressModel.result[index].address}"),
              ),
            ],
          ),
        ));
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
              //_title("Full Name"),
              //_textField("name"),
              _title("Phone Number"),
              _textField("Contact no"),
              _title("Country"),
              SizedBox(
                height: 20,
              ),
              // GestureDetector(
              //   onTap: () async
              //   {
              //       Prediction p = await PlacesAutocomplete.show(
              //             context: context,
              //             apiKey: kGoogleApiKey,
              //             mode: Mode.overlay, // Mode.fullscreen
              //           ).then((onValue)
              //           {
              //             if(onValue==null)
              //             {

              //             }
              //             else
              //             {
              //               displayPrediction(onValue);
              //             }

              //           });
              //   },
              //   child: Container(
              //     width: MediaQuery.of(context).size.width,
              //     height: MediaQuery.of(context).size.height*.08,
              //     margin: EdgeInsets.only(left:5),
              //     color: Colors.white,
              //     child:Text("Select Country",style: TextStyle(color: HexColor("#9E9E9E"),fontWeight: FontWeight.bold ),)
              //   ),
              // ),
              // // Container(
              //   margin: EdgeInsets.only(bottom:10),
              //   width: MediaQuery.of(context).size.width*.9,
              //   height: 1,
              //   color: HexColor("#9E9E9E"),
              // ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .06,
                child: TextField(
                  controller: enterCountry,
                  //enabled: true,
                  onTap: () async {
                    //  Prediction p = await PlacesAutocomplete.show(
                    //       context: context,
                    //       apiKey: kGoogleApiKey,
                    //       mode: Mode.overlay, // Mode.fullscreen
                    //     ).then((onValue)
                    //     {
                    //       if(onValue==null)
                    //       {

                    //       }
                    //       else
                    //       {
                    //         displayPrediction(onValue);
                    //       }

                    //     });
                  },
                  decoration: InputDecoration(hintText: "Enter Country"),
                ),
              ),
              // _dropdown(1),
              SizedBox(
                height: 20,
              ),
              _title("State"),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .06,
                child: TextField(
                  controller: state,
                  decoration: InputDecoration(hintText: "Enter State"),
                ),
              ),
              //_dropdown(2),
              SizedBox(
                height: 20,
              ),

              _title("City"),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .06,
                child: TextField(
                  controller: city,
                  decoration: InputDecoration(hintText: "Enter City"),
                ),
              ),
              //_dropdown(3),
              SizedBox(
                height: 20,
              ),
              _title("Address"),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .06,
                child: TextField(
                  controller: address,
                  decoration: InputDecoration(hintText: "Enter Address"),
                ),
              ),
              // _textField("new Address"),
              _makeDefault()
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

  Widget _makeDefault() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Text("Make default Delivery Address",
                style: TextStyle(
                    color: HexColor("#9E9E9E"),
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Switch(
              value: switchh,
              onChanged: (val) {
                setState(() {
                  switchh ? switchh = false : switchh = true;
                });
              },
            ),
          ),
        ],
      ),
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
            value: _selectedCatagory,
            onChanged: (newValue) {
              setState(() {
                _selectedCatagory = newValue;
              });
            },
            items: id == 1
                ? _country.map((catagory) {
                    return DropdownMenuItem(
                      child: new Text(catagory),
                      value: catagory,
                    );
                  }).toList()
                : id == 2
                    ? _state.map((catagory) {
                        return DropdownMenuItem(
                          child: new Text(catagory),
                          value: catagory,
                        );
                      }).toList()
                    : _city.map((catagory) {
                        return DropdownMenuItem(
                          child: new Text(catagory),
                          value: catagory,
                        );
                      }).toList()));
  }

  Widget _textField(String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      height: 40,
      width: double.infinity,
      child: TextFormField(
        controller: contact,
        maxLength: 13,
        keyboardType: TextInputType.number,
        cursorColor: HexColor("#9E9E9E"),
        style: TextStyle(
            fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: title,
          counterText: "",
          focusColor: Colors.orange,
        ),
      ),
    );
  }

  Widget _bottomBar() {
    return Container(
      height: MediaQuery.of(context).size.height * .07,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Expanded(
          //   child: Container(
          //     margin: EdgeInsets.only(left: 10, right: 20, bottom: 5),
          //     child: BottomButton(
          //       name: "Back",
          //       customColor: true,
          //       color: HexColor("#D41111"),
          //       ontap: () {
          //         setState(() {
          //           addnew = false;
          //         });
          //       },
          //     ),
          //   ),
          // ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 10, bottom: 5),
              child: BottomButton(
                name: "Save",
                customColor: true,
                color: HexColor("#FF6D2B"),
                ontap: () {
                  if (addnew == true) {
                    addNewAddress();
                  } 
                  
                  // else {
                  //   setState(() {
                  //     User.userData.index = selectedAddress;
                  //   });
                  //   getdeliveryCost();
                  //   //AppRoutes.replace(context, CheckOut());
                  // }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
