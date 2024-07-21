import 'package:document_sharing_app/core/constants/shared_preferences_constants.dart';
import 'package:document_sharing_app/core/typedefs/typedefs.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/instance_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Repository for managing hero screen related data operations
class HeroScreenRepository {
  // Instance of SharedPreferences
  final Future<SharedPreferences> _sharedPreferencesInstance =
      Get.put(SharedPreferences.getInstance());

  // Function to check if the user is authenticated
  FutureEither<bool> isAuthenticated() async {
    try {
      final prefs = await _sharedPreferencesInstance;
      // Retrieve the authentication status from SharedPreferences
      final isAuth =
          prefs.getBool(SharedPreferencesKeys.isAuthenticated) ?? false;
      return right(isAuth);
    } catch (e) {
      // Return error message in case of failure
      return left(e.toString());
    }
  }
}
