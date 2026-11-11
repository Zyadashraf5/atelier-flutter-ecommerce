import 'package:mine_ecommerce/core/constants/app_images.dart';

/// Single source of image URLs for seeded / catalog product ids (Firestore doc ids).
abstract final class CatalogProductAssets {
  static const List<String> seededProductIds = [
    'p1',
    'p2',
    'p3',
    'p4',
    's1',
    's3',
    's4',
    'nomad',
  ];

  /// Main + gallery URLs per product (each main is unique where possible).
  static Map<String, ({String imageUrl, List<String> imageUrls})> get byId => {
    'p1': (
      imageUrl: AppImages.chair,
      imageUrls: [AppImages.chair, AppImages.cartChair, AppImages.chairAlt],
    ),
    'p2': (
      imageUrl: AppImages.vase,
      imageUrls: [AppImages.vase, AppImages.ceramicBowls, AppImages.vaseAlt],
    ),
    'p3': (
      imageUrl: AppImages.lamp,
      imageUrls: [AppImages.lamp, AppImages.lampAlt, AppImages.cartLamp],
    ),
    'p4': (
      imageUrl: AppImages.pillow,
      imageUrls: [AppImages.pillow, AppImages.textileFold, AppImages.pillowAlt],
    ),
    's1': (
      imageUrl: AppImages.ceramicVessel,
      imageUrls: [
        AppImages.ceramicVessel,
        AppImages.ceramicBowls,
        AppImages.vase,
      ],
    ),
    's3': (
      imageUrl: AppImages.ceramic3,
      imageUrls: [AppImages.ceramic3, AppImages.vase, AppImages.ceramicVessel],
    ),
    's4': (
      imageUrl: AppImages.kintsugiBowl,
      imageUrls: [
        AppImages.kintsugiBowl,
        AppImages.ceramicBowls,
        AppImages.ceramicVessel,
      ],
    ),
    'nomad': (
      imageUrl: AppImages.shoeMain,
      imageUrls: [AppImages.shoeMain, AppImages.shoe2, AppImages.shoe3],
    ),
  };
}
