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
import 'dart:ui';
import 'dart:async';
import 'package:image/image.dart' as img;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:camera/camera.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/services.dart';

class LumenMirror extends StatefulWidget {
  const LumenMirror({
    super.key,
    this.width,
    this.height,
    required this.onExit,
    required this.signId,
  });

  final double? width;
  final double? height;
  final Future Function() onExit;
  final String signId;

  @override
  State<LumenMirror> createState() => _LumenMirrorState();
}

class _LumenMirrorState extends State<LumenMirror>
    with SingleTickerProviderStateMixin {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isProcessing = false;
  String? _resultImageBase64;
  String? _capturedImageBase64;
  String? _shareUrl;
  int _selectedIndex = 0;
  List<DocumentSnapshot> _products = [];

  late bool _wasLooping;
  late AnimationController _scanController;
  int _countdownValue = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _wasLooping = FFAppState().isLoopActive;
    FFAppState().update(() {
      FFAppState().isLoopActive = false;
    });

    _initCamera();
    _fetchProducts();

    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) return;
      CameraDescription selected = _cameras!.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first,
      );
      _controller = CameraController(selected, ResolutionPreset.medium,
          enableAudio: false);
      await _controller!.initialize();
      await _controller!.lockCaptureOrientation(DeviceOrientation.portraitUp);
      if (mounted) setState(() => _isInitialized = true);
    } catch (e) {
      print("LUMEN_LOG: Camera Init Error: $e");
    }
  }

  Future<void> _fetchProducts() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('products')
          .limit(5)
          .get();
      if (mounted) setState(() => _products = snap.docs);
    } catch (e) {
      print("LUMEN_LOG: Product Fetch Error: $e");
    }
  }

  void _startCountdown() {
    if (_isProcessing || _countdownValue > 0) return;
    setState(() {
      _countdownValue = 3;
      _resultImageBase64 = null;
      _capturedImageBase64 = null;
      _shareUrl = null;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdownValue > 1) {
          _countdownValue--;
        } else {
          _countdownValue = 0;
          _timer?.cancel();
          _runTryOn();
        }
      });
    });
  }

  Future<void> _runTryOn() async {
    if (_controller == null || _products.isEmpty) return;
    setState(() => _isProcessing = true);

    try {
      final image = await _controller!.takePicture();
      final bytes = await image.readAsBytes();

      img.Image? decoded = img.decodeImage(bytes);
      if (decoded == null) throw Exception("Failed to decode image");
      decoded = img.bakeOrientation(decoded);

      if (FFAppState().cameraRotation != 0) {
        decoded = img.copyRotate(decoded, angle: FFAppState().cameraRotation);
      }

      _capturedImageBase64 =
          base64Encode(Uint8List.fromList(img.encodeJpg(decoded)));
      setState(() {});

      img.Image resized = img.copyResize(decoded, width: 640);
      String userBase64 =
          base64Encode(Uint8List.fromList(img.encodeJpg(resized)));

      final selectedProd = _products[_selectedIndex];
      final callable = FirebaseFunctions.instanceFor(region: 'us-central1')
          .httpsCallable('virtualTryOn');

      final result = await callable.call({
        'userImage': userBase64,
        'productImage': selectedProd.get('image_base64'),
        'productDesc': selectedProd.get('description'),
        'category': selectedProd.get('category'),
        'signId': widget.signId,
      });

      if (!mounted) return;
      if (result.data != null && result.data['success'] == true) {
        setState(() {
          _resultImageBase64 = result.data['try_on_image'];
          _shareUrl = result.data['share_url'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(result.data['error'] ?? "AI Error: Repose")));
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Try-On Fail: $e")));
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Widget _buildCircularButton(
      {required IconData icon, required VoidCallback onPressed}) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: IconButton(
              icon: Icon(icon, color: Colors.white, size: 28),
              onPressed: onPressed),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scanController.dispose();
    _controller?.dispose();
    FFAppState().update(() {
      FFAppState().isLoopActive = _wasLooping;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized)
      return const Center(child: CircularProgressIndicator());

    // Connect to App State for the Lightbox toggle
    bool lightboxActive = FFAppState().isLightboxEnabled;
    int turns = (FFAppState().cameraRotation / 90).round();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: ClipRect(
              child: _resultImageBase64 != null
                  ? Container(
                      color: lightboxActive ? Colors.black : Colors.transparent,
                      child: Image.memory(
                        base64Decode(_resultImageBase64!),
                        fit: lightboxActive ? BoxFit.contain : BoxFit.cover,
                      ),
                    )
                  : RotatedBox(
                      quarterTurns: turns,
                      child: _capturedImageBase64 != null && _isProcessing
                          ? Container(
                              color: lightboxActive
                                  ? Colors.black
                                  : Colors.transparent,
                              child: Image.memory(
                                base64Decode(_capturedImageBase64!),
                                fit: lightboxActive
                                    ? BoxFit.contain
                                    : BoxFit.cover,
                              ),
                            )
                          : FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: _controller!.value.previewSize!.height,
                                height: _controller!.value.previewSize!.width,
                                child: CameraPreview(_controller!),
                              ),
                            ),
                    ),
            ),
          ),
          if (_countdownValue > 0)
            Positioned.fill(
              child: Center(
                child: Text('$_countdownValue',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 180,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          if (_isProcessing) ...[
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _scanController,
                builder: (context, child) {
                  return Stack(
                    children: [
                      Container(color: Colors.black.withOpacity(0.3)),
                      Positioned(
                        top: MediaQuery.of(context).size.height *
                            _scanController.value,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.white.withOpacity(0.8),
                                  blurRadius: 20,
                                  spreadRadius: 2)
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Positioned(
              bottom: 120,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(color: Colors.white),
                    const SizedBox(height: 16),
                    const Text("AI IS DRESSING YOU...",
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ],
                ),
              ),
            ),
          ],
          Positioned(
            top: 50,
            right: 20,
            child: Column(
              children: [
                _buildCircularButton(
                    icon: Icons.close_rounded,
                    onPressed: () => widget.onExit()),
                if (_resultImageBase64 != null && !_isProcessing) ...[
                  const SizedBox(height: 16),
                  _buildCircularButton(
                      icon: Icons.refresh_rounded,
                      onPressed: () => setState(() {
                            _resultImageBase64 = null;
                            _shareUrl = null;
                          })),
                ],
              ],
            ),
          ),
          if (_resultImageBase64 != null && _shareUrl != null && !_isProcessing)
            Positioned(
              bottom: 140,
              right: 20,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: LumenQR(
                      width: 110,
                      height: 110,
                      url: _shareUrl!,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text("SCAN TO DOWNLOAD",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1)),
                  ),
                ],
              ),
            ),
          if (!_isProcessing && _countdownValue == 0)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _products.length,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemBuilder: (context, index) {
                        final prod = _products[index];
                        return GestureDetector(
                          onTap: () => setState(() {
                            _selectedIndex = index;
                            _resultImageBase64 = null;
                            _shareUrl = null;
                          }),
                          child: Container(
                            width: 60,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: _selectedIndex == index
                                      ? Colors.white
                                      : Colors.white24,
                                  width: 2),
                              image: DecorationImage(
                                  image: MemoryImage(
                                      base64Decode(prod.get('image_base64'))),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _startCountdown,
                    child: Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3)),
                      child: Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: const Icon(Icons.auto_fix_high,
                              color: Colors.black, size: 30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
