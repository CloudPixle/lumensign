// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Automatic FlutterFlow Imports
import '/custom_code/actions/index.dart';
import 'dart:math';

Future<String> generateUUID() async {
  // We use a simple random string generator for a unique 16-character sign ID
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  Random rnd = Random();
  String randomStr = String.fromCharCodes(Iterable.generate(
      16, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));

  return "lumen-$randomStr";
}
