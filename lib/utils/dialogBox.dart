import 'package:flutter/material.dart';
import 'package:transact/utils/utils.dart';

class DialogBox extends StatefulWidget {
  String title;
  Widget child;
  String buttonName;
  Function ontap;
  DialogBox({
    this.title,
    this.child,
    this.buttonName,
    this.ontap,
  });
  @override
  _DialogBoxState createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      contentPadding: EdgeInsets.only(top: 10.0),
      content: Container(
        width: MediaQuery.of(context).size.width / 1.2,
       // height: MediaQuery.of(context).size.height * .2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
                alignment: Alignment.center,
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
            SizedBox(
              height: 5.0,
            ),
            Center(child: widget.child),
            GestureDetector(
              onTap: widget.ontap,
              child: Center(
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * .06,
                  decoration: BoxDecoration(
                    color: HexColor("#3B444B"),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12.0),
                        bottomRight: Radius.circular(12.0)),
                  ),
                  child: Center(
                    child: Text(
                      widget.buttonName,
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
