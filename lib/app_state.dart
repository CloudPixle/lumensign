import 'package:flutter/material.dart';
import '/backend/backend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'dart:convert';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _currentAdBase64 =
          prefs.getString('ff_currentAdBase64') ?? _currentAdBase64;
    });
    _safeInit(() {
      _settingsvenueType =
          prefs.getString('ff_settingsvenueType') ?? _settingsvenueType;
    });
    _safeInit(() {
      _settingscameraID =
          prefs.getString('ff_settingscameraID') ?? _settingscameraID;
    });
    _safeInit(() {
      _settingspulseInterval =
          prefs.getInt('ff_settingspulseInterval') ?? _settingspulseInterval;
    });
    _safeInit(() {
      _settingssafetyLevel =
          prefs.getString('ff_settingssafetyLevel') ?? _settingssafetyLevel;
    });
    _safeInit(() {
      _settingsdebugMode =
          prefs.getBool('ff_settingsdebugMode') ?? _settingsdebugMode;
    });
    _safeInit(() {
      _settingsaspectRatio =
          prefs.getString('ff_settingsaspectRatio') ?? _settingsaspectRatio;
    });
    _safeInit(() {
      _settingscustomPrompt =
          prefs.getString('ff_settingscustomPrompt') ?? _settingscustomPrompt;
    });
    _safeInit(() {
      _settingsfallbackText =
          prefs.getString('ff_settingsfallbackText') ?? _settingsfallbackText;
    });
    _safeInit(() {
      _installationUUID =
          prefs.getString('ff_installationUUID') ?? _installationUUID;
    });
    _safeInit(() {
      _cameraRotation = prefs.getInt('ff_cameraRotation') ?? _cameraRotation;
    });
    _safeInit(() {
      _isLightboxEnabled =
          prefs.getBool('ff_isLightboxEnabled') ?? _isLightboxEnabled;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  dynamic _currentSignage;
  dynamic get currentSignage => _currentSignage;
  set currentSignage(dynamic value) {
    _currentSignage = value;
  }

  bool _isAnalyzing = false;
  bool get isAnalyzing => _isAnalyzing;
  set isAnalyzing(bool value) {
    _isAnalyzing = value;
  }

  bool _triggerCapture = false;
  bool get triggerCapture => _triggerCapture;
  set triggerCapture(bool value) {
    _triggerCapture = value;
  }

  String _lastCapturedBase64 = '';
  String get lastCapturedBase64 => _lastCapturedBase64;
  set lastCapturedBase64(String value) {
    _lastCapturedBase64 = value;
  }

  dynamic _signageResult;
  dynamic get signageResult => _signageResult;
  set signageResult(dynamic value) {
    _signageResult = value;
  }

  bool _isCurrentAdVideo = false;
  bool get isCurrentAdVideo => _isCurrentAdVideo;
  set isCurrentAdVideo(bool value) {
    _isCurrentAdVideo = value;
  }

  String _currentAdBase64 =
      'https://firebasestorage.googleapis.com/v0/b/lumen-bvv207.firebasestorage.app/o/default%2Fballerina.png?alt=media&token=021a00ff-df0d-4a9d-8e55-69ee4cd87f9a';
  String get currentAdBase64 => _currentAdBase64;
  set currentAdBase64(String value) {
    _currentAdBase64 = value;
    prefs.setString('ff_currentAdBase64', value);
  }

  String _currentAdUrl = '';
  String get currentAdUrl => _currentAdUrl;
  set currentAdUrl(String value) {
    _currentAdUrl = value;
  }

  String _currentAdText = '';
  String get currentAdText => _currentAdText;
  set currentAdText(String value) {
    _currentAdText = value;
  }

  String _currentPlaylistUrl =
      'https://firebasestorage.googleapis.com/v0/b/lumen-bvv207.firebasestorage.app/o/default%2Fflying.png?alt=media&token=9acbe029-159f-4cd8-8c1d-6689f742e881';
  String get currentPlaylistUrl => _currentPlaylistUrl;
  set currentPlaylistUrl(String value) {
    _currentPlaylistUrl = value;
  }

  String _visionFinding = '';
  String get visionFinding => _visionFinding;
  set visionFinding(String value) {
    _visionFinding = value;
  }

  /// Searched keywords
  String _contextUsed = '';
  String get contextUsed => _contextUsed;
  set contextUsed(String value) {
    _contextUsed = value;
  }

  String _settingsvenueType = 'Café';
  String get settingsvenueType => _settingsvenueType;
  set settingsvenueType(String value) {
    _settingsvenueType = value;
    prefs.setString('ff_settingsvenueType', value);
  }

  String _settingscameraID = '0';
  String get settingscameraID => _settingscameraID;
  set settingscameraID(String value) {
    _settingscameraID = value;
    prefs.setString('ff_settingscameraID', value);
  }

  int _settingspulseInterval = 60000;
  int get settingspulseInterval => _settingspulseInterval;
  set settingspulseInterval(int value) {
    _settingspulseInterval = value;
    prefs.setInt('ff_settingspulseInterval', value);
  }

  /// Strict or Moderate
  String _settingssafetyLevel = 'strict';
  String get settingssafetyLevel => _settingssafetyLevel;
  set settingssafetyLevel(String value) {
    _settingssafetyLevel = value;
    prefs.setString('ff_settingssafetyLevel', value);
  }

  bool _settingsdebugMode = false;
  bool get settingsdebugMode => _settingsdebugMode;
  set settingsdebugMode(bool value) {
    _settingsdebugMode = value;
    prefs.setBool('ff_settingsdebugMode', value);
  }

  String _settingsaspectRatio = '9:16';
  String get settingsaspectRatio => _settingsaspectRatio;
  set settingsaspectRatio(String value) {
    _settingsaspectRatio = value;
    prefs.setString('ff_settingsaspectRatio', value);
  }

  String _settingscustomPrompt = '';
  String get settingscustomPrompt => _settingscustomPrompt;
  set settingscustomPrompt(String value) {
    _settingscustomPrompt = value;
    prefs.setString('ff_settingscustomPrompt', value);
  }

  String _settingsfallbackText = '';
  String get settingsfallbackText => _settingsfallbackText;
  set settingsfallbackText(String value) {
    _settingsfallbackText = value;
    prefs.setString('ff_settingsfallbackText', value);
  }

  bool _isProcessingOn = false;
  bool get isProcessingOn => _isProcessingOn;
  set isProcessingOn(bool value) {
    _isProcessingOn = value;
  }

  /// monitor the Project Lumen heartbeat during development without ruining the
  /// "Magic Mirror" experience for the audience.
  String _debugLog = 'System Standby...';
  String get debugLog => _debugLog;
  set debugLog(String value) {
    _debugLog = value;
  }

  String _installationUUID = '';
  String get installationUUID => _installationUUID;
  set installationUUID(String value) {
    _installationUUID = value;
    prefs.setString('ff_installationUUID', value);
  }

  bool _isLoopActive = true;
  bool get isLoopActive => _isLoopActive;
  set isLoopActive(bool value) {
    _isLoopActive = value;
  }

  int _cameraRotation = 0;
  int get cameraRotation => _cameraRotation;
  set cameraRotation(int value) {
    _cameraRotation = value;
    prefs.setInt('ff_cameraRotation', value);
  }

  bool _isLightboxEnabled = false;
  bool get isLightboxEnabled => _isLightboxEnabled;
  set isLightboxEnabled(bool value) {
    _isLightboxEnabled = value;
    prefs.setBool('ff_isLightboxEnabled', value);
  }

  int _visionMs = 0;
  int get visionMs => _visionMs;
  set visionMs(int value) {
    _visionMs = value;
  }

  int _generationMs = 0;
  int get generationMs => _generationMs;
  set generationMs(int value) {
    _generationMs = value;
  }

  int _aiMs = 0;
  int get aiMs => _aiMs;
  set aiMs(int value) {
    _aiMs = value;
  }

  int _cameraMs = 0;
  int get cameraMs => _cameraMs;
  set cameraMs(int value) {
    _cameraMs = value;
  }

  String _status = 'Idle';
  String get status => _status;
  set status(String value) {
    _status = value;
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
