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
import 'package:intl/intl.dart';

class LumenActivityList extends StatefulWidget {
  const LumenActivityList({
    super.key,
    this.width,
    this.height,
    this.logRecords,
  });

  final double? width;
  final double? height;
  final List<SignLogsRecord>? logRecords;

  @override
  State<LumenActivityList> createState() => _LumenActivityListState();
}

class _LumenActivityListState extends State<LumenActivityList> {
  // Helper to decode Base64 for the detail view
  Widget _buildImagePreview(String? base64String) {
    if (base64String == null || base64String.length < 100) {
      return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported_outlined, color: Colors.white24),
            SizedBox(height: 8),
            Text("AMBIENT MODE (NO IMAGE)",
                style: TextStyle(color: Colors.white24, fontSize: 10)),
          ],
        ),
      );
    }
    try {
      String cleanStr = base64String.trim();
      if (cleanStr.contains(',')) cleanStr = cleanStr.split(',').last;
      Uint8List bytes = base64Decode(cleanStr);
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(
          bytes,
          width: double.infinity,
          height: 350,
          fit: BoxFit.contain,
        ),
      );
    } catch (e) {
      return const SizedBox(height: 10);
    }
  }

  void _showDetails(BuildContext context, SignLogsRecord log) {
    // Corrected to use durationAiMs from your Firestore duration_ai_ms field
    final double totalSec = (log.durationAiMs ?? 0) / 1000.0;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF090F13),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: Colors.white10),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(height: 24),
              const Text("AI GENERATION RESULT",
                  style: TextStyle(
                      fontFamily: 'Roboto Mono',
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
              const SizedBox(height: 16),

              // Accessing your new generated_image_result field
              _buildImagePreview(log.generatedImageResult),

              const Divider(color: Colors.white10, height: 40),

              const Text("PERFORMANCE TELEMETRY",
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto Mono')),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStat(
                      "TOTAL LATENCY", "${totalSec.toStringAsFixed(1)}s"),
                  _buildStat("THINK", "${log.durationVisionMs}ms"),
                  _buildStat("DRAW", "${log.durationGenerationMs}ms"),
                ],
              ),
              const SizedBox(height: 24),
              const Text("VISION ANALYSIS",
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto Mono')),
              const SizedBox(height: 8),
              Text(log.analysisText ?? "No analysis available.",
                  style: const TextStyle(
                      color: Colors.white, fontSize: 14, height: 1.5)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.white38,
                fontSize: 8,
                fontWeight: FontWeight.bold)),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Roboto Mono')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.logRecords == null || widget.logRecords!.isEmpty) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.black,
        child: const Center(
            child: Text("LISTENING FOR EVENTS...",
                style: TextStyle(
                    color: Colors.white24, fontFamily: 'Roboto Mono'))),
      );
    }

    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.black,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: widget.logRecords!.length,
        itemBuilder: (context, index) {
          final log = widget.logRecords![index];
          // Corrected to use durationAiMs from your Firestore duration_ai_ms field
          final double totalSec = (log.durationAiMs ?? 0) / 1000.0;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: InkWell(
              onTap: () => _showDetails(context, log),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF14181B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          color: Colors.white10, shape: BoxShape.circle),
                      child: Icon(Icons.bolt,
                          color: (log.durationVisionMs ?? 0) > 0
                              ? Colors.greenAccent
                              : Colors.white24,
                          size: 18),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('hh:mm:ss a')
                                .format(log.timestamp ?? DateTime.now()),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                fontFamily: 'Roboto Mono'),
                          ),
                          Text(
                            "${totalSec.toStringAsFixed(1)}s Latency • ${log.status}",
                            style: const TextStyle(
                                color: Colors.white38, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.white24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
