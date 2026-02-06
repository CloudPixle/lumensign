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
import 'dart:ui' as ui;
import 'package:camera/camera.dart';

class LumenCamera extends StatefulWidget {
  const LumenCamera({
    super.key,
    this.width,
    this.height,
    required this.triggerCapture,
    required this.cameraIndex,
  });

  final double? width;
  final double? height;
  final bool triggerCapture;
  final String cameraIndex;

  @override
  State<LumenCamera> createState() => _LumenCameraState();
}

class _LumenCameraState extends State<LumenCamera> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => _initCamera());
  }

  @override
  void didUpdateWidget(LumenCamera oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.cameraIndex != widget.cameraIndex) {
      _initCamera();
    }

    if (widget.triggerCapture && !oldWidget.triggerCapture) {
      if (!_isBusy && _isInitialized) {
        _takeSnapshot();
      }
    }
  }

  Future<void> _initCamera() async {
    if (_isBusy) return;
    _isBusy = true;

    if (_controller != null) {
      await _controller!.dispose();
      _controller = null;
    }

    try {
      _cameras ??= await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) return;

      int targetIndex = int.tryParse(widget.cameraIndex) ?? 0;
      if (targetIndex >= _cameras!.length) targetIndex = 0;

      _controller = CameraController(
        _cameras![targetIndex],
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller!.initialize();
      if (mounted) setState(() => _isInitialized = true);
    } catch (e) {
      print("Lumen Camera Init Error: $e");
    } finally {
      _isBusy = false;
    }
  }

  Future<String?> _resizeAndEncode(XFile file) async {
    try {
      final Uint8List originalBytes = await file.readAsBytes();

      final ui.ImmutableBuffer buffer =
          await ui.ImmutableBuffer.fromUint8List(originalBytes);
      final ui.ImageDescriptor descriptor =
          await ui.ImageDescriptor.encoded(buffer);

      const int targetWidth = 640;
      final int targetHeight =
          (descriptor.height * (targetWidth / descriptor.width)).round();

      final ui.Codec codec = await descriptor.instantiateCodec(
        targetWidth: targetWidth,
        targetHeight: targetHeight,
      );

      final ui.FrameInfo fi = await codec.getNextFrame();
      final ui.Image resizedImage = fi.image;

      final ByteData? byteData =
          await resizedImage.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;

      return base64Encode(byteData.buffer.asUint8List());
    } catch (e) {
      print("Lumen Resize Error: $e");
      return null;
    }
  }

  Future<void> _takeSnapshot() async {
    if (_controller == null || !_isInitialized || _isBusy) return;

    setState(() => _isBusy = true);
    try {
      final XFile image = await _controller!.takePicture();
      final String? base64Image = await _resizeAndEncode(image);

      if (base64Image != null) {
        FFAppState().update(() {
          FFAppState().lastCapturedBase64 = base64Image;
        });
      }
    } catch (e) {
      print("Lumen Capture Failed: $e");
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _controller == null) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.black,
        child:
            const Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: CameraPreview(_controller!),
      ),
    );
  }
}
