import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.sortOrder,
  });

  final String id;
  final String name;
  final int sortOrder;

  factory CategoryModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data() ?? {};
    return CategoryModel(
      id: doc.id,
      name: d['name'] as String? ?? doc.id,
      sortOrder: (d['sortOrder'] as num?)?.toInt() ?? 0,
    );
  }
}
