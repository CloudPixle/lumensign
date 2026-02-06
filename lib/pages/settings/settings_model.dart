import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:aligned_tooltip/aligned_tooltip.dart';
import 'settings_widget.dart' show SettingsWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SettingsModel extends FlutterFlowModel<SettingsWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for safeguard widget.
  bool? safeguardValue1;
  // State field(s) for safeguard widget.
  bool? safeguardValue2;
  // State field(s) for Slider widget.
  double? sliderValue;
  // State field(s) for venue widget.
  String? venueValue;
  FormFieldController<String>? venueValueController;
  // State field(s) for ratio widget.
  String? ratioValue;
  FormFieldController<String>? ratioValueController;
  // State field(s) for camera widget.
  FormFieldController<List<String>>? cameraValueController;
  String? get cameraValue => cameraValueController?.value?.firstOrNull;
  set cameraValue(String? val) =>
      cameraValueController?.value = val != null ? [val] : [];
  // State field(s) for rotation widget.
  FormFieldController<List<String>>? rotationValueController;
  String? get rotationValue => rotationValueController?.value?.firstOrNull;
  set rotationValue(String? val) =>
      rotationValueController?.value = val != null ? [val] : [];
  // State field(s) for safeguard widget.
  bool? safeguardValue3;
  // State field(s) for prompt widget.
  FocusNode? promptFocusNode;
  TextEditingController? promptTextController;
  String? Function(BuildContext, String?)? promptTextControllerValidator;
  // State field(s) for fallback_text widget.
  FocusNode? fallbackTextFocusNode;
  TextEditingController? fallbackTextTextController;
  String? Function(BuildContext, String?)? fallbackTextTextControllerValidator;
  // State field(s) for SwitchListTile widget.
  bool? switchListTileValue;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
    promptFocusNode?.dispose();
    promptTextController?.dispose();

    fallbackTextFocusNode?.dispose();
    fallbackTextTextController?.dispose();
  }
}
