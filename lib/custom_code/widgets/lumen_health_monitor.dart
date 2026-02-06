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

class LumenHealthMonitor extends StatefulWidget {
  const LumenHealthMonitor({
    super.key,
    this.width,
    this.height,
    this.cameraMs,
    this.aiMs,
    this.visionMs,
    this.generationMs,
    this.signId,
    this.status,
  });

  final double? width;
  final double? height;
  final int? cameraMs;
  final int? aiMs;
  final int? visionMs; // Split: Flash Analysis
  final int? generationMs; // Split: Pro Image Gen
  final String? signId;
  final String? status;

  @override
  State<LumenHealthMonitor> createState() => _LumenHealthMonitorState();
}

class _LumenHealthMonitorState extends State<LumenHealthMonitor> {
  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    // Initializing state to prevent startup crashes
    if (widget.signId == null || widget.signId!.isEmpty) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                  color: Colors.greenAccent, strokeWidth: 2),
              SizedBox(height: 12),
              Text("BOOTING SYSTEM...",
                  style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 10,
                      fontFamily: 'Roboto Mono')),
            ],
          ),
        ),
      );
    }

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "CORE TELEMETRY",
                    style: theme.bodySmall.override(
                      fontFamily: 'Roboto Mono',
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    "SIGN_ID: ${widget.signId}",
                    style: theme.bodySmall.override(
                      fontFamily: 'Roboto Mono',
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
              _buildStatusPill(widget.status ?? "IDLE"),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 16),

          // Row 1: The Pipeline Foundation
          Row(
            children: [
              _buildMetric("LENS CAPTURE", "${widget.cameraMs ?? 0}ms"),
              const SizedBox(width: 16),
              _buildMetric("TOTAL LATENCY", "${widget.aiMs ?? 0}ms",
                  color: Colors.greenAccent),
            ],
          ),

          const SizedBox(height: 20),

          // Row 2: Hybrid AI Intelligence Splits
          Row(
            children: [
              _buildMetric("FLASH (ANALYSIS)", "${widget.visionMs ?? 0}ms",
                  color: Colors.blueAccent, icon: Icons.psychology_outlined),
              const SizedBox(width: 16),
              _buildMetric("PRO (CREATIVE)", "${widget.generationMs ?? 0}ms",
                  color: Colors.orangeAccent,
                  icon: Icons.auto_awesome_outlined),
            ],
          ),

          const Spacer(),

          // Technical Footer for Hackathon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "MODEL: GEMINI-3 PORTFOLIO",
                  style: theme.bodySmall.override(
                    fontFamily: 'Roboto Mono',
                    color: Colors.white30,
                    fontSize: 8,
                  ),
                ),
                Text(
                  "v1.0-STABLE",
                  style: theme.bodySmall.override(
                    fontFamily: 'Roboto Mono',
                    color: Colors.white30,
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value,
      {Color color = Colors.white, IconData? icon}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 10, color: color.withOpacity(0.6)),
                const SizedBox(width: 4),
              ],
              Text(label,
                  style: TextStyle(
                      color: color.withOpacity(0.5),
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5)),
            ],
          ),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Roboto Mono')),
        ],
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    String displayStatus = status.toUpperCase();
    Color color = Colors.orange;

    if (displayStatus == "SUCCESS") color = Colors.greenAccent;
    if (displayStatus == "PROCESSING") color = Colors.blueAccent;
    if (displayStatus == "IDLE") color = Colors.white30;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            displayStatus,
            style: TextStyle(
                color: color,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0),
          ),
        ],
      ),
    );
  }
}
