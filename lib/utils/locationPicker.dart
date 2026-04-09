import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:transact/Buyer/buyerAddress.dart';
import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/utils/routes.dart';


class PlacePickerClass extends StatefulWidget {
  @override
  _PlacePickerClassState createState() => _PlacePickerClassState();
}

class _PlacePickerClassState extends State<PlacePickerClass> {
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(31.4544247, 74.2766182);
  List<Map<dynamic, dynamic>> list = [];
  String country="",state="",city="",adress="";
  Map address = {};

  Set<Marker> marker = new Set();
  ProgressDialog pr;
  LatLng _lastMapPosition = _center;
  double lat = 0.0;
  double long = 0.0;
  double delLat = 0.0;
  double delLong = 0.0;

  @override
  void initState() {
    super.initState();
  }
  addNewAddress() async {
    if (country=="" ||
        city=="" ||
        state=="" ||
        
        address.isEmpty) {
      Fluttertoast.showToast(
          msg: "please Select the Address.",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    } else {
      pr.show();
      var header = {
        "Authorization": AuthenticationUser.getAuthentication(),
      };
      var body = {
        "Country": "$country",
        "State": "$state",
        "City": "$city",
        "Address": "$adress",
        "Contact": "",
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
        if (Json['Data']['WithError'] == false) {
          pr.dismiss();
          Fluttertoast.showToast(
              msg: "${Json['Data']['ShortMessage']}",
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey);
              AppRoutes.replace(context, BuyerAdress());
              
              // setState(() {

              //   // addnew=false;
              //   //   contact.clear();
              //   //   enterCountry.clear();
              //   //   state.clear();
              //   //   city.clear();
              //   //   address.clear();
              // });
          //getAddress();
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
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: selectmap(),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(
                        top: 40, bottom: 40, left: 10, right: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      address["addressLine"] ?? "",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      padding: EdgeInsets.all(20),
                      color: Colors.blueGrey,
                      child: Text(
                        "Pick Location",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        addNewAddress();
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget selectmap() {
    return GoogleMap(
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
            target: LatLng(31.476954700000004, 74.28921989999999), zoom: 14.0),
        onTap: (latLong) {
          setMarker(latLong);
        },
        mapType: MapType.normal,
        onMapCreated: _onMapCreated,
        onCameraMove: _onCameraMove,
        markers: marker);
  }

  Future setMarker(LatLng latLng) async {
    final coordinates = new Coordinates(latLng.latitude, latLng.longitude);
    List<Address> addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    print("${addresses.first.featureName} : ${addresses.first.addressLine}");
    setState(() {
      address = addresses[0].toMap();
      adress=addresses.first.addressLine;
      User.userData.addressLine=addresses.first.addressLine;
      country=addresses.first.countryName;
      city=addresses.first.locality;
      state=addresses.first.adminArea;
      print(address);
      print(city);
      print(state);
      print(country);
      marker.clear();
      lat = latLng.latitude;
      long = latLng.longitude;

      marker.add(
        Marker(
          markerId: MarkerId("selected-location"),
          position: latLng,
        ),
      );
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }
}
