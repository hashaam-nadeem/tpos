import 'package:flutter/material.dart';
import 'package:transact/utils/utils.dart';

class BottomButton extends StatefulWidget {
  String name;
  Image image;
  bool customColor;
  Color color;
  Function ontap;
  BottomButton({
    this.image,
    this.name,
    this.ontap,
    this.customColor,
    this.color,
  });
  @override
  _BottomButtonState createState() => _BottomButtonState();
}

class _BottomButtonState extends State<BottomButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      child: Container(
        alignment: Alignment.bottomCenter,
        height: MediaQuery.of(context).size.height * .07,
        width: MediaQuery.of(context).size.width / 1.2,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.name == "PROCEED"
                ? 8
                : widget.name == "APPLY FILTER" ? 30 : 2),
            color: widget.customColor == true
                ? widget.color
                : HexColor("#3B444B")),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: widget.image,
            ),
            SizedBox(
              width: 5,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                widget.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    color:
                        widget.name == "Apply" ? Colors.black : Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
