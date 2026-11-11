import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mine_ecommerce/data/catalog/catalog_product_assets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Fills empty `categories` + `products` when a user is signed in.
/// Requires Firestore rules that allow `create` on those collections for authed users.
class FirestoreSeeder {
  static const String _imagePatchPrefsKey = 'catalog_image_patch_v';
  static const int _imagePatchVersion = 3;

  /// Seeds empty catalog, then applies latest image URLs to known product ids (one-time per version).
  static Future<void> ensureCatalogReady() async {
    await seedCatalogIfEmpty();
    await patchCatalogImageUrlsIfNeeded();
  }

  /// Call after login/register or when opening the app with an existing session.
  static Future<void> seedCatalogIfEmpty() async {
    if (Firebase.apps.isEmpty) {
      debugPrint('FirestoreSeeder: skip — no Firebase app.');
      return;
    }
    if (FirebaseAuth.instance.currentUser == null) {
      debugPrint('FirestoreSeeder: skip — not signed in.');
      return;
    }
    try {
      final db = FirebaseFirestore.instance;
      final sample = await db.collection('products').limit(1).get();
      if (sample.docs.isNotEmpty) {
        return;
      }

      final batch = db.batch();

      void setCat(String id, String name, int sort) {
        batch.set(db.collection('categories').doc(id), {
          'name': name,
          'sortOrder': sort,
        });
      }

      setCat('furniture', 'Furniture', 1);
      setCat('textiles', 'Textiles', 2);
      setCat('lighting', 'Lighting', 3);
      setCat('ceramics', 'Ceramics', 4);

      void setProduct(
        String id, {
        required String name,
        required String subtitle,
        required String description,
        required double price,
        required String categoryId,
        required int stock,
        bool isLimited = false,
      }) {
        final assets = CatalogProductAssets.byId[id]!;
        batch.set(db.collection('products').doc(id), {
          'name': name,
          'subtitle': subtitle,
          'description': description,
          'price': price,
          'imageUrl': assets.imageUrl,
          'imageUrls': assets.imageUrls,
          'categoryId': categoryId,
          'stock': stock,
          'isLimited': isLimited,
        });
      }

      setProduct(
        'p1',
        name: 'Harlow Velvet Lounge',
        subtitle: 'Sculptural seating',
        description:
            'Deep-seated lounge chair with velvet upholstery and a low, inviting profile.',
        price: 840,
        categoryId: 'furniture',
        stock: 6,
        isLimited: true,
      );
      setProduct(
        'p2',
        name: 'Basalt Ribbed Vase',
        subtitle: 'Matte volcanic glaze',
        description:
            'Hand-finished ceramic vase with vertical ribbing and a soft matte glaze.',
        price: 125,
        categoryId: 'ceramics',
        stock: 22,
      );
      setProduct(
        'p3',
        name: 'Orbital Brass Lamp',
        subtitle: 'Architectural light',
        description:
            'Articulating brass desk lamp with warm dimmable LED and weighted base.',
        price: 310,
        categoryId: 'lighting',
        stock: 14,
      );
      setProduct(
        'p4',
        name: 'Fjord Linen Pillow',
        subtitle: 'Natural weave',
        description:
            'European linen cushion with hidden zipper and feather-down insert.',
        price: 75,
        categoryId: 'textiles',
        stock: 40,
      );
      setProduct(
        's1',
        name: 'Earthen Vessel No. 04',
        subtitle: 'Hand-thrown stoneware',
        description:
            'Small-batch stoneware vessel with subtle iron speckle and satin interior.',
        price: 185,
        categoryId: 'ceramics',
        stock: 8,
        isLimited: true,
      );
      setProduct(
        's3',
        name: 'Studio Pitcher II',
        subtitle: 'Speckled cream ceramic',
        description:
            'Pouring pitcher with ergonomic handle and food-safe glaze.',
        price: 96,
        categoryId: 'ceramics',
        stock: 18,
      );
      setProduct(
        's4',
        name: 'Kintsugi Bowl Set',
        subtitle: 'Porcelain repair art',
        description: 'Two nested porcelain bowls with gold-trace accent lines.',
        price: 240,
        categoryId: 'ceramics',
        stock: 5,
        isLimited: true,
      );
      setProduct(
        'nomad',
        name: 'The Nomad II \'Onyx\'',
        subtitle: 'LIMITED EDITION',
        description:
            'Handcrafted from top-grain calfskin with an ergonomic footbed and '
            'carbon-fiber shank. Lasted by artisans with a monochrome welt.',
        price: 285,
        categoryId: 'textiles',
        stock: 12,
        isLimited: true,
      );

      await batch.commit();
      debugPrint('FirestoreSeeder: catalog seeded.');
    } on FirebaseException catch (e, st) {
      debugPrint('FirestoreSeeder failed: $e\n$st');
      _notifySeedFailure(e);
    } catch (e, st) {
      debugPrint('FirestoreSeeder failed: $e\n$st');
    }
  }

  /// Updates `imageUrl` / `imageUrls` for seeded product ids so older Firestore rows pick up fixed CDN links.
  static Future<void> patchCatalogImageUrlsIfNeeded() async {
    if (Firebase.apps.isEmpty) {
      return;
    }
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getInt(_imagePatchPrefsKey) == _imagePatchVersion) {
      return;
    }
    try {
      final db = FirebaseFirestore.instance;
      final batch = db.batch();
      var count = 0;
      for (final id in CatalogProductAssets.seededProductIds) {
        final ref = db.collection('products').doc(id);
        final snap = await ref.get();
        if (!snap.exists) {
          continue;
        }
        final assets = CatalogProductAssets.byId[id]!;
        batch.update(ref, {
          'imageUrl': assets.imageUrl,
          'imageUrls': assets.imageUrls,
        });
        count++;
      }
      if (count > 0) {
        await batch.commit();
        debugPrint('FirestoreSeeder: patched image URLs for $count products.');
      }
      await prefs.setInt(_imagePatchPrefsKey, _imagePatchVersion);
    } on FirebaseException catch (e, st) {
      debugPrint('FirestoreSeeder patch failed: $e\n$st');
    } catch (e, st) {
      debugPrint('FirestoreSeeder patch failed: $e\n$st');
    }
  }

  static void _notifySeedFailure(FirebaseException e) {
    if (Get.context == null) {
      return;
    }
    if (e.code == 'permission-denied') {
      Get.snackbar(
        'Firestore',
        'permission-denied: Deploy project firestore.rules '
        '(firebase deploy --only firestore:rules) then sign in again.',
        duration: const Duration(seconds: 8),
      );
    } else {
      Get.snackbar('Firestore', '${e.code}: ${e.message}', duration: const Duration(seconds: 5));
    }
  }
}
