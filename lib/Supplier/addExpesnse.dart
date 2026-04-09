import 'dart:io';
import 'dart:ui';

import 'package:dashed_container/dashed_container.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:transact/AppBar.dart';
import 'package:transact/Model/apismodel.dart';
import 'package:transact/Model/getauthentication.dart';
import 'package:transact/Model/headersmodel.dart';

import 'package:transact/utils/bottomButton.dart';
import 'package:transact/utils/datetimepicker.dart';

import 'package:transact/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class AddExpense extends StatefulWidget {
  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final format = DateFormat("yyyy-MM-dd HH:mm");
  List<String> _catagory = [
    'Shipment',
    'New purchase',
    'employee salary',
    'Accessories'
  ];
  DateTime sDate;
  ProgressDialog pr;
  var invoiceNum = TextEditingController();
  var expenseName = TextEditingController();
  var qty = TextEditingController();
  var cost = TextEditingController();
  var totalExpanse = TextEditingController();
  var descrip = TextEditingController();
  File image;
  String _selectedCatagory = "";
  HeadersModel headersModel = HeadersModel();
  var formattedTime = new DateFormat("dd-MM-yyyy hh:mm").format(DateTime.now());
  List<String> categories = List<String>();

  getheaders() async {
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var response = await http.get(
      "${API.HeadList}?type=1",
      headers: header,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      if (Json['Data']['WithError'] == false) {
        setState(() {
          headersModel = HeadersModel.fromJson(Json['Data']);
        });
        for (int i = 0; i < headersModel.result.length; i++) {
          _selectedCatagory = headersModel.result[0].name;
          categories.add(headersModel.result[i].name);
        }
      } else {
        Fluttertoast.showToast(
            msg: "${Json['data']['ShortMessage']}",
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

  Future getImage() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((onValue) {
      print(onValue);
      if (onValue == null) {
      } else {
        setState(() {
          image = onValue;
          print(image.toString());
          // _imageList.add(_image);
          // j = 0;
          // selectedImage = _imageList[j];
          // l++;
        });
      }
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
         // User.userData.userResult.imageUrl=img;
        });
        pr.dismiss();
        //  Fluttertoast.showToast(
        //       msg: "Image Updated",
        //       textColor: Colors.white,
        //       backgroundColor: Colors.blueGrey);
        print("Image url: " + img);
        saveExpense(img);
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
  saveExpense(String img) async {
    int headId;
    print(img);
   
    for(int i=0;i<categories.length;i++)
    {
      if(_selectedCatagory==headersModel.result[i].name)
      {
        setState(() {
          headId=headersModel.result[i].id;
        });
        break;
      }
    }
    var header = {
      "Authorization": AuthenticationUser.getAuthentication(),
    };
    var body = {
      "Title": "${expenseName.text.trim()}",
      "Summary": "${descrip.text.trim()}",
      "ImageFileUrl":"$img",
      "Number": "${invoiceNum.text.trim()}",
      "AccountHeadId": "$headId",
      "Qty": "${qty.text.trim()}",
      "Price": "${cost.text.trim()}",
      "CreatedOn":"$sDate",
      "Total":"${totalExpanse.text.trim()}",
    };
    var response = await http.post(
      "${API.AddGeneral}",
      headers: header,
      body: body,
    );
    var Json = json.decode(response.body);
    print(json.decode(response.body));
    if(response.statusCode==200)
    {
      if (Json['Data']['WithError'] == false)
      {
        pr.dismiss();
          Fluttertoast.showToast(
            msg: "Successfully added",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
            Navigator.of(context).pop();
      }
      else
      {
pr.dismiss();
  Fluttertoast.showToast(
            msg: "${Json['data']['ShortMessage']}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
      }
      
    }
    else
    {
      pr.dismiss();
       Fluttertoast.showToast(
            msg: "reponse status:  ${response.statusCode}",
            textColor: Colors.white,
            backgroundColor: Colors.blueGrey);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getheaders();
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
            title: "Add Expense",
            suffix: false,
          ),
        ),
        bottomNavigationBar: BottomButton(
          name: "SAVE EXPENSE",
          ontap: () {
            // Navigator.pop(context);
            uploadImage(image);
          },
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                // _datePicker(),
                _expenseDetail(),
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
                        height: 30,
                        width: MediaQuery.of(context).size.width*.8,
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
                                                fontSize: 20,
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.bold)),
                                      )
                                    : Text("Select Date",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.bold)),
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
               
                _description(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _expenseDetail() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[


          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.symmetric(vertical: 10),
            height: MediaQuery.of(context).size.height * .14,
            width: MediaQuery.of(context).size.width * .4,
            child: Container(
                child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                        child: Image(
                      height: MediaQuery.of(context).size.height * .06,
                      width: MediaQuery.of(context).size.width * .25,
                      image: image != null
                          ? FileImage(
                              image,
                            )
                          : AssetImage(
                              "images/blankImage1.png",
                            ),
                    )),
                    // GestureDetector(
                    //   onTap: () {
                    //     getImage();
                    //   },
                    //   child: DashedContainer(
                    //     dashColor: Colors.black,
                    //     borderRadius: 1.0,
                    //     dashedLength: 3.0,
                    //     blankLength: 2.0,
                    //     strokeWidth: 1.0,
                    //     child: Container(
                    //       height: MediaQuery.of(context).size.height * .06,
                    //       width: MediaQuery.of(context).size.width * .17,
                    //       child: Icon(
                    //         Icons.add,
                    //         size: 25,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.bottomCenter,
                    height: MediaQuery.of(context).size.height * .04,
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(color: Colors.grey, blurRadius: 5)
                    ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Upload Invoice",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              
              ],
            )),
          ),
  
          _title("Invoice number"),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 40,
            child: TextFormField(
              cursorColor: HexColor("#9E9E9E"),
              style: TextStyle(fontSize: 16, fontFamily: "CaviarDreams"),
              controller: invoiceNum,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                isDense: true,
                focusColor: Colors.orange,

                // filled: true,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          _title("Expense Name"),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 40,
            child: TextFormField(
              controller: expenseName,
              cursorColor: HexColor("#9E9E9E"),
              style: TextStyle(fontSize: 16, fontFamily: "CaviarDreams"),
              decoration: InputDecoration(
                isDense: true,
                focusColor: Colors.orange,

                // filled: true,
              ),
            ),
          ),
          _title("Expense Head"),
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
              hint: Text('Choose a Catagory'), // Not necessary for Option 1
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

          /////////////////////////////////////////////////////////////////
        
          Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _title("Quantity"),
                    Container(child: _textFormField("120", qty))
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _title("Cost"),
                    _textFormField("\$100", cost)
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    
                    _title("Total Expense"),
                    _textFormField("\$900", totalExpanse),
                  ],
                ),
              ),
            ],
          ),
          ///////////////////////////////////////////////

        
        ],
      ),
    );
  }

  /////////////////////////////////////////////////////////////////////////////

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
  ///////////////////////// TextField //////////////////////////////////////

  Widget _textFormField(String label, _controller) {
    return Container(
      child: TextFormField(
        controller: _controller,
        onTap: ()
        {
          if(_controller==qty)
          {
            cost.clear();
            totalExpanse.clear();
          }
        },
        onChanged: (value)
        {
          if(label=="\$100")
          {
            double a=double.parse(cost.text.trim());
            double b=double.parse(qty.text.trim());
            double c= a*b;
            totalExpanse.text=c.toString(); 
          }
        },
        keyboardType: TextInputType.number,
        enabled: label=="\$900"?false:true,
        decoration: InputDecoration(
            isDense: true,
            hintText: "$label",
            hintStyle: TextStyle(
              fontSize: 14,
              
            )),
      ),
    );
  }
  ////////////////////////// Description //////////////////////////////////

  Widget _description() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
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
                controller: descrip,
                decoration: InputDecoration(
                    hintText: "Write Desription....",
                    hintStyle:
                        TextStyle(fontSize: 14, color: HexColor('#9E9E9E')),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
          ]),
    );
  }

  Widget _datePicker() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10.0, left: 10, right: 10),
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
