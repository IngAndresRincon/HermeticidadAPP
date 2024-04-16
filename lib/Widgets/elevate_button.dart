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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    5.0), // Modificar el radio del borde aquí
              ),
              elevation: 10,
              backgroundColor: colorButton),
          child: Text(
            texto,
            style: TextStyle(
                color: colorTexto,
                fontFamily: 'MontSerrat',
                fontSize: getScreenSize(context).width * 0.04,
                letterSpacing: 1,
                fontWeight: FontWeight.w700),
          )),
    );
  }
}
