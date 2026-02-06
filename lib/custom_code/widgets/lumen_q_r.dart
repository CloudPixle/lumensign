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

import 'package:qr_flutter/qr_flutter.dart';

class LumenQR extends StatefulWidget {
  const LumenQR({
    Key? key,
    this.width,
    this.height,
    required this.url,
    this.qrColor,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String url;
  final Color? qrColor;

  @override
  _LumenQRState createState() => _LumenQRState();
}

class _LumenQRState extends State<LumenQR> {
  @override
  Widget build(BuildContext context) {
    // If the URL is empty, render an empty box to prevent crashes
    if (widget.url.isEmpty) {
      return SizedBox(
        width: widget.width ?? 120,
        height: widget.height ?? 120,
      );
    }

    return Container(
      width: widget.width,
      height: widget.height,
      child: QrImageView(
        data: widget.url,
        version: QrVersions.auto,
        size: widget.width ?? 120.0,
        // Using qrColor if provided, otherwise default to black for best scannability
        foregroundColor: widget.qrColor ?? Colors.black,
        // Digital mirrors need a solid white background for the scanner to "see" the black dots
        backgroundColor: Colors.white,
        padding: const EdgeInsets.all(10),
        gapless: false,
      ),
    );
  }
}
