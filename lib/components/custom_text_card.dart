import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final double containerHeight;
  final double containerWidth;
  final double iconContainerSize;
  final Color backgroundColor;
  final Color iconContainerColor;
  final Color iconColor;
  final List<BoxShadow> boxShadows;

  const CustomTextButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPressed,
    this.containerHeight = 180.0,
    this.containerWidth = 180.0,
    this.iconContainerSize = 60.0,
    this.backgroundColor = const Color(0xFFCCDF92),
    this.iconContainerColor = Colors.white,
    this.iconColor = Colors.black,
    this.boxShadows = const [
      BoxShadow(
        color: Colors.grey,
        spreadRadius: 2,
        blurRadius: 10,
        offset: Offset(4, 4),
      ),
    ],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      child: Container(
        height: containerHeight,
        width: containerWidth,
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: boxShadows,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: iconContainerSize,
              height: iconContainerSize,
              decoration: BoxDecoration(
                color: iconContainerColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: iconContainerSize - 10,
                color: iconColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'RobotoMedium',
                  fontWeight: FontWeight.w900,
                  color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
