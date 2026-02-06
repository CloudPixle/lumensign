import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/permissions_util.dart';
import '/index.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (!(FFAppState().installationUUID != null &&
          FFAppState().installationUUID != '')) {
        _model.uuid = await actions.generateUUID();
        FFAppState().installationUUID = _model.uuid!;
        safeSetState(() {});
      }
      await requestPermission(cameraPermission);
      await Future.delayed(
        Duration(
          milliseconds: 2000,
        ),
      );
      FFAppState().isProcessingOn = false;
      safeSetState(() {});
      if (FFAppState().isLoopActive) {
        await actions.runLumenHeartbeat(
          FFAppState().settingspulseInterval,
          FFAppState().installationUUID,
        );
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    // On page dispose action.
    () async {
      FFAppState().isLoopActive = false;
      FFAppState().isProcessingOn = false;
      safeSetState(() {});
    }();

    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: custom_widgets.LumenAdDisplay(
                width: double.infinity,
                height: double.infinity,
                currentAdBase64: FFAppState().currentAdBase64,
                currentAdText: FFAppState().settingsfallbackText,
                isLightboxEnabled: FFAppState().isLightboxEnabled,
                isLoopActive: FFAppState().isLoopActive,
                fallbackText: FFAppState().settingsfallbackText,
              ),
            ),
            if (FFAppState().settingsdebugMode)
              Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: MediaQuery.sizeOf(context).height * 0.3,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).accent4,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 10.0, 0.0, 0.0),
                                child: Text(
                                  'Current status: ',
                                  textAlign: TextAlign.start,
                                  maxLines: 5,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 10.0, 0.0, 0.0),
                                child: Text(
                                  valueOrDefault<String>(
                                    FFAppState().debugLog,
                                    'I have no idea what is happening!! ',
                                  ),
                                  maxLines: 5,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 6.0, 0.0, 0.0),
                              child: FlutterFlowIconButton(
                                borderRadius: 8.0,
                                buttonSize: 40.0,
                                fillColor: FlutterFlowTheme.of(context).primary,
                                icon: Icon(
                                  Icons.receipt_long,
                                  color: FlutterFlowTheme.of(context).info,
                                  size: 24.0,
                                ),
                                onPressed: () async {
                                  if (Navigator.of(context).canPop()) {
                                    context.pop();
                                  }
                                  context.pushNamed(
                                      ActivityLogPageWidget.routeName);
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 10.0, 0.0, 0.0),
                                child: Text(
                                  'Person detected: ',
                                  textAlign: TextAlign.start,
                                  maxLines: 5,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 10.0, 0.0, 0.0),
                                child: Text(
                                  FFAppState().visionFinding,
                                  maxLines: 5,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 5.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 10.0, 0.0, 0.0),
                                    child: Text(
                                      'Key words: ',
                                      textAlign: TextAlign.start,
                                      maxLines: 5,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 10.0, 0.0, 0.0),
                                    child: AutoSizeText(
                                      valueOrDefault<String>(
                                        FFAppState().contextUsed,
                                        'No context showing',
                                      ),
                                      maxLines: 5,
                                      minFontSize: 12.0,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onLongPress: () async {
                context.pushNamed(SettingsWidget.routeName);
              },
              child: Container(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: MediaQuery.sizeOf(context).height * 0.15,
                decoration: BoxDecoration(),
              ),
            ),
            if (FFAppState().settingsdebugMode)
              Align(
                alignment: AlignmentDirectional(0.89, -0.65),
                child: Container(
                  width: 100.0,
                  height: 150.0,
                  child: custom_widgets.LumenCamera(
                    width: 100.0,
                    height: 150.0,
                    triggerCapture: FFAppState().triggerCapture,
                    cameraIndex: FFAppState().settingscameraID,
                  ),
                ),
              ),
            Align(
              alignment: AlignmentDirectional(0.89, -0.26),
              child: FFButtonWidget(
                onPressed: () async {
                  var confirmDialogResponse = await showDialog<bool>(
                        context: context,
                        builder: (alertDialogContext) {
                          return AlertDialog(
                            title: Text('Open Magic Mirror?'),
                            content: Text(
                                'Lumen will use your camera to show you how this looks on you. No images are stored permanently. Ready?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(alertDialogContext, false),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(alertDialogContext, true),
                                child: Text('Confirm'),
                              ),
                            ],
                          );
                        },
                      ) ??
                      false;
                  if (confirmDialogResponse) {
                    context.pushNamed(MirrorWidget.routeName);
                  }
                },
                text: 'Try it on',
                icon: Icon(
                  Icons.all_inclusive,
                  size: 15.0,
                ),
                options: FFButtonOptions(
                  width: 100.0,
                  height: 100.0,
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        font: GoogleFonts.interTight(
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleSmall
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        ),
                        color: Colors.white,
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).titleSmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleSmall.fontStyle,
                      ),
                  elevation: 0.0,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
