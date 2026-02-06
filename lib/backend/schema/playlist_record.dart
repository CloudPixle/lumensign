import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PlaylistRecord extends FirestoreRecord {
  PlaylistRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "url" field.
  String? _url;
  String get url => _url ?? '';
  bool hasUrl() => _url != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  bool hasType() => _type != null;

  // "is_active" field.
  bool? _isActive;
  bool get isActive => _isActive ?? false;
  bool hasIsActive() => _isActive != null;

  void _initializeFields() {
    _url = snapshotData['url'] as String?;
    _type = snapshotData['type'] as String?;
    _isActive = snapshotData['is_active'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('playlist');

  static Stream<PlaylistRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PlaylistRecord.fromSnapshot(s));

  static Future<PlaylistRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PlaylistRecord.fromSnapshot(s));

  static PlaylistRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PlaylistRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PlaylistRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PlaylistRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PlaylistRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PlaylistRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPlaylistRecordData({
  String? url,
  String? type,
  bool? isActive,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'url': url,
      'type': type,
      'is_active': isActive,
    }.withoutNulls,
  );

  return firestoreData;
}

class PlaylistRecordDocumentEquality implements Equality<PlaylistRecord> {
  const PlaylistRecordDocumentEquality();

  @override
  bool equals(PlaylistRecord? e1, PlaylistRecord? e2) {
    return e1?.url == e2?.url &&
        e1?.type == e2?.type &&
        e1?.isActive == e2?.isActive;
  }

  @override
  int hash(PlaylistRecord? e) =>
      const ListEquality().hash([e?.url, e?.type, e?.isActive]);

  @override
  bool isValidKey(Object? o) => o is PlaylistRecord;
}
