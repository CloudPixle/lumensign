// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'dart:typed_data';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class LumenAdDisplay extends StatefulWidget {
  const LumenAdDisplay({
    super.key,
    this.width,
    this.height,
    this.currentAdBase64,
    this.currentAdText,
    required this.isLightboxEnabled,
    required this.isLoopActive,
    required this.fallbackText,
  });

  final double? width;
  final double? height;
  final String? currentAdBase64;
  final String? currentAdText;
  final bool isLightboxEnabled;
  final bool isLoopActive;
  final String fallbackText;

  @override
  State<LumenAdDisplay> createState() => _LumenAdDisplayState();
}

class _LumenAdDisplayState extends State<LumenAdDisplay> {
  // Using the standard JSON Lottie URL for maximum compatibility
  final String jellyfishLottieUrl =
      "https://lottie.host/0809b1ec-b92a-4cbd-8d07-6bb6af6146e5/7vj7f7E7zD.json";

  final String defaultUrl =
      "https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/lumen-bvv207/assets/a196o7hsyoqw/1024.png";

  @override
  Widget build(BuildContext context) {
    Widget displayContent;

    bool showLightbox = false;

    // RULE: Determine if we should show the Ambient Lightbox Screen
    if (widget.isLightboxEnabled) {
      if (!widget.isLoopActive) {
        showLightbox = true;
      } else if (widget.currentAdBase64 == null ||
          widget.currentAdBase64!.isEmpty) {
        showLightbox = true;
      }
    }

    if (showLightbox) {
      displayContent = _buildLightboxView();
    } else {
      if (widget.currentAdBase64 == null ||
          widget.currentAdBase64!.length < 100) {
        displayContent = _buildDefault();
      } else {
        displayContent = _buildImageFromBase64(widget.currentAdBase64!);
      }
    }

    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.black,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 1000),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: displayContent,
      ),
    );
  }

  Widget _buildLightboxView() {
    return Container(
      key: const ValueKey('lightbox_ambient'),
      width: widget.width,
      height: widget.height,
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Layer 1: Ambient Lottie Animation
          Positioned.fill(
            child: Lottie.network(
              jellyfishLottieUrl,
              fit: BoxFit.cover,
              repeat: true,
            ),
          ),

          // Layer 2: White Wash for text readability
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.35),
            ),
          ),

          // Layer 3: Typography using Lexend Deca
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (widget.currentAdText != null &&
                          widget.currentAdText!.isNotEmpty)
                      ? widget.currentAdText!.toUpperCase()
                      : widget.fallbackText.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lexendDeca(
                    color: Colors.black.withOpacity(0.9),
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.5,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: 80,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageFromBase64(String base64Str) {
    try {
      String cleanStr = base64Str.trim();
      if (cleanStr.contains(',')) cleanStr = cleanStr.split(',').last;
      Uint8List imageBytes = base64Decode(cleanStr);

      return Image.memory(
        imageBytes,
        key: ValueKey(cleanStr.hashCode),
        fit: widget.isLightboxEnabled ? BoxFit.contain : BoxFit.cover,
        gaplessPlayback: true,
        width: widget.width,
        height: widget.height,
        errorBuilder: (context, error, stackTrace) => _buildDefault(),
      );
    } catch (e) {
      return _buildDefault();
    }
  }

  Widget _buildDefault() {
    return Image.network(
      defaultUrl,
      key: const ValueKey('default_ad'),
      fit: BoxFit.cover,
      width: widget.width,
      height: widget.height,
    );
  }
}
