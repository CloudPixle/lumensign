import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Logs
class SignLogsRecord extends FirestoreRecord {
  SignLogsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "sign_id" field.
  String? _signId;
  String get signId => _signId ?? '';
  bool hasSignId() => _signId != null;

  // "timestamp" field.
  DateTime? _timestamp;
  DateTime? get timestamp => _timestamp;
  bool hasTimestamp() => _timestamp != null;

  // "duration_camera_ms" field.
  int? _durationCameraMs;

  /// Time taken for snapshot capture
  int get durationCameraMs => _durationCameraMs ?? 0;
  bool hasDurationCameraMs() => _durationCameraMs != null;

  // "duration_ai_ms" field.
  int? _durationAiMs;

  /// Time taken for Gemini + Imagen API
  int get durationAiMs => _durationAiMs ?? 0;
  bool hasDurationAiMs() => _durationAiMs != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "content_type" field.
  String? _contentType;
  String get contentType => _contentType ?? '';
  bool hasContentType() => _contentType != null;

  // "analysis_text" field.
  String? _analysisText;
  String get analysisText => _analysisText ?? '';
  bool hasAnalysisText() => _analysisText != null;

  // "image_prompt" field.
  String? _imagePrompt;
  String get imagePrompt => _imagePrompt ?? '';
  bool hasImagePrompt() => _imagePrompt != null;

  // "duration_vision_ms" field.
  int? _durationVisionMs;
  int get durationVisionMs => _durationVisionMs ?? 0;
  bool hasDurationVisionMs() => _durationVisionMs != null;

  // "duration_generation_ms" field.
  int? _durationGenerationMs;
  int get durationGenerationMs => _durationGenerationMs ?? 0;
  bool hasDurationGenerationMs() => _durationGenerationMs != null;

  // "interaction_type" field.
  String? _interactionType;
  String get interactionType => _interactionType ?? '';
  bool hasInteractionType() => _interactionType != null;

  // "session_id" field.
  String? _sessionId;
  String get sessionId => _sessionId ?? '';
  bool hasSessionId() => _sessionId != null;

  // "user_email" field.
  String? _userEmail;
  String get userEmail => _userEmail ?? '';
  bool hasUserEmail() => _userEmail != null;

  // "generated_image_result" field.
  String? _generatedImageResult;
  String get generatedImageResult => _generatedImageResult ?? '';
  bool hasGeneratedImageResult() => _generatedImageResult != null;

  void _initializeFields() {
    _signId = snapshotData['sign_id'] as String?;
    _timestamp = snapshotData['timestamp'] as DateTime?;
    _durationCameraMs = castToType<int>(snapshotData['duration_camera_ms']);
    _durationAiMs = castToType<int>(snapshotData['duration_ai_ms']);
    _status = snapshotData['status'] as String?;
    _contentType = snapshotData['content_type'] as String?;
    _analysisText = snapshotData['analysis_text'] as String?;
    _imagePrompt = snapshotData['image_prompt'] as String?;
    _durationVisionMs = castToType<int>(snapshotData['duration_vision_ms']);
    _durationGenerationMs =
        castToType<int>(snapshotData['duration_generation_ms']);
    _interactionType = snapshotData['interaction_type'] as String?;
    _sessionId = snapshotData['session_id'] as String?;
    _userEmail = snapshotData['user_email'] as String?;
    _generatedImageResult = snapshotData['generated_image_result'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('sign_logs');

  static Stream<SignLogsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SignLogsRecord.fromSnapshot(s));

  static Future<SignLogsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => SignLogsRecord.fromSnapshot(s));

  static SignLogsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      SignLogsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SignLogsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SignLogsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SignLogsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SignLogsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createSignLogsRecordData({
  String? signId,
  DateTime? timestamp,
  int? durationCameraMs,
  int? durationAiMs,
  String? status,
  String? contentType,
  String? analysisText,
  String? imagePrompt,
  int? durationVisionMs,
  int? durationGenerationMs,
  String? interactionType,
  String? sessionId,
  String? userEmail,
  String? generatedImageResult,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'sign_id': signId,
      'timestamp': timestamp,
      'duration_camera_ms': durationCameraMs,
      'duration_ai_ms': durationAiMs,
      'status': status,
      'content_type': contentType,
      'analysis_text': analysisText,
      'image_prompt': imagePrompt,
      'duration_vision_ms': durationVisionMs,
      'duration_generation_ms': durationGenerationMs,
      'interaction_type': interactionType,
      'session_id': sessionId,
      'user_email': userEmail,
      'generated_image_result': generatedImageResult,
    }.withoutNulls,
  );

  return firestoreData;
}

class SignLogsRecordDocumentEquality implements Equality<SignLogsRecord> {
  const SignLogsRecordDocumentEquality();

  @override
  bool equals(SignLogsRecord? e1, SignLogsRecord? e2) {
    return e1?.signId == e2?.signId &&
        e1?.timestamp == e2?.timestamp &&
        e1?.durationCameraMs == e2?.durationCameraMs &&
        e1?.durationAiMs == e2?.durationAiMs &&
        e1?.status == e2?.status &&
        e1?.contentType == e2?.contentType &&
        e1?.analysisText == e2?.analysisText &&
        e1?.imagePrompt == e2?.imagePrompt &&
        e1?.durationVisionMs == e2?.durationVisionMs &&
        e1?.durationGenerationMs == e2?.durationGenerationMs &&
        e1?.interactionType == e2?.interactionType &&
        e1?.sessionId == e2?.sessionId &&
        e1?.userEmail == e2?.userEmail &&
        e1?.generatedImageResult == e2?.generatedImageResult;
  }

  @override
  int hash(SignLogsRecord? e) => const ListEquality().hash([
        e?.signId,
        e?.timestamp,
        e?.durationCameraMs,
        e?.durationAiMs,
        e?.status,
        e?.contentType,
        e?.analysisText,
        e?.imagePrompt,
        e?.durationVisionMs,
        e?.durationGenerationMs,
        e?.interactionType,
        e?.sessionId,
        e?.userEmail,
        e?.generatedImageResult
      ]);

  @override
  bool isValidKey(Object? o) => o is SignLogsRecord;
}
