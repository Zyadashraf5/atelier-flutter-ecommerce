import 'package:flutter/material.dart';

/// Shared breakpoints and layout helpers for phone / tablet / desktop widths.
abstract final class AppResponsive {
  static const double _tablet = 600;
  static const double _desktop = 900;
  static const double _wide = 1100;

  static double widthOf(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  static double heightOf(BuildContext context) =>
      MediaQuery.sizeOf(context).height;

  /// Readable horizontal inset for scroll/content.
  static double horizontalPadding(BuildContext context) {
    final w = widthOf(context);
    if (w >= _wide) return 32;
    if (w >= _desktop) return 28;
    if (w >= _tablet) return 24;
    return 20;
  }

  /// Max width for form cards / centered columns on large screens.
  static double maxContentWidth(BuildContext context) {
    final w = widthOf(context);
    if (w >= _wide) return 520;
    if (w >= _desktop) return 480;
    return double.infinity;
  }

  static int gridCrossAxisCount(BuildContext context) {
    final w = widthOf(context);
    if (w >= _wide) return 4;
    if (w >= _desktop) return 3;
    if (w >= _tablet) return 3;
    return 2;
  }

  /// Search / product grids: spacing scales slightly on larger canvases.
  static double gridMainAxisSpacing(BuildContext context) {
    final w = widthOf(context);
    if (w >= _tablet) return 26;
    return 22;
  }

  static double gridCrossAxisSpacing(BuildContext context) {
    final w = widthOf(context);
    if (w >= _tablet) return 22;
    return 18;
  }

  static double searchGridChildAspectRatio(BuildContext context) {
    final n = gridCrossAxisCount(context);
    if (n >= 4) return 0.66;
    if (n >= 3) return 0.63;
    return 0.56;
  }

  static double scaleFont(BuildContext context, double base) {
    final w = widthOf(context);
    if (w >= _wide) return base * 1.05;
    if (w >= _tablet) return base * 1.02;
    return base;
  }
}

// Fix typo - I used width_of instead of widthOf
