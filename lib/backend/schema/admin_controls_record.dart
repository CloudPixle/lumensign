import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AdminControlsRecord extends FirestoreRecord {
  AdminControlsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "is_api_enabled" field.
  bool? _isApiEnabled;
  bool get isApiEnabled => _isApiEnabled ?? false;
  bool hasIsApiEnabled() => _isApiEnabled != null;

  void _initializeFields() {
    _isApiEnabled = snapshotData['is_api_enabled'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('admin_controls');

  static Stream<AdminControlsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AdminControlsRecord.fromSnapshot(s));

  static Future<AdminControlsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AdminControlsRecord.fromSnapshot(s));

  static AdminControlsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AdminControlsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AdminControlsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AdminControlsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AdminControlsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AdminControlsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAdminControlsRecordData({
  bool? isApiEnabled,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'is_api_enabled': isApiEnabled,
    }.withoutNulls,
  );

  return firestoreData;
}

class AdminControlsRecordDocumentEquality
    implements Equality<AdminControlsRecord> {
  const AdminControlsRecordDocumentEquality();

  @override
  bool equals(AdminControlsRecord? e1, AdminControlsRecord? e2) {
    return e1?.isApiEnabled == e2?.isApiEnabled;
  }

  @override
  int hash(AdminControlsRecord? e) =>
      const ListEquality().hash([e?.isApiEnabled]);

  @override
  bool isValidKey(Object? o) => o is AdminControlsRecord;
}
