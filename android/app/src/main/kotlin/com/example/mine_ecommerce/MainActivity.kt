package com.example.mine_ecommerce

import com.google.firebase.FirebaseApp
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        // Default app from google-services.json; ensures native Firebase exists
        // before Dart firebase_core attaches (avoids channel races on some devices).
        if (FirebaseApp.getApps(applicationContext).isEmpty()) {
            FirebaseApp.initializeApp(applicationContext)
        }
        super.configureFlutterEngine(flutterEngine)
    }
}
