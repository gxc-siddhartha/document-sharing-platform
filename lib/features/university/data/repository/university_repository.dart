import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:document_sharing_app/core/constants/shared_preferences_constants.dart';
import 'package:document_sharing_app/core/typedefs/typedefs.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/instance_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/university_model.dart';

class UniversityRepository {
  // Firestore instance for database operations
  final FirebaseFirestore _firestore = Get.put(FirebaseFirestore.instance);

  // SharedPreferences instance for storing persistent data
  final Future<SharedPreferences> _sharedPreferencesInstance =
      Get.put(SharedPreferences.getInstance());

  /// Retrieves a list of universities from Firestore based on a query string.
  /// The query is performed on the 'name_lowerspace' field in a case-insensitive manner.
  ///
  /// Returns:
  /// - Right(List<UniversityModel>): A list of matching UniversityModel objects.
  /// - Left(String): An error message if an exception occurs.
  FutureEither<List<UniversityModel>> fetchUniversities(String query) async {
    try {
      // Perform a case-insensitive search in Firestore
      final QuerySnapshot snapshot = await _firestore
          .collection('university')
          .where(
            'name_lowerspace',
            isGreaterThanOrEqualTo: query.toLowerCase(),
          )
          .where(
            'name_lowerspace',
            isLessThanOrEqualTo: query.toLowerCase() + '\uf8ff',
          ) // Range query
          .get();

      // Map query results to a list of UniversityModel objects
      final List<UniversityModel> universities = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UniversityModel.fromMap(data);
      }).toList();

      return right(universities); // Return the list of universities on success
    } catch (e) {
      // Catch and return any exceptions as an error message
      return left(e.toString());
    }
  }

  /// Adds a new university to Firestore and updates shared preferences if successful.
  ///
  /// Returns:
  /// - Right(UniversityModel): The newly added UniversityModel object.
  /// - Left(String): An error message if an exception occurs.
  FutureEither<UniversityModel> addUniversity(
      UniversityModel university) async {
    try {
      // Create a reference to the Firestore document for the new university
      final DocumentReference docRef =
          _firestore.collection('university').doc(university.id);

      // Convert the university model to a map for storage in Firestore
      final data = university.toMap();

      // Add the university data to Firestore
      await docRef.set(data);

      return right(university); // Return the added university on success
    } on FirebaseException catch (e) {
      // Handle Firebase-specific exceptions
      return left(e.message ?? "Firebase Error");
    } catch (e) {
      // Handle other exceptions
      return left(
        e.toString(),
      );
    }
  }

  /// Retrieves a university from Firestore by its unique ID.
  ///
  /// Returns:
  /// - Right(UniversityModel): The matching UniversityModel object.
  /// - Left(String): An error message if the university is not found or an exception occurs.
  FutureEither<UniversityModel> fetchUniversityById(String universityId) async {
    try {
      // Get the university document from Firestore
      final DocumentSnapshot snapshot =
          await _firestore.collection('university').doc(universityId).get();

      if (snapshot.exists) {
        // If the document exists, convert it to a UniversityModel and return it
        final data = snapshot.data() as Map<String, dynamic>;
        return right(
          UniversityModel.fromMap(
            data,
          ),
        );
      } else {
        // If the document doesn't exist, return an error message
        return left("University not found");
      }
    } on FirebaseException catch (e) {
      // Handle Firebase-specific exceptions
      return left(e.message ?? "Firebase Error");
    } catch (e) {
      // Handle other exceptions
      return left(e.toString());
    }
  }

  /// Adds a university to the user's model in Firestore.
  ///
  /// Returns:
  /// - Right(null): Indicates successful update.
  /// - Left(String): An error message if an exception occurs.
  FutureEither<void> addUniversityToUser(UniversityModel model) async {
    final prefs = await _sharedPreferencesInstance;
    try {
      final userId = prefs.getString(SharedPreferencesKeys.userId) ?? "";

      if (userId.isNotEmpty) {
        await _firestore.collection("users").doc(userId).update(
          {
            "current_university": model.toMap(),
          },
        );
      }
      return right(null); // Success
    } catch (e) {
      // Return any exceptions as an error message

      return left(e.toString());
    }
  }
}
