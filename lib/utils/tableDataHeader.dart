import 'package:flutter/material.dart';
import 'package:transact/utils/utils.dart';

class TableDataHeader extends StatelessWidget {
  String c1;
  String c2;
  String c3;
  String c4;
  TableDataHeader({
    this.c1,
    this.c2,
    this.c3,
    this.c4,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.05,
      decoration: BoxDecoration(
        color: HexColor("#3B444B"),
      ),
      child: Row(
        children: <Widget>[
          Expanded(child: _rowText(this.c1, "white")),
          Expanded(child: _rowText(this.c2, "white")),
          Expanded(child: _rowText(this.c3, "white")),
          this.c4 == null ? Container() : Expanded(child: _rowText(this.c4, "white")),
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
}
