import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.subtitle = '',
    this.description = '',
    this.categoryId = 'general',
    this.stockCount = 0,
    this.isLimited = false,
    this.imageUrls = const [],
  });

  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String subtitle;
  final String description;
  final String categoryId;
  final int stockCount;
  final bool isLimited;
  final List<String> imageUrls;

  bool get stockIsLow => stockCount > 0 && stockCount < 10;

  String get stockLabel {
    if (stockCount <= 0) {
      return 'Out of Stock';
    }
    if (stockIsLow) {
      return 'Low Stock';
    }
    return 'In Stock';
  }

  List<String> get galleryUrls {
    if (imageUrls.isNotEmpty) {
      return imageUrls;
    }
    return [imageUrl];
  }

  factory ProductModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data() ?? {};
    final rawUrls = d['imageUrls'];
    final urls = <String>[];
    if (rawUrls is List) {
      for (final u in rawUrls) {
        if (u is String && u.isNotEmpty) {
          urls.add(u);
        }
      }
    }
    return ProductModel(
      id: doc.id,
      name: d['name'] as String? ?? '',
      subtitle: d['subtitle'] as String? ?? '',
      description: d['description'] as String? ?? '',
      price: (d['price'] as num?)?.toDouble() ?? 0,
      imageUrl: d['imageUrl'] as String? ?? '',
      categoryId: d['categoryId'] as String? ?? 'general',
      stockCount: (d['stock'] as num?)?.toInt() ?? 0,
      isLimited: d['isLimited'] as bool? ?? false,
      imageUrls: urls,
    );
  }
}
