import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:document_sharing_app/core/constants/shared_preferences_constants.dart';
import 'package:document_sharing_app/core/typedefs/typedefs.dart';
import 'package:document_sharing_app/features/initial/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationRepository extends GetxService {
  // Dependencies (injected using GetX for easy access)
  final FirebaseAuth _firebaseAuth =
      Get.put<FirebaseAuth>(FirebaseAuth.instance);
  final GoogleSignIn _googleSignIn = Get.put<GoogleSignIn>(GoogleSignIn());
  final FirebaseFirestore _firestore =
      Get.put<FirebaseFirestore>(FirebaseFirestore.instance);
  final _sharedPrefs = Get.put(SharedPreferences.getInstance());

  // Reactive Variables (using Rx for state management)
  final Rx<UserModel?> _currentUserProfile = Rx<UserModel?>(null);

  // Getters for Reactive Variables
  UserModel? get currentUserProfile => _currentUserProfile.value;

  // --- Authentication Methods ---

  /// Authenticates the user with their Google account.
  ///
  /// Handles the Google sign-in flow, obtains Firebase credentials, and signs the
  /// user into Firebase. If the user is new, their profile is created in Firestore.
  /// The authentication state is then persisted in SharedPreferences.
  FutureEither<void> authenticateWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return left("Google sign-in cancelled.");

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final authResult = await _firebaseAuth.signInWithCredential(credential);
      final firebaseUser = authResult.user!;

      await _updateOrCreateUserProfile(
          firebaseUser, authResult.additionalUserInfo!.isNewUser);

      // Save user ID and authentication status for future sessions
      await _sharedPrefs
        ..setString(SharedPreferencesKeys.userId, firebaseUser.uid)
        ..setBool(
          SharedPreferencesKeys.isAuthenticated,
          true,
        );

      return right(null);
    } on FirebaseAuthException catch (e) {
      return left(e.message ?? "Authentication failed.");
    } catch (e) {
      return left(e.toString());
    }
  }

  /// Fetches the currently logged-in user's profile from Firestore.
  ///
  /// Retrieves the user ID from SharedPreferences, then fetches the corresponding
  /// profile data from the Firestore 'users' collection.
  FutureEither<UserModel> getCurrentUserProfile() async {
    final prefs = await _sharedPrefs;
    try {
      final userId = prefs.getString(SharedPreferencesKeys.userId);
      if (userId == null || userId.isEmpty) return left("No user logged in.");

      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return left("User profile not found.");

      final userModel =
          UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      _currentUserProfile.value = userModel; // Update the reactive variable
      return right(userModel);
    } on FirebaseException catch (e) {
      return left(e.message ?? "Failed to fetch user profile.");
    }
  }

  // --- Private Helper Methods ---

  /// Updates or creates the user's profile in Firestore.
  ///
  /// If `isNewUser` is true, a new profile is created. Otherwise, the existing
  /// profile could be updated (not implemented here for simplicity).
  Future<void> _updateOrCreateUserProfile(User user, bool isNewUser) async {
    if (isNewUser) {
      final userModel = UserModel(
        name: user.displayName!,
        email: user.email!,
        profile_image: user.photoURL ?? "",
        uid: user.uid,
      );
      await _firestore.collection("users").doc(user.uid).set(userModel.toMap());
    }
  }
}
