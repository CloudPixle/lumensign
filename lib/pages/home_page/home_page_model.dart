import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/permissions_util.dart';
import '/index.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  Local state fields for this page.

  DateTime? startTime;

  DateTime? cameraEndTime;

  DateTime? apiEndTime;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - generateUUID] action in HomePage widget.
  String? uuid;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
