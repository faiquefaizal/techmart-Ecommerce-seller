import 'package:flutter/material.dart';

class Validation {
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Email cannot be empty";
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return "Enter a valid email";
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Password cannot be empty";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  static String? businessNameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Business name is required';
    }
    return null;
  }

  static String? nameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  static String? confirmPasswordValidator(
    String? value,
    TextEditingController passwordController,
  ) {
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? phoneNumberValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
  }
}
