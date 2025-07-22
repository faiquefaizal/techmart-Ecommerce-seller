import 'package:flutter/widgets.dart';

void resetForm(List<TextEditingController> controllers) {
  for (var controller in controllers) {
    controller.clear();
  }
}
