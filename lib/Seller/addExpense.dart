import 'dart:ui';

import 'package:dashed_container/dashed_container.dart';
import 'package:flutter/material.dart';
import 'package:transact/AppBar.dart';

import 'package:transact/utils/bottomButton.dart';
import 'package:transact/utils/datetimepicker.dart';

import 'package:transact/utils/utils.dart';

import 'package:intl/intl.dart';

class AddExpenseSeller extends StatefulWidget {
  @override
  _AddExpenseSellerState createState() => _AddExpenseSellerState();
}

class _AddExpenseSellerState extends State<AddExpenseSeller> {
  final format = DateFormat("yyyy-MM-dd HH:mm");
  List<String> _catagory = [
    'Shipment',
    'New purchase',
    'employee salary',
    'Accessories'
  ];

  String _selectedCatagory;

  var formattedTime = new DateFormat("dd-MM-yyyy hh:mm").format(DateTime.now());

  @override
  Widget build(BuildContext context) {
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
            Navigator.pop(context);
          },
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                _datePicker(),
                _expenseDetail(),
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
          _title("Invoice number"),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 40,
            child: TextFormField(
              cursorColor: HexColor("#9E9E9E"),
              style: TextStyle(fontSize: 16, fontFamily: "CaviarDreams"),
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
              items: _catagory.map((catagory) {
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
                    Container(child: _textFormField("120"))
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
                  children: <Widget>[_title("Cost"), _textFormField("\$100")],
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
                    _textFormField("\$900"),
                  ],
                ),
              ),
            ],
          ),
          ///////////////////////////////////////////////

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
                      width: MediaQuery.of(context).size.width * .19,
                      image: AssetImage("images/blankImage1.png"),
                    )),
                    DashedContainer(
                      dashColor: Colors.black,
                      borderRadius: 1.0,
                      dashedLength: 3.0,
                      blankLength: 2.0,
                      strokeWidth: 1.0,
                      child: Container(
                        height: MediaQuery.of(context).size.height * .06,
                        width: MediaQuery.of(context).size.width * .17,
                        child: Icon(
                          Icons.add,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {},
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

  Widget _textFormField(String label) {
    return Container(
      child: TextFormField(
        decoration: InputDecoration(
            isDense: true,
            hintText: "$label",
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
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
