import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mine_ecommerce/main.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();
  });

  testWidgets('App launches with splash', (WidgetTester tester) async {
    await tester.pumpWidget(const AtelierApp(firebaseReady: true));
    await tester.pump();
    expect(find.textContaining('Atelier'), findsWidgets);
  });

  tearDown(Get.reset);
}
