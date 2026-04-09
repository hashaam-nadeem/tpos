import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectDate extends StatefulWidget {
  
  @override
  _SelectDateState createState() => _SelectDateState();
}

class _SelectDateState extends State<SelectDate> {
  String _value = 'Select Date';
  TextEditingController _dateController;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 8.0
        )
      ]),
      child: TextFormField(
        showCursor: false,
        autofocus: false,
        onTap: () {
          _selectDate();
        },
        readOnly: true,
        controller: _dateController,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            isDense: true,
            filled: true,
            hintText: _value,
            // labelText: "Date",
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

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2012),
        lastDate: new DateTime.now());
    if (picked != null) setState(() => _value=DateFormat("dd-MM-yyyy").format(picked).toString());
  }
}
