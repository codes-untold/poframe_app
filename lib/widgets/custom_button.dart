import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final buttonText;
  final color;
  Function function;
  double top;
  double bottom;
  double right;
  double left;

  CustomButton(
      {this.color,
      this.buttonText,
      required this.function,
      this.top = 15,
      this.bottom = 15,
      this.left = 70,
      this.right = 70});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        function();
      },
      child: Text(buttonText),
      style: ElevatedButton.styleFrom(
          padding:
              const EdgeInsets.only(left: 70, right: 70, top: 15, bottom: 15),
          primary: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
    );
  }
}
