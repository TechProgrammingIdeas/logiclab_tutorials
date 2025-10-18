import 'package:flutter/material.dart';




// Validate if the mobile number is 10 digits long
String? validateMobileNumber(String? value, {bool isRequired = true}) {
  if (isRequired && (value == null || value.trim().isEmpty)) {
    return "Mobile number is required";
  } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value ?? '')) {
    return "Enter a valid 10-digit mobile number";
  }
  return null; // No error
}



