import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:transact/AppBar.dart';
import 'package:transact/utils/utils.dart';


class PersonalInformation extends StatefulWidget {
  @override
  _PersonalInformationState createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {

  final userNameController = TextEditingController();
  final phoneNo = TextEditingController();
  String country="",state="",city="",address="";
  static const kGoogleApiKey = "AIzaSyBLkci3EngfM5b6hp7X5a9w7bv66xcWs7M";
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  var _selected;
  double lat=0.0;double long=0.0;
 // final phoneNo = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _button(1), 
              _button(2)],
          ),
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: CustomeAppBar(
            homepage: false,
            title: "Personal Information",
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 1.24,
                    child: _textField("Full Name",1,userNameController),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 1.24,
                    child: _textField("Phone No",2,phoneNo),
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center,
              
              children: <Widget>[
                countryList("Country"),
                
              ],
              ),
               Row(mainAxisAlignment: MainAxisAlignment.center,
              
              children: <Widget>[
                stateList("State"),
                
              ],
              ),
               Row(mainAxisAlignment: MainAxisAlignment.center,
              
              children: <Widget>[
                 stateList("City"),
                
              ],
              )
            ],
          ),
        ),
     
        ),
      ),
    );
  }

displayPrediction(Prediction p) async
{
  PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(p.placeId);
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;
      var first;
      var addresses;
                              print("address");
                              final coordinates = new Coordinates(lat, long);
                              addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
                              first = addresses.first;
                              print("${first.featureName} : ${first.addressLine}");
                              setState(() {
                                country=first.countryName;
                                state=first.adminArea;
                                city=first.locality;
                                address=first.featureName;
                              });
                              print(country);
                              print(state);
                              print(city);
                              print(address);
}


Widget addressList()
{
  return 
GestureDetector(
  onTap: () async
  {
    Prediction p = await PlacesAutocomplete.show(
                          context: context,
                          apiKey: kGoogleApiKey,
                          mode: Mode.overlay, // Mode.fullscreen
                        ).then((onValue)
                        {
                          displayPrediction(onValue);
                        });
  },
  child:   Container(
    margin: EdgeInsets.only(top:10),
    width: MediaQuery.of(context).size.width*.8,
    height: MediaQuery.of(context).size.height*.08,
    padding: EdgeInsets.only(left:10,right:10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border.all(color:HexColor("#707070"))
    ),
    child:Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Address"),
            Image.asset('images/polygon.png',scale: 3,),
          ],
        ),
      ],
    ),
    // CountryPicker(
    //       dense: false,
          
    //        showFlag: false,  //displays flag, true by default
    //       showDialingCode: true, //displays dialing code, false by default
    //       showName: true,
    //       showCurrency: false, //eg. 'British pound'
    //       showCurrencyISO: false,
    //        //eg. 'GBP'
    //       onChanged: (Country country) {
    //         setState(() {
    //           _selected = country;
              
    //         });
    //       },
    //       selectedCountry: _selected,
    //     ),
  )
);
}
 
Widget stateList(label)
{
  return 
GestureDetector(
  onTap: () async
  {
    Prediction p = await PlacesAutocomplete.show(
                          context: context,
                          apiKey: kGoogleApiKey,
                          mode: Mode.overlay, // Mode.fullscreen
                        ).then((onValue)
                        {
                          displayPrediction(onValue);
                        });
  },
  child:   Container(
    margin: EdgeInsets.only(top:10),
    width: MediaQuery.of(context).size.width*.8,
    height: MediaQuery.of(context).size.height*.08,
    padding: EdgeInsets.only(left:10,right:10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border.all(color:HexColor("#707070"))
    ),
    child:Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("$label"),
            Image.asset('images/polygon.png',scale: 3,),
          ],
        ),
      ],
    ),
    // CountryPicker(
    //       dense: false,
          
    //        showFlag: false,  //displays flag, true by default
    //       showDialingCode: true, //displays dialing code, false by default
    //       showName: true,
    //       showCurrency: false, //eg. 'British pound'
    //       showCurrencyISO: false,
    //        //eg. 'GBP'
    //       onChanged: (Country country) {
    //         setState(() {
    //           _selected = country;
              
    //         });
    //       },
    //       selectedCountry: _selected,
    //     ),
  )
);
}
 
Widget countryList(label)
{
  return 
GestureDetector(
  onTap: () async
  {
    Prediction p = await PlacesAutocomplete.show(
                          context: context,
                          apiKey: kGoogleApiKey,
                          mode: Mode.overlay, // Mode.fullscreen
                        ).then((onValue)
                        {
                          displayPrediction(onValue);
                        });
  },
  child:   Container(
    margin: EdgeInsets.only(top:10),
    width: MediaQuery.of(context).size.width*.8,
    height: MediaQuery.of(context).size.height*.08,
    padding: EdgeInsets.only(left:10,right:10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border.all(color:HexColor("#707070"))
    ),
    child:Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("$label"),
            Image.asset('images/polygon.png',scale: 3,),
          ],
        ),
      ],
    ),
    // CountryPicker(
    //       dense: false,
          
    //        showFlag: false,  //displays flag, true by default
    //       showDialingCode: true, //displays dialing code, false by default
    //       showName: true,
    //       showCurrency: false, //eg. 'British pound'
    //       showCurrencyISO: false,
    //        //eg. 'GBP'
    //       onChanged: (Country country) {
    //         setState(() {
    //           _selected = country;
              
    //         });
    //       },
    //       selectedCountry: _selected,
    //     ),
  )
);
}
 
 
 Widget _textField( String label, id, _controller) {
    return Container(
      margin: id == 1
          ? EdgeInsets.only(top: 50, bottom: 10)
          : id == 3
              ? EdgeInsets.only(top: 20, bottom: 5)
              : EdgeInsets.symmetric(vertical: 2),
      height: MediaQuery.of(context).size.height * .08,
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

  _button(int id) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width*.3,
        decoration: BoxDecoration(
          color: Color(0xff3B444B),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Center(
          child: Text(id == 1 ? "Clear" : "Save",style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}
