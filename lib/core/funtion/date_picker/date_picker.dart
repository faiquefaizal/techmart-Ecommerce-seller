import 'package:flutter/material.dart';

Future<DateTime?> giveSelectedDate(BuildContext context) async {
  return showDatePicker(
    context: context,
    firstDate: DateTime(2025),
    lastDate: DateTime(2100),
  );
}
