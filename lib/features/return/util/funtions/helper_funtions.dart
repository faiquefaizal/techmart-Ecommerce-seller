import 'package:flutter/material.dart';

Color returnColorFromStatus(String status) {
  switch (status) {
    case "returnRequest":
      return Colors.orange;
    case "Approved":
      return Colors.green;
    case "Rejected":
      return Colors.red;
  }
  throw Exception("Invalid Status");
}
