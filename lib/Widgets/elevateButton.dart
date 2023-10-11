import 'package:flutter/material.dart';

import '../Tools/complements.dart';

class CustomerElevateButton extends StatelessWidget {
  final double width;
  final double height;
  final String texto;
  final Color colorTexto;
  final Color colorButton;
  final VoidCallback onPressed;
  const CustomerElevateButton(
      {super.key,
      required this.texto,
      required this.colorTexto,
      required this.colorButton,
      required this.onPressed,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getScreenSize(context).width * width,
      height: getScreenSize(context).height * height,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              elevation: 20, backgroundColor: colorButton),
          child: Text(
            texto,
            style: TextStyle(
                color: colorTexto,
                fontSize: 18,
                letterSpacing: 2,
                fontWeight: FontWeight.bold),
          )),
    );
  }
}
