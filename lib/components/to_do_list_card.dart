import 'package:flutter/material.dart';
import 'package:daily_thrive/constant.dart';

class ToDoListCard extends StatefulWidget {
  final String text;
  final double height;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  const ToDoListCard({
    Key? key,
    required this.text,
    this.height = 100.0,
    this.margin = const EdgeInsets.all(10.0),
    this.padding = const EdgeInsets.all(10.0),
  }) : super(key: key);

  @override
  _ToDoListCardState createState() => _ToDoListCardState();
}

class _ToDoListCardState extends State<ToDoListCard> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      padding: widget.padding,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFFCDC1FF),
      ),
      child: Row(
        children: <Widget>[
          Transform.scale(
            scale: 1.9,
            child: Checkbox(
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value ?? false;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              side: const BorderSide(
                color: Colors.black87,
                width: 1.0,
                style: BorderStyle.solid,
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.text,
                style: kBodyTextStyle,
              ),
            ),
          )
        ],
      ),
    );
  }
}
