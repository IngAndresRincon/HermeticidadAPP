import 'package:flutter/material.dart';

import '../Tools/complements.dart';

class CustomerTextFieldLogin extends StatelessWidget {
  final String? label;
  final TextInputType textinputtype;
  final bool obscure;
  final IconData icondata;
  final TextEditingController texteditingcontroller;
  final bool bsuffixIcon;
  final IconData suffixIcon;
  final VoidCallback onTapSuffixIcon;
  final double width;
  final Color labelColor;
  final Color textColor;

  const CustomerTextFieldLogin(
      {super.key,
      required this.label,
      required this.textinputtype,
      required this.obscure,
      required this.icondata,
      required this.texteditingcontroller,
      required this.bsuffixIcon,
      required this.onTapSuffixIcon,
      required this.suffixIcon,
      required this.width,
      required this.labelColor,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getScreenSize(context).width * width,
      margin: EdgeInsets.all(getScreenSize(context).width * 0.01),
      child: TextFormField(
        controller: texteditingcontroller,
        keyboardType: textinputtype,
        obscureText: obscure,
        style: TextStyle(color: textColor, fontSize: 14),
        validator: (value) {
          if (value.toString().isEmpty) {
            return 'Valor de camo no valido';
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(20),
            prefixIcon: Container(
              margin: const EdgeInsets.all(5),
              color: Colors.transparent,
              width: 20,
              height: 20,
              child: Icon(
                icondata,
                color: textColor,
              ),
            ),
            suffixIcon: bsuffixIcon
                ? InkWell(
                    onTap: onTapSuffixIcon,
                    child: Icon(suffixIcon),
                  )
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            labelText: label,
            labelStyle: TextStyle(color: labelColor)),
      ),
    );
  }
}

class CustomerTextFormField extends StatelessWidget {
  final String? label;
  final TextInputType textinputtype;
  final bool obscure;
  final IconData icondata;
  final TextEditingController texteditingcontroller;
  final bool bsuffixIcon;
  final IconData suffixIcon;
  final VoidCallback onTapSuffixIcon;
  final Function(String value) onChange;
  final double width;
  final Color labelColor;
  final Color textColor;

  const CustomerTextFormField(
      {super.key,
      required this.label,
      required this.textinputtype,
      required this.obscure,
      required this.icondata,
      required this.texteditingcontroller,
      required this.bsuffixIcon,
      required this.onTapSuffixIcon,
      required this.suffixIcon,
      required this.width,
      required this.labelColor,
      required this.textColor,
      required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getScreenSize(context).width * width,
      margin: EdgeInsets.all(getScreenSize(context).width * 0.01),
      child: TextFormField(
        controller: texteditingcontroller,
        keyboardType: textinputtype,
        obscureText: obscure,
        style: TextStyle(color: textColor, fontSize: 14),
        validator: (value) {
          if (value.toString().isEmpty) {
            return 'Valor de camo no valido';
          }
        },
        onChanged: onChange,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(20),
            prefixIcon: Container(
              margin: const EdgeInsets.all(5),
              color: Colors.transparent,
              width: 20,
              height: 20,
              child: Icon(
                icondata,
                color: textColor,
              ),
            ),
            suffixIcon: bsuffixIcon
                ? InkWell(
                    onTap: onTapSuffixIcon,
                    child: Icon(suffixIcon),
                  )
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            labelText: label,
            labelStyle: TextStyle(color: labelColor)),
      ),
    );
  }
}
