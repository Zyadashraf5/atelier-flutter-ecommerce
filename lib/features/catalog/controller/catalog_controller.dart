import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:mine_ecommerce/data/models/category_model.dart';
import 'package:mine_ecommerce/data/models/product_model.dart';

class CatalogController extends GetxController {
  List<CategoryModel> _categories = [];
  List<ProductModel> _products = [];
  bool loading = true;
  String? errorMessage;

  List<CategoryModel> get categories => _categories;
  List<ProductModel> get products => _products;

  /// Home horizontal chips: "All Objects" + category names from Firestore.
  List<String> get homeCategoryLabels => [
    'All Objects',
    ..._categories.map((c) => c.name),
  ];

  /// Search chips: "All" + same category names.
  List<String> get searchChipLabels => [
    'All',
    ..._categories.map((c) => c.name),
  ];

  String? categoryIdForHomeIndex(int index) {
    if (index <= 0) {
      return null;
    }
    final i = index - 1;
    if (i < 0 || i >= _categories.length) {
      return null;
    }
    return _categories[i].id;
  }

  String? categoryIdForSearchChipIndex(int chipIndex) {
    if (chipIndex <= 0) {
      return null;
    }
    final i = chipIndex - 1;
    if (i < 0 || i >= _categories.length) {
      return null;
    }
    return _categories[i].id;
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _catSub;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _prodSub;

  @override
  void onInit() {
    super.onInit();
    if (Firebase.apps.isEmpty) {
      loading = false;
      errorMessage =
          'Firebase is not initialized. Configure firebase_options.dart.';
      update();
      return;
    }
    _attachListeners();
  }

  void _attachListeners() {
    final db = FirebaseFirestore.instance;
    _catSub = db
        .collection('categories')
        .orderBy('sortOrder')
        .snapshots()
        .listen(
          (snap) {
            _categories = snap.docs.map(CategoryModel.fromFirestore).toList();
            update();
          },
          onError: (Object e) {
            errorMessage = e.toString();
            update();
          },
        );

    _prodSub = db
        .collection('products')
        .snapshots()
        .listen(
          (snap) {
            _products = snap.docs.map(ProductModel.fromFirestore).toList()
              ..sort((a, b) => a.name.compareTo(b.name));
            loading = false;
            errorMessage = null;
            update();
          },
          onError: (Object e) {
            loading = false;
            errorMessage = e.toString();
            update();
          },
        );
  }

  Future<ProductModel?> fetchProductById(String id) async {
    if (Firebase.apps.isEmpty) {
      return null;
    }
    final doc = await FirebaseFirestore.instance
        .collection('products')
        .doc(id)
        .get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return ProductModel.fromFirestore(doc);
  }

  @override
  void onClose() {
    _catSub?.cancel();
    _prodSub?.cancel();
    super.onClose();
  }
}
