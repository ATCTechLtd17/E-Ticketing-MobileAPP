import 'package:flutter/material.dart';

Widget inputField(IconData icon, String label, String value, {bool readOnly = false}){
  return TextField(
    controller: TextEditingController(text: value),
    readOnly: readOnly,
    decoration: InputDecoration(
      prefixIcon: Icon(icon),
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10)
      ),
    ),
  );
}