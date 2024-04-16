import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Tools/complements.dart';

class CustomerDropDownButton extends StatelessWidget {
  final Function(String? value) onChange;
  const CustomerDropDownButton({super.key, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getScreenSize(context).width * 0.7,
      child: DropdownButtonFormField(
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.label),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            labelText: "Autorización"),
        items: ["SI", "NO"].map((e) {
          return DropdownMenuItem(
            value: e,
            child: SizedBox(
              width: double.infinity,
              child: Text(
                e,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }).toList(),
        onChanged: onChange,
        isDense: true,
        isExpanded: true,
      ),
    );
  }
}
