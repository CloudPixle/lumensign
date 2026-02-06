import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'mirror_model.dart';
export 'mirror_model.dart';

/// Virtual try on
class MirrorWidget extends StatefulWidget {
  const MirrorWidget({super.key});

  static String routeName = 'mirror';
  static String routePath = '/mirror';

  @override
  State<MirrorWidget> createState() => _MirrorWidgetState();
}

class _MirrorWidgetState extends State<MirrorWidget> {
  late MirrorModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MirrorModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
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
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: MediaQuery.sizeOf(context).height * 1.0,
                child: custom_widgets.LumenMirror(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  signId: FFAppState().installationUUID,
                  onExit: () async {
                    context.safePop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
