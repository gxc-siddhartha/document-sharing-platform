import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:document_sharing_app/core/router/router_service.dart';
import 'package:document_sharing_app/features/hero/controller/hero_controller.dart';
import 'package:document_sharing_app/firebase_options.dart';
import 'package:document_sharing_app/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the main application
  runApp(
    const MainApp(),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({
    super.key,
  });

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final HeroScreenController _heroScreenController =
      Get.put(HeroScreenController()); // Initialize HeroScreenController

  @override
  void initState() {
    _heroScreenController.updateAuthenticationStatus(); // Set initial status
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Obx(
      () => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppThemeStyle.lightTheme, // Set light theme
        routerConfig: _heroScreenController.isLoggedIn
            ? RouterService.loggedInRoute // Use loggedInRoute if logged in
            : RouterService
                .loggedOutRouter, // Use loggedOutRouter if not logged in
      ),
    );
  }
}
