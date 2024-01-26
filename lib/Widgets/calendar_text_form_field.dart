import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomerCalendarTextFormField extends StatefulWidget {
  final double width;
  final IconData icon;
  final String label;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController controller;
  final bool isInputFormat;
  final bool isEmail;
  final Function() selecDate;

  // final Function onChanged;
  const CustomerCalendarTextFormField(
      {super.key,
      required this.width,
      required this.icon,
      required this.label,
      required this.keyboardType,
      required this.obscureText,
      required this.controller,
      required this.isInputFormat,
      required this.isEmail,
      required this.selecDate});

  @override
  State<CustomerCalendarTextFormField> createState() =>
      _CustomerCalendarTextFormFieldState();
}

class _CustomerCalendarTextFormFieldState
    extends State<CustomerCalendarTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * widget.width,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        inputFormatters: widget.isInputFormat
            ? [FilteringTextInputFormatter.digitsOnly]
            : [],
        obscureText: widget.obscureText,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(20),
            prefixIcon: Icon(widget.icon),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            labelText: widget.label,
            suffixIcon: GestureDetector(
              onTap: () => widget.selecDate(),
              child: const Icon(Icons.calendar_today),
            )),
      ),
    );
  }
}
