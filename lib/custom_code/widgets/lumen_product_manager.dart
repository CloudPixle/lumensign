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

import 'index.dart'; // Imports other custom widgets

import 'dart:convert';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class LumenProductManager extends StatefulWidget {
  const LumenProductManager({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<LumenProductManager> createState() => _LumenProductManagerState();
}

class _LumenProductManagerState extends State<LumenProductManager> {
  bool _isProcessing = false;
  final ImagePicker _picker = ImagePicker();

  // Resize logic to ensure Cloud Function stability (640px target)
  Future<String?> _resizeAndEncode(Uint8List bytes) async {
    try {
      img.Image? decoded = img.decodeImage(bytes);
      if (decoded == null) return null;
      // Target 640px width to optimize for Gemini payload limits
      img.Image resized = img.copyResize(decoded, width: 640);
      return base64Encode(
          Uint8List.fromList(img.encodeJpg(resized, quality: 85)));
    } catch (e) {
      debugPrint("Lumen Product Resize Error: $e");
      return null;
    }
  }

  void _showProductForm([DocumentSnapshot? doc]) {
    final bool isEditing = doc != null;
    final labelController =
        TextEditingController(text: isEditing ? doc.get('label') : '');
    final descController =
        TextEditingController(text: isEditing ? doc.get('description') : '');
    final catController =
        TextEditingController(text: isEditing ? doc.get('category') : '');
    String? currentBase64 = isEditing ? doc.get('image_base64') : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(isEditing ? "Edit Product" : "New Product Asset",
                    style: FlutterFlowTheme.of(context).headlineSmall),
                const SizedBox(height: 20),

                // IMAGE PICKER / CAMERA TRIGGER
                GestureDetector(
                  onTap: () async {
                    // Selection Dialog for Camera or Gallery
                    final source = await showDialog<ImageSource>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Select Product Image"),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, ImageSource.camera),
                            child: const Text("Camera"),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, ImageSource.gallery),
                            child: const Text("Gallery"),
                          ),
                        ],
                      ),
                    );

                    if (source != null) {
                      final XFile? pickedFile =
                          await _picker.pickImage(source: source);
                      if (pickedFile != null) {
                        setModalState(() => _isProcessing = true);
                        final bytes = await pickedFile.readAsBytes();
                        final String? b64 = await _resizeAndEncode(bytes);
                        setModalState(() {
                          currentBase64 = b64;
                          _isProcessing = false;
                        });
                      }
                    }
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: FlutterFlowTheme.of(context).alternate),
                      image: currentBase64 != null
                          ? DecorationImage(
                              image: MemoryImage(base64Decode(currentBase64!)),
                              fit: BoxFit.cover)
                          : null,
                    ),
                    child: currentBase64 == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt_outlined,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 32),
                              const SizedBox(height: 8),
                              if (_isProcessing)
                                const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2))
                              else
                                Text("Upload / Snap",
                                    style: FlutterFlowTheme.of(context)
                                        .labelSmall),
                            ],
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                    controller: labelController,
                    decoration:
                        const InputDecoration(labelText: "Product Label")),
                TextField(
                    controller: descController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                        labelText: "Description (Context for AI)")),
                TextField(
                    controller: catController,
                    decoration: const InputDecoration(
                        labelText: "Category (e.g. hat, oil, drink)")),
                const SizedBox(height: 24),

                // STANDARD BUTTON (FFButton often breaks in custom widgets)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FlutterFlowTheme.of(context).primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () async {
                      if (currentBase64 == null) return;
                      final data = {
                        'label': labelController.text,
                        'description': descController.text,
                        'category': catController.text,
                        'image_base64': currentBase64,
                        'updated_at': FieldValue.serverTimestamp(),
                      };
                      if (isEditing) {
                        await doc.reference.update(data);
                      } else {
                        await FirebaseFirestore.instance
                            .collection('products')
                            .add(data);
                      }
                      Navigator.pop(context);
                    },
                    child: Text(isEditing ? "Update Asset" : "Add to Library"),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final docs = snapshot.data!.docs;

        return Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Product Assets (${docs.length}/5)",
                      style: FlutterFlowTheme.of(context).titleMedium),
                  if (docs.length < 5)
                    IconButton(
                      icon: Icon(Icons.add_circle,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 32),
                      onPressed: () => _showProductForm(),
                    ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          base64Decode(doc.get('image_base64')),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(doc.get('label'),
                          style: FlutterFlowTheme.of(context).bodyLarge),
                      subtitle: Text(doc.get('category'),
                          style: FlutterFlowTheme.of(context).labelSmall),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () => _showProductForm(doc)),
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                            onPressed: () => doc.reference.delete(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
