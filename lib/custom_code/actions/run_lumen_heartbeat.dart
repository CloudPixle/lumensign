// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart';
import 'package:cloud_functions/cloud_functions.dart';

Future runLumenHeartbeat(
  int intervalMs,
  String signId,
) async {
  final ffState = FFAppState();

  // The loop runs as long as the global toggle is active
  while (ffState.isLoopActive) {
    // GUARD: Ensure we don't start a second process if one is already running
    if (!ffState.isProcessingOn) {
      try {
        final totalIterationStart = DateTime.now().millisecondsSinceEpoch;

        // 1. SET BUSY GUARD & STATUS
        ffState.update(() {
          ffState.isProcessingOn = true;
          ffState.status = 'Processing';
          ffState.debugLog = 'Triggering Camera...';
        });

        // 2. TRIGGER CAMERA SHUTTER
        final cameraStart = DateTime.now().millisecondsSinceEpoch;
        ffState.update(() => ffState.triggerCapture = true);

        // Hardware delay to allow camera processing (Lens Capture)
        await Future.delayed(const Duration(milliseconds: 2000));
        final cameraMs = DateTime.now().millisecondsSinceEpoch - cameraStart;

        ffState.update(() {
          ffState.triggerCapture = false;
          ffState.cameraMs = cameraMs;
          ffState.debugLog = 'AI Parallel Processing...';
        });

        // 3. CLOUD FUNCTION CALL
        if (ffState.lastCapturedBase64 != null &&
            ffState.lastCapturedBase64!.length > 100) {
          final result = await FirebaseFunctions.instance
              .httpsCallable('analyzeSignageContext')
              .call({
            "base64Image": ffState.lastCapturedBase64,
            "signId": signId,
            "venueType": ffState.settingsvenueType,
            "safetyLevel": ffState.settingssafetyLevel,
            "customContext": ffState.settingscustomPrompt,
            "fallbackText": ffState.settingsfallbackText,
            "aspectRatio": ffState.settingsaspectRatio,
          });

          // --- SILENCE INTERNAL FIREBASE DEBUG ERRORS ---
          // We check if the expected 'data' exists before updating the UI.
          // This prevents "App Check Missing" logs from breaking the App State.
          if (result.data != null &&
              (result.data['generated_image_base64'] != null ||
                  result.data['content_category'] != null)) {
            // 4. EXTRACT PERFORMANCE DATA
            int vMs = result.data['duration_vision_ms'] ?? 0;
            int gMs = result.data['duration_generation_ms'] ?? 0;
            int totalAiMs = result.data['duration_ai_ms'] ?? 0;

            String? newImage =
                result.data['generated_image_base64']?.toString();
            String analysis = result.data['vision_analysis'] ?? "No analysis";
            String prompt = result.data['ad_prompt'] ?? "Ambient Mode";

            // 5. UPDATE APP STATE & MONITOR TELEMETRY
            ffState.update(() {
              if (newImage != null && newImage.length > 100) {
                ffState.currentAdBase64 = newImage.trim();
                ffState.debugLog = 'Ad Swapped';
              } else {
                ffState.debugLog = 'Ambient/Lightbox Active';
              }

              ffState.visionMs = vMs;
              ffState.generationMs = gMs;
              ffState.aiMs = totalAiMs;
              ffState.currentAdText = analysis;
              ffState.visionFinding =
                  result.data['person_detected']?.toString() ?? "--";
              ffState.contextUsed = prompt;
              ffState.status = "Success";
            });

            // 6. LOG TO FIRESTORE
            await addToDebugLog(
              'Lumen Cycle Complete',
              signId,
              cameraMs,
              vMs,
              gMs,
              'Success',
              analysis,
              prompt,
              newImage ?? "",
            );
          } else {
            // If the data doesn't match our contract, it's likely a system debug message.
            // We ignore it silently so the UI doesn't flicker or show error text.
            ffState.update(() {
              ffState.debugLog = 'System Sync...';
              ffState.status = "Ready";
            });
          }
        } else {
          ffState.update(() {
            ffState.debugLog = 'Camera idle (Page backgrounded)';
            ffState.status = "Idle";
          });
        }
      } catch (e) {
        // Only show actual code crashes or network failures
        ffState.update(() {
          ffState.debugLog = 'Awaiting next heartbeat...';
          ffState.status = "Calibrating";
        });
        debugPrint('Lumen Silence Error: ${e.toString()}');
      } finally {
        ffState.update(() => ffState.isProcessingOn = false);
      }
    }

    await Future.delayed(Duration(milliseconds: intervalMs));
    if (!ffState.isLoopActive) break;
  }
}
