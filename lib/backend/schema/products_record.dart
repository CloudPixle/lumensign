import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ProductsRecord extends FirestoreRecord {
  ProductsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "image_base64" field.
  String? _imageBase64;
  String get imageBase64 => _imageBase64 ?? '';
  bool hasImageBase64() => _imageBase64 != null;

  // "label" field.
  String? _label;
  String get label => _label ?? '';
  bool hasLabel() => _label != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  bool hasCategory() => _category != null;

  void _initializeFields() {
    _imageBase64 = snapshotData['image_base64'] as String?;
    _label = snapshotData['label'] as String?;
    _description = snapshotData['description'] as String?;
    _category = snapshotData['category'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('products');

  static Stream<ProductsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ProductsRecord.fromSnapshot(s));

  static Future<ProductsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ProductsRecord.fromSnapshot(s));

  static ProductsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ProductsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ProductsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ProductsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ProductsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ProductsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createProductsRecordData({
  String? imageBase64,
  String? label,
  String? description,
  String? category,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'image_base64': imageBase64,
      'label': label,
      'description': description,
      'category': category,
    }.withoutNulls,
  );

  return firestoreData;
}

class ProductsRecordDocumentEquality implements Equality<ProductsRecord> {
  const ProductsRecordDocumentEquality();

  @override
  bool equals(ProductsRecord? e1, ProductsRecord? e2) {
    return e1?.imageBase64 == e2?.imageBase64 &&
        e1?.label == e2?.label &&
        e1?.description == e2?.description &&
        e1?.category == e2?.category;
  }

  @override
  int hash(ProductsRecord? e) => const ListEquality()
      .hash([e?.imageBase64, e?.label, e?.description, e?.category]);

  @override
  bool isValidKey(Object? o) => o is ProductsRecord;
}
