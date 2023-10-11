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

  const CustomerTextFieldLogin(
      {super.key,
      required this.label,
      required this.textinputtype,
      required this.obscure,
      required this.icondata,
      required this.texteditingcontroller,
      required this.bsuffixIcon,
      required this.onTapSuffixIcon,
      required this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getScreenSize(context).width * 0.8,
      child: TextField(
        keyboardType: textinputtype,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
            prefixIcon: Container(
              margin: const EdgeInsets.all(5),
              color: Colors.black45,
              width: 20,
              height: 20,
              child: Icon(
                icondata,
                color: Colors.white,
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
            labelStyle: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
