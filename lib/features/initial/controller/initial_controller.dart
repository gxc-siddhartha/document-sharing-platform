import 'package:document_sharing_app/features/hero/controller/hero_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:document_sharing_app/core/widgets/helper_functions.dart';
import 'package:document_sharing_app/features/initial/data/models/user_model.dart';
import 'package:document_sharing_app/features/initial/data/repository/initial_repository.dart'; // Assuming this is where AuthRepository now lives

class AuthenticationController extends GetxController {
  // --- Dependencies ---
  final AuthenticationRepository _authRepository =
      Get.put(AuthenticationRepository());
  final HeroScreenController _heroScreenController = Get.find();

  // --- Reactive State ---
  final RxBool _isLoading =
      false.obs; // Indicates whether an operation is in progress
  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);

  // --- Getters for Reactive State ---
  bool get isLoading => _isLoading.value;
  UserModel? get currentUser => _currentUser.value;

  // --- Authentication Methods ---

  /// Initiates the Google sign-in process.
  ///
  /// Displays a loading indicator while authentication is in progress.
  /// If successful, fetches the user's profile and updates the UI.
  /// If unsuccessful, displays an error message to the user.
  void signInWithGoogle(BuildContext context) async {
    _isLoading.value = true; // Start loading

    final result = await _authRepository.authenticateWithGoogle();

    result.fold(
      (error) {
        _isLoading.value = false; // Stop loading
        HelperFunctions.showCustomSnackBar(context, error);
      },
      (_) async {
        await _fetchAndStoreUserProfile();
        _heroScreenController
            .updateAuthenticationStatus(); // Notify other parts of the app
        _isLoading.value = false; // Stop loading after profile fetch
      },
    );
  }

  /// Fetches the user's profile from the repository and updates the reactive state.
  ///
  /// This is a private helper method used after successful authentication.
  Future<void> _fetchAndStoreUserProfile() async {
    final result = await _authRepository.getCurrentUserProfile();
    result.fold(
      (error) => print(error), // Log the error for debugging
      (user) => _currentUser.value = user, // Update the reactive user
    );
  }
}
