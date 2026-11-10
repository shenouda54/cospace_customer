import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cospace_customer/core/storage/cache_helper.dart';
import 'package:cospace_customer/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (gracefully handles pending platform credentials)
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization warning (run flutterfire configure): $e');
  }

  // Initialize local storage (SharedPreferences)
  await CacheHelper.init();

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const CoSpaceCustomerApp());
}
