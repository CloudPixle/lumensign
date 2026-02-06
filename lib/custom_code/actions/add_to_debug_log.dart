// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart'; // Imports other custom actions
import 'package:cloud_firestore/cloud_firestore.dart';

Future addToDebugLog(
  String newMessage,
  String signId,
  int cameraMs,
  int visionMs,
  int generationMs,
  String status,
  String? analysisText,
  String? imagePrompt,
  String? generatedImage,
) async {
  // 1. Update Local UI Log
  String currentLog = FFAppState().debugLog;
  String time = DateTime.now().toString().split(' ').last.substring(0, 8);

  List<String> lines = currentLog.split('\n');
  if (lines.length >= 10) {
    lines.removeAt(0);
  }

  String performanceStats = "";
  if (status.toLowerCase() == "success") {
    performanceStats = " | Think: ${visionMs}ms | Draw: ${generationMs}ms";
  }

  FFAppState().update(() {
    FFAppState().debugLog =
        "${lines.join('\n')}\n[$time] $newMessage$performanceStats";
  });

  // 2. Write to Firestore (The "Audit Trail")
  if (status.toLowerCase() != "processing") {
    CollectionReference logs =
        FirebaseFirestore.instance.collection('sign_logs');

    await logs.add({
      'sign_id': signId,
      'duration_camera_ms': cameraMs,
      'duration_vision_ms': visionMs,
      'duration_generation_ms': generationMs,
      // FIXED: Changed duration_total_ai_ms to duration_ai_ms to match schema
      'duration_ai_ms': visionMs + generationMs,
      'status': status,
      'timestamp': FieldValue.serverTimestamp(),
      'analysis_text': analysisText ?? "",
      'image_prompt': imagePrompt ?? "",
      'generated_image_result': generatedImage ?? "",
      'interaction_type': "passive_signage",
    }).catchError((e) => print("Firestore Log Error: $e"));
  }
}
