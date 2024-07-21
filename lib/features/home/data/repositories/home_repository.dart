import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:document_sharing_app/core/constants/shared_preferences_constants.dart';
import 'package:document_sharing_app/core/typedefs/typedefs.dart';
import 'package:document_sharing_app/features/home/data/models/course_model.dart';
import 'package:document_sharing_app/features/initial/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Repository responsible for handling user data, authentication, and interactions with Firestore.
class HomeRepository extends GetxService {
  // --- Dependencies (Injected using GetX) ---
  final Future<SharedPreferences> _sharedPrefs =
      Get.put(SharedPreferences.getInstance());
  final FirebaseAuth _firebaseAuth =
      Get.put<FirebaseAuth>(FirebaseAuth.instance);
  final FirebaseFirestore _firestore =
      Get.put<FirebaseFirestore>(FirebaseFirestore.instance);
  final GoogleSignIn _googleSignIn = Get.put<GoogleSignIn>(GoogleSignIn());

  // --- Reactive Variables (using Rx for state management) ---
  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);

  // --- Getters for Reactive Variables ---
  UserModel? get currentUser => _currentUser.value;

  // --- Authentication Methods ---

  /// Signs out the currently authenticated user from the app.
  ///
  /// Clears user data from `SharedPreferences` and signs the user out from both
  /// Google and Firebase authentication services.
  FutureEither<void> signOutUser() async {
    try {
      final prefs = await _sharedPrefs;
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      await prefs.setString(SharedPreferencesKeys.userId, "");
      await prefs.setBool(SharedPreferencesKeys.isAuthenticated, false);
      _currentUser.value = null; // Clear the reactive user data
      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }

  /// Fetches the profile of the currently authenticated user from Firestore.
  FutureEither<UserModel> getCurrentUserProfile() async {
    try {
      final prefs = await _sharedPrefs;
      final userId = prefs.getString(SharedPreferencesKeys.userId) ?? "";
      if (userId.isEmpty) return left("No user logged in.");

      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return left("User profile not found.");

      final userModel =
          UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      _currentUser.value = userModel; // Update the reactive user data
      return right(userModel);
    } on FirebaseException catch (e) {
      return left(e.message ?? "Failed to fetch user profile.");
    }
  }

  // --- Course Management Methods ---

  /// Adds a new course to a specified university's collection in Firestore.
  Future<Either<String, void>> addCourseToUniversity(
      CourseModel course, String universityId) async {
    try {
      if (universityId.isEmpty) {
        return left("Invalid parameters provided.");
      }

      await _firestore
          .collection("university")
          .doc(universityId)
          .collection("courses")
          .doc(course.uid)
          .set(course.toMap());
      return right(null);
    } on FirebaseException catch (e) {
      return left(e.message ?? "Failed to add course.");
    } catch (e) {
      return left("An unexpected error occurred.");
    }
  }

  /// Fetches a list of courses associated with a specific university from Firestore.
  FutureEither<List<CourseModel>> getCoursesForUniversity(
      String universityId) async {
    try {
      final querySnapshot = await _firestore
          .collection('university')
          .doc(universityId)
          .collection('courses')
          .get();

      final courses = querySnapshot.docs
          .map((doc) => CourseModel.fromMap(doc.data()))
          .toList();

      return right(courses);
    } on FirebaseException catch (e) {
      return left(e.message ?? "Failed to fetch courses for university.");
    }
  }
}
