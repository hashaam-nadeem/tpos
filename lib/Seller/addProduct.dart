import 'dart:io';
import 'dart:ui';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:dashed_container/dashed_container.dart';
import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:transact/AppBar.dart';

import 'package:transact/Model/UserModel.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/categoriesmodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/Seller/sellerHome.dart';
import 'package:transact/Supplier/supplierDashBoard.dart';
import 'package:transact/utils/bottomButton.dart';
import 'package:transact/utils/datetimepicker.dart';
import 'package:transact/utils/routes.dart';
import 'package:transact/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

import '../changepass.dart';

class AddProductSeller extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProductSeller> {
  final format = DateFormat("yyyy-MM-dd HH:mm");
  File _image;
  
  int l;
  int imagelength=0;
  DateTime sDate;
  bool check=false;
  int j;
  int del = 0;
  ProgressDialog pr;
  File selectedImage;
  CategoriesModel _categoriesModel = CategoriesModel();
  var description = TextEditingController();
  var inCash = TextEditingController();
  var barCode = TextEditingController();
  var inPercentage = TextEditingController();
  var specification = TextEditingController();
  var productName = TextEditingController();
  var gst = TextEditingController();
  var discount = TextEditingController();
  var salePrice = TextEditingController();
  var addManually = TextEditingController();
  var qty = TextEditingController();
  var minOrder = TextEditingController();
  bool withDiscount = false;
  String barcode = "";
  int qt,order;
  List<String> _catagory = List<String>();
  String selected = "";
  bool selectPercentage = false;
  List<int> _quantity = [10, 20, 30, 40, 50, 100, 130, 150, 200]; // Option 2
  String _selectedCatagory;
  int _selectedQuantity = 10;
  var formattedTime = new DateFormat("dd-MM-yyyy hh:mm").format(DateTime.now());
  List<String> categories = List<String>();
  List<File> _imageList = List<File>();
  String imageListttt="";

  
  getCategoriess() async {
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.post(
      "${API.getCategories}",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == false) {
        setState(() {
          _categoriesModel = CategoriesModel.fromJson(Json['Data']);
        });
        for (int i = 0; i < _categoriesModel.result.length; i++) {
          _selectedCatagory = _categoriesModel.result[0].name;
          categories.add(_categoriesModel.result[i].name);
        }
      } else {
        Fluttertoast.showToast(
            msg: "${Json['Data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      }
    } else {
      Fluttertoast.showToast(
          msg: "${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
    }
  }

  addUserProduct(String img) async {

    
    
    if (selectPercentage==true) {
        setState(() {
          withDiscount = true;
        });
      } else {
        setState(() {
          withDiscount = false;
        });
      }
      int cId;
      for(int k=0;k<_categoriesModel.result.length;k++)
      {
        if(_selectedCatagory==_categoriesModel.result[k].name)
        {
          setState(() {
            cId=_categoriesModel.result[k].id;
          });
        }
      }

      var header = {
        "Authorization": AuthenticationUser.getAuthentication(),
      };
      print(header);
      var body = {
        "Name": "${productName.text.trim()}",
        "Description": "${description.text.trim()}",
        "Code": addManually.text==null?
        "${barcode}"
        : "${addManually.text.trim()}",
        "Qty":"${qty.text.trim()}",
        "Specification": "${specification.text.trim()}",
        "FeatureImageUrl": "$img",
        "ActuallPrice": "${discount.text.trim()}",
        "SalePrice": "${salePrice.text.trim()}",
        "GST": "${gst.text.trim()}",
        "MinOrder": "${minOrder.text.trim()}",
        "TotalDiscount": "${inPercentage.text.trim()}",
        "WithDiscount": "$withDiscount",
        "IsDiscountPercentage": "$selectPercentage",
        "CategoryId": "$cId",
        "Type": "0",
         "ImageUrls": "$imageListttt",
         "CreatedOn":"$sDate"
       // "Detail": "${description.text.trim()}",
      };
      print(body);
      var response = await http.post(
        "${API.addProduct}",
        body: body,
        headers: header,
      );
      print(json.decode(response.body));
      var Json = json.decode(response.body);
      if (response.statusCode == 200) {
        if(Json['Data']['WithError']==true)
        {
           pr.dismiss();
          Fluttertoast.showToast(
          msg: "${Json['Data']['ShortMessage']}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
        }
        else
        {
 pr.dismiss();
 Fluttertoast.showToast(
          msg: "${Json['Data']['ShortMessage']}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
                   setState(() {
            User.userData.barCode="";
          });
          var route=MaterialPageRoute(
            builder: (BuildContext context)=>SellerHome(),
          );
           Navigator.of(context).pushReplacement(route);
           //AppRoutes.push(context, SupplierDashBoard());
        }
      } else {
        pr.dismiss();
         Fluttertoast.showToast(
          msg: "status code: ${response.statusCode}",
          textColor: Colors.white,
          backgroundColor: Colors.blueGrey);
      }

    //_showDialog();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCategoriess();
    User.userData.barCode!=""?
    barcode=User.userData.barCode
    : barcode="";
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
      message: 'Uploading...',
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
        backgroundColor: HexColor("#F5F7FA"),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomeAppBar(
            homepage: false,
            title: "Add Product",
            suffix: false,
          ),
        ),
        bottomNavigationBar: BottomButton(
          name: "Add Product",
          ontap: () {
            // _showDialog();
            uploadImage(_imageList);
          },
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                // _datePicker(),
               
                Row(
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * .4,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: selectedImage != null
                                  ? FileImage(_imageList[j])
                                  : AssetImage('images/applogo.png'),
                              fit: BoxFit.cover),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  width: MediaQuery.of(context).size.width * .1,
                                  height:
                                      MediaQuery.of(context).size.height * .06,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black87,
                                      border: Border.all(
                                          color: Colors.white, width: 2)),
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 15,
                                      ),
                                      onPressed: () {
                                        print("Delete");
                                        if (_imageList.length != 0) {
                                          var g = _imageList.last;
                                          print(g);

                                          setState(() {
                                            if (_imageList[j] ==
                                                selectedImage) {
                                              selectedImage = null;
                                              _imageList.removeAt(j);
                                              j--;
                                            } else {
                                              _imageList.removeAt(j);
                                            }

                                            //  selectedImage=_imageList[i];
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                )),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * .08,
                                  color: Colors.black54,
                                  child: Center(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 10, right: 10),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .94,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .06,
                                          child: ListView.builder(
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return profileselect(index);
                                            },
                                            itemCount: _imageList != null
                                                ? _imageList.length + 1
                                                : 1,
                                            scrollDirection: Axis.horizontal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        ))
                  ],
                ),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                     GestureDetector(
                    onTap: () {
                      Picker(
                          hideHeader: true,
                          adapter: DateTimePickerAdapter(),
                          title: Text("Select Date"),
                          selectedTextStyle: TextStyle(color: Colors.blue),
                          onConfirm: (Picker picker, List value) {
                            print((picker.adapter as DateTimePickerAdapter)
                                .value);
                            setState(() {
                              sDate = (picker.adapter as DateTimePickerAdapter)
                                  .value;
                              // "${(picker.adapter as DateTimePickerAdapter).value.year}-${(picker.adapter as DateTimePickerAdapter).value.month}-${(picker.adapter as DateTimePickerAdapter).value.day}";
                             // eDate = null;
                            });
                            //getMerchantOrderHistory(context, sDate, eDate);
                          }).showDialog(context);
                    },
                    child: Card(
                      elevation: 10,
                      child: Container(
                        //padding: EdgeInsets.only(left: 10, right: 10),
                        height: 50,
                        width: MediaQuery.of(context).size.width*.96,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                sDate != null
                                    ? Flexible(
                                        child: Text("${sDate.day}/${sDate.month}/${sDate.year} ${sDate.hour} : ${sDate.minute}",
                                            overflow: TextOverflow.clip,
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey[600],
                                               // fontWeight: FontWeight.bold
                                                
                                                )),
                                      )
                                    : Text("Select Date",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[600],
                                            //fontWeight: FontWeight.bold
                                            )
                                            ),
                                Icon(
                                  FontAwesomeIcons.calendar,
                                  color: Colors.grey[600],
                                  size: 15,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                 
                  ],
                                  ),
               
                _productDetail(),
                _barCodeSection(),
                _description(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget profileselect(int index) {
    //print(l);
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(left: 10),
        width: MediaQuery.of(context).size.width * .15,
        height: MediaQuery.of(context).size.height * .1,
        decoration: BoxDecoration(
            color: Colors.black26,
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: index == _imageList.length
            ? Center(
                child: IconButton(
                  icon: Icon(Icons.add, color: Colors.white, size: 30),
                  onPressed: () {
                    getImage();
                    if (_image == null) {
                      print("image not selected");
                    } else {
                      setState(() {
                        del++;
                        // index++;
                      });
                    }
                    print("Add new photo");
                  },
                ),
              )
            : Center(child: Image.file(_imageList[index])),
      ),
      onTap: () {
        setState(() {
          j = index;
          selectedImage = _imageList[index];
          print(j);
          // _imageList.removeAt(i);
        });
        // print(index);
      },
    );
  }

  Widget _productDetail() {
    return Container(
      margin: EdgeInsets.all(10),
      color: Colors.white,
      padding: EdgeInsets.all(10),
      //height: MediaQuery.of(context).size.height * .55,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _title("Product Name"),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 40,
            child: TextFormField(
              cursorColor: HexColor("#9E9E9E"),
              controller: productName,
              maxLength: 15,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  ),
              decoration: InputDecoration(
                focusColor: Colors.orange,
                counterText: "",
                // filled: true,
              ),
            ),
          ),
          _title("Select Category"),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 10),
            height: 40,
            child: DropdownButton(
              isExpanded: true,
              icon: Container(
                alignment: Alignment.centerRight,
                child: Icon(Icons.arrow_drop_down),
              ),
              hint: Text(
                  'Please choose a Catagory'), // Not necessary for Option 1
              value: _selectedCatagory,
              onChanged: (newValue) {
                setState(() {
                  _selectedCatagory = newValue;
                });
              },
              items: categories.map((catagory) {
                return DropdownMenuItem(
                  child: new Text(catagory),
                  value: catagory,
                );
              }).toList(),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    _title("Add Quantity"),
                    _textFormField("enter quantity", qty)
                  ],
                ),
              ),
              SizedBox(
                width: 5,
              ),
                Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //_title("Color"),
                    Container(
                      height: 48,
                      color: Colors.white,
                      // TextFormField(
                      //   decoration: InputDecoration(
                      //       suffixIcon: Container(
                      //     height: 10,
                      //     width: 10,
                      //     decoration: BoxDecoration(),
                      //     child: Icon(Icons.add),
                      //   )),
                      // ),
                   
                    )
                  ],
                ),
              ),
            
               Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    _title("Add min order"),
                    _textFormField("min order", minOrder)
                  ],
                ),
              ),
             
            
            ],
          ),

          /////////////////////////////////////////////////////////////////
          ///
           SizedBox(
                height:15,
              ),
          _title("Discount"),
          Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 100,
                      child: Column(
                        children: <Widget>[
                         // _title(""),
                          _textFormField("enter amount", inPercentage)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
             Padding(
               padding: EdgeInsets.only(top:30),
               child:  Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectPercentage = !selectPercentage;
                        discount.clear();
                        salePrice.clear();
                        inPercentage.clear();
                      });
                    },
                    child: Container(
                      // margin: EdgeInsets.only(right:30,top:10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          shape: BoxShape.rectangle),
                      width: 20,
                      height: 20,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                              color: selectPercentage == true
                                  ? Colors.grey
                                  : Colors.white,
                              shape: BoxShape.circle),
                          width: 12,
                          height: 12,
                        ),
                      ),
                    ),
                  ),
                  Text("%   "),
                ],
              ),
             
             ),
             SizedBox(
               width: MediaQuery.of(context).size.width*.17,
             ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _title("GST."),
                    _textFormField("\$3.5", gst),
                  ],
                ),
              ),
            ],
          ),
          ///////////////////////////////////////////////
           SizedBox(
                height:5 ,
              ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _title("Price"),
                    Container(child: _textFormField("Actual Price", discount))
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: _title("")),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .4,
                      child: Column(
                        children: <Widget>[
                          _title(""),
                          _textFormField("Sale Price", salePrice)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _barcode(String text) {
    return GestureDetector(
      child: Container(
        padding: text == 'Scan Barcode' ? EdgeInsets.all(5) : null,
        child: Text("$text",
            style: TextStyle(
                color: HexColor("#9E9E9E"),
                fontFamily: 'Roboto',
                fontSize: 12,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _title(String text) {
    return Container(
      child: Text("$text",
          style: TextStyle(
              color: HexColor("#9E9E9E"),
              fontFamily: 'Roboto',
              fontSize: 12,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget _textFormField(String label, _controller) {
    return Container(
      child: TextFormField(
        inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
        controller: _controller,
        maxLength: _controller==gst?
        6:
        _controller==discount?
        6: _controller==inPercentage?
        6:
        _controller==productName?
        15
        :
        50
        ,
        
        onTap: ()
        {
          if (label == "enter amount")
          {
            salePrice.clear();
            discount.clear();
          }
          else if(label == "\$3.5")
          {
             salePrice.clear();
            discount.clear();
            //inPercentage.clear();
          }
        },
      
        keyboardType: label == "enter amount"
            ? TextInputType.number
            : label == "gst"
                ? TextInputType.number
                : label == "Actual Price"
                    ? TextInputType.number
                    :label == "\$3.5"
                ? TextInputType.number: 
                    label == "enter quantity"
                ? TextInputType.number:
                label == "min order"
                ? TextInputType.number:
                    TextInputType.multiline,

        onChanged: (value) {

          
          if (label == "enter amount") {
            discount.clear();
            salePrice.clear();
          } 
         
          else if (label == "Actual Price") {
            if(gst.text.isEmpty)
            {
              salePrice.text=value;
            }

            else if (inPercentage.text.isEmpty  ) {
              double g=double.parse(gst.text);
              double p=double.parse(discount.text);
              double afterGstDiscount=(g*p)/100;
              // double total=p-afterGstDiscount;
              double a=p+afterGstDiscount;
              setState(() {
                salePrice.text = a.toString();
              });
            } else {
              if (selectPercentage == true) {
                double percent=double.parse(inPercentage.text);
                if(percent>100)
                {
                  Fluttertoast.showToast(
          msg: "Please enter percentage discount less than 100 ",
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.blueGrey);
          inPercentage.clear();
                }
                else
                {
                  double a = double.parse(value);
                double b = double.parse(inPercentage.text);
                 double g;
                gst.text.isEmpty?
               g=0.0:
               g=double.parse(gst.text)
               ;
               print("gst : "+ gst.text);
                setState(() {
                  double afterGstDiscount=(g*a)/100;
                  double h=a+afterGstDiscount;
                  print(h);
                    double t = (h*b)/100;
                     double o=h-t;
                    // double minue=a-t;
                   // double tgst=g+h;
                    //print(tgst);
                    salePrice.text = o.toString(); 
                    
                  });
                }
              } else {
                double a = double.parse(value);
                double b = double.parse(inPercentage.text);
                 double g;
                gst.text.isEmpty?
               g=0.0:
               g=double.parse(gst.text)
               ;
               setState(() {
                 double afterGstDiscount=(g*a)/100;
                 double f=a+afterGstDiscount;
                    double t = f - b;
                     
                    // double o=t+afterGstDiscount;
                    // double tgst=t+o;
                   // print(tgst);
                    
                    salePrice.text = t.toString(); 
                    //salePrice.text = tgst.toString();
                  });
              }
            }
          }
        },
      
        enabled: label == "Sale Price" ? false : 
        
        User.userData.barCode!="" || barcode!="" && label=="0011 3511 0040"?
        false:
        true,
        decoration: InputDecoration(
            hintText: label=="0011 3511 0040"?
            User.userData.barCode!=""?
            "${User.userData.barCode}":
            "$label":"$label"
            ,
            counterText: "",
            hintStyle: TextStyle(
              fontSize: 14,
              
            )),
      ),
    );
  }

  Widget _barCodeSection() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _title("Add Barcode"),
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _title("Add Manually"),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * .4,
                        child: _textFormField("0011 3511 0040", addManually))
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        _barcode("Scan Barcode"),
                        Container(
                          width: 70,
                          height: 25,
                          padding: EdgeInsets.all(2),
                          child: GestureDetector(
                            onTap: () {
                              scan();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(color: Colors.grey, blurRadius: 5)
                                  ]),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image(
                                    image:
                                        AssetImage('images/barcodeReader.png'),
                                  ),
                                  Text("Scan")
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //

                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                          isDense: true,
                          hintText: barcode == '' ? "000 111 000" : "$barcode",
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _description() {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _title("Description"),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: TextField(
                cursorColor: Colors.black,
                maxLines: 6,
                controller: description,
                decoration: InputDecoration(
                    hintText: "Write Description",
                    hintStyle:
                        TextStyle(fontSize: 14, color: HexColor('#9E9E9E')),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            _title("Specification"),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: TextField(
                cursorColor: Colors.black,
                maxLines: 6,
                controller: specification,
                decoration: InputDecoration(
                    hintText: "Write Specification....",
                    hintStyle:
                        TextStyle(fontSize: 14, color: HexColor('#9E9E9E')),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
          ]),
    );
  }

  /////////////////////////////////////// METHODS /////////////////////////////////////////
  Future getImage() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((onValue) {
      print(onValue);
      if (onValue == null) {
      } else {
        setState(() {
          _image = onValue;
          print(_image.toString());
          _imageList.add(_image);
          j = 0;
          selectedImage = _imageList[j];
          // l++;
        });
      }
    });
  }

  uploadImage(List<File> file) async {
    // percent=double.parse(inPercentage.text);
    print(file);
     setState(() {
       imageListttt="";
     });
    List<String> im=List<String>();
    // var qt=int.parse(qty.text);
    // var order=int.parse(minOrder.text);
    // print(order);
    // print(qt);

   if (productName.text.isEmpty || productName.text.length<6 ||
        discount.text.isEmpty  || file == null || 
        minOrder.text.isEmpty || qty.text.isEmpty ||
        description.text.isEmpty || specification.text.isEmpty
        ) {
      // pr.dismiss();
       Fluttertoast.showToast(
          msg: "Please enter the required fields and image, name must be 6 character and specification must be 20 character",
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.blueGrey);
    }

    else if(int.parse(qty.text)<=0 || int.parse(minOrder.text)<=0)
      {
       // pr.dismiss();
       Fluttertoast.showToast(
          msg: "Quantity and Order must not be 0",
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.blueGrey);
      }
      else if(int.parse(qty.text)<int.parse(minOrder.text))
      {
        Fluttertoast.showToast(
          msg: "Quantity must be greater or equal to min_Order",
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.blueGrey);
      }
    else {
      pr.show();
      String img;
     for(int m=0;m<_imageList.length;m++)
     {
        String fileName = file[m].path.split('/').last;
      FormData data = FormData.fromMap({
        "imageFile": await MultipartFile.fromFile(
          file[m].path,
          filename: fileName,
        ),
      });
      print(fileName.toString());
      print(data);
      Dio dio = new Dio();
      dio.options.headers["Authorization"] =
          "${AuthenticationUser.getAuthentication()}";
      dio.options.headers["flag"] = "1";
      dio.post("${API.UploadImage}", data: data).then((imagecall) {
        print("this the image url -----======== $imagecall");
        setState(() {
          img = imagecall.data['Data']['Result'].toString();
          im.add(img);
          print(img[m]);
          if(imageListttt=="")
          {
           setState(() {
          imageListttt = "$img";
        });
          }
          else
          {
            setState(() {
          imageListttt = "$imageListttt,$img";
        });
          }
           imagelength++;
        });
        if(im.length==_imageList.length)
      {
        addUserProduct(img); 
      }
        //  Fluttertoast.showToast(
        //       msg: "Image Updated",
        //       textColor: Colors.white,
        //       backgroundColor: Colors.blueGrey);
        print("Image url: " + img);
       
        //   callAPiImage(context, imageurl);
      }).catchError((onError) {
        pr.dismiss();
        Fluttertoast.showToast(
            msg: "$onError",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      });
     }
     print("images lenght" + imagelength.toString());
     
    }
  }

  Future scan() async {
    try {
      String barcode;
      await BarcodeScanner.scan().then((onValue) {
        setState(() {
          barcode = onValue.toString();
        });
      }).catchError((onError) {
        print(onError);
      });
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'camera permission not granted!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode = '(User returned)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  void _showDialog() {
    showDialog(
        context: context,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: MediaQuery.of(context).size.width / 1.2,
            height: MediaQuery.of(context).size.height * .2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Cogratulations",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 5.0,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text("You have successfully added a product.",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontFamily: "CaviarDreams")),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * .06,
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    decoration: BoxDecoration(
                      color: HexColor("#3B444B"),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0)),
                    ),
                    child: Text(
                      "Add More products",
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

  Widget _datePicker() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 0.0, left: 10, right: 10),
      child: DateTimeField(
        decoration: InputDecoration(
            hintText: "Select Date and Time",
            fillColor: Colors.white,
            filled: true,
            isDense: true,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        format: format,
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            return DateTimeField.combine(date, time);
          } else {
            return currentValue;
          }
        },
      ),
    );
  }
}
class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}