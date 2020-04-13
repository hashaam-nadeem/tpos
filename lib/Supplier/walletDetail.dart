import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transact/AppBar.dart';
import 'package:transact/utils/utils.dart';

class WalletDetail extends StatefulWidget {
  final title;
  const WalletDetail({this.title});
  @override
  _WalletDetailState createState() => _WalletDetailState();
}

class _WalletDetailState extends State<WalletDetail> {
  String _value = 'Select Date';
  var formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  TextEditingController _dateController;

  final dateFormat = DateFormat("dd-mm-yyyy");
  DateTime date;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("#F5F7FA"),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: CustomeAppBar(
            homepage: false,
            title: widget.title,
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              _datePicker(),
              _headerRow(),
              Expanded(child: _listData()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _datePicker() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7),
     // padding: EdgeInsets.symmetric(vertical: 0, horizontal: 2),
      width: MediaQuery.of(context).size.width / 1.2,
      height: MediaQuery.of(context).size.height * 0.07,
      decoration: BoxDecoration(boxShadow: []),
      child: TextFormField(
        readOnly: true,
        onTap: () {
          _selectDate();
        },
        controller: _dateController,
        decoration: InputDecoration(
          isDense: true,
            filled: true,
            hintText: _value,
            fillColor: Colors.white,
            suffixIcon: Icon(
              Icons.calendar_today,
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide())),
      ),
    );
  }

  Widget _headerRow() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.05,
      decoration: BoxDecoration(
        color: HexColor("#3B444B"),
      ),
      child: Row(
        children: <Widget>[
          Expanded(child: _rowText("Order Number", "white")),
          Expanded(child: _rowText("Date", "white")),
          Expanded(child: _rowText("Paid", "white")),
          Expanded(child: _rowText("Type", "white")),
        ],
      ),
    );
  }

  Widget _rowText(String text, String textcolor) {
    return Text(
      "$text",
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: textcolor == "white" ? Colors.white : Colors.black),
    );
  }

////////////////////////////  List to be implemented ////////////////////

  Widget _listData() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        // height: MediaQuery.of(context).size.height * .6,
        decoration: BoxDecoration(),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: 22,
          itemBuilder: (context, int index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 2),
              height: MediaQuery.of(context).size.height * 0.05,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(child: _rowText("00136", "")),
                  Expanded(child: _rowText("12/01/2020", "")),
                  Expanded(child: _rowText("\$324", "")),
                  Expanded(child: _rowText("COD", "")),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

//////////////////////////// Method for Date picker////////////////////////////

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2012),
        lastDate: new DateTime.now());
    if (picked != null) setState(() => _value = picked.toString());
  }
}
