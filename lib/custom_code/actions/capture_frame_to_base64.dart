// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
import 'dart:convert';

Future<String> captureFrameToBase64(FFUploadedFile photoFile) async {
  // Convert the bytes of the uploaded file directly to Base64
  if (photoFile.bytes == null) {
    return "";
  }
  return base64Encode(photoFile.bytes!);
}
