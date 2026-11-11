import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mine_ecommerce/core/bindings/initial_binding.dart';
import 'package:mine_ecommerce/core/constants/app_colors.dart';
import 'package:mine_ecommerce/core/theme/app_theme.dart';
import 'package:mine_ecommerce/firebase_options.dart';
import 'package:mine_ecommerce/routes/app_pages.dart';
import 'package:mine_ecommerce/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
  final firebaseReady = await _tryInitFirebase();
  runApp(AtelierApp(firebaseReady: firebaseReady));
}

Future<bool> _tryInitFirebase() async {
  const maxAttempts = 4;
  for (var attempt = 0; attempt < maxAttempts; attempt++) {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      return Firebase.apps.isNotEmpty;
    } on PlatformException catch (e, st) {
      debugPrint('Firebase init attempt ${attempt + 1}/$maxAttempts: $e\n$st');
      final isChannel = e.code == 'channel-error' ||
          (e.message?.contains('channel') ?? false);
      if (isChannel && attempt < maxAttempts - 1) {
        await Future<void>.delayed(Duration(milliseconds: 300 * (attempt + 1)));
        continue;
      }
      return false;
    } on FirebaseException catch (e, st) {
      debugPrint('Firebase init failed: $e\n$st');
      return false;
    } catch (e, st) {
      debugPrint('Firebase init failed: $e\n$st');
      return false;
    }
  }
  return false;
}

class AtelierApp extends StatelessWidget {
  const AtelierApp({super.key, required this.firebaseReady});

  final bool firebaseReady;

  @override
  Widget build(BuildContext context) {
    if (!firebaseReady) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_off_outlined,
                        size: 56,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Firebase not connected',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'We upgraded firebase_core to v4 — run pub get, uninstall '
                        'the app, then flutter run. If this persists, try a Pixel '
                        'API 34 emulator with Google Play.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          height: 1.45,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'cd android\n.\\gradlew.bat --stop\ncd ..\n'
                        'flutter clean && flutter pub get && flutter run',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.robotoMono(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return GetMaterialApp(
      title: 'Atelier',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.splash,
      initialBinding: InitialBinding(),
      getPages: AppPages.routes,
    );
  }
}
