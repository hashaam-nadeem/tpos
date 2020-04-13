import 'package:flutter/material.dart';

class ToggleButton extends StatefulWidget {
  ToggleButton(
      {@required this.isSelected,
      final List<bool> selection,
      this.textColor,
      this.child1Title,
      this.child2Title,
      this.child3Title,
      this.buttonCount,
      this.child4Title,
      this.onPress});
  final List<bool> isSelected;

  var textColor;
  final child1Title;
  Function onPress;
  final child2Title;
  final child3Title;
  final child4Title;
  final buttonCount;
  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  int val = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * .8,
      child: ToggleButtons(
        fillColor: Colors.white,
        borderColor: Colors.white,
        color: Colors.white,
        selectedColor: Colors.black,
        selectedBorderColor: Colors.white,
        borderWidth: 1,
        borderRadius: BorderRadius.circular(3),
        isSelected: widget.isSelected,
        children: widget.buttonCount == 4
            ? <Widget>[
                _child(widget.child1Title),
                _child(widget.child2Title),
                _child(widget.child3Title),
                _child(widget.child4Title),
              ]
            : widget.buttonCount == 3
                ? <Widget>[
                    _child(widget.child1Title),
                    _child(widget.child2Title),
                    _child(widget.child3Title),
                  ]
                : widget.buttonCount == 2
                    ? <Widget>[
                        _child(widget.child1Title),
                        _child(widget.child2Title),
                      ]
                    : <Widget>[
                        _child(widget.child1Title),
                        _child(widget.child2Title),
                      ],
        onPressed: widget.onPress,
      ),
    );
  }

  Widget _child(String name) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Text(
          "$name",
          style: TextStyle(
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ));
  }
}
