import 'dart:io';

import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';



// Validate if the mobile number is 10 digits long
String? validateMobileNumber(String? value, {bool isRequired = true}) {
  if (isRequired && (value == null || value.trim().isEmpty)) {
    return "Mobile number is required";
  } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value ?? '')) {
    return "Enter a valid 10-digit mobile number";
  }
  return null; // No error
}


Future<String> getDeviceId() async {
  final deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    //return androidInfo.id ?? androidInfo.androidId!;
    return androidInfo.id;
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    return iosInfo.identifierForVendor!;
  }
  return 'unknown-device';
}



