import 'package:flutter/material.dart';

class LiveTVButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final IconData? icon;

  final Color? color;

  LiveTVButton({required this.buttonText, required this.onPressed, this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor:color?? Colors.red, // Change the color according to your design
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 15.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon ?? Icons.live_tv,
            color: Colors.white,
            size: 18,
          ),
          SizedBox(width: 8.0),
          Text(
            buttonText,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
