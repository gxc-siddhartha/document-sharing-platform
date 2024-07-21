import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:document_sharing_app/core/typedefs/typedefs.dart';
import 'package:document_sharing_app/features/divisions/model/division_model.dart';
import 'package:document_sharing_app/features/home/data/models/course_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';

class DivisionRepository {
  // Use dependency injection for testability (could also be done via constructor)
  final FirebaseFirestore _firestore = Get.find<FirebaseFirestore>();

  /// Fetches a course by its ID from Firestore.
  ///
  /// Returns a `FutureEither` containing either a `CourseModel` if successful,
  /// or an error message if the course is not found or an exception occurs.
  FutureEither<CourseModel> getCourseById(
      String universityId, String courseId) async {
    try {
      final courseDocSnapshot = await _firestore
          .collection('university')
          .doc(universityId)
          .collection('courses')
          .doc(courseId)
          .get();

      if (courseDocSnapshot.exists) {
        final courseData = courseDocSnapshot.data() as Map<String, dynamic>;
        return right(CourseModel.fromMap(courseData));
      } else {
        return left("Course not found in university $universityId");
      }
    } on FirebaseException catch (e) {
      // Log Firebase-specific errors
      print('FirebaseException: ${e.message}');
      return left(e.message ?? "Error fetching course from Firestore");
    } catch (e) {
      // Log general exceptions
      print('Error fetching course: $e');
      return left(e.toString());
    }
  }

  /// Adds a division to a specific course in Firestore.
  ///
  /// Returns a `FutureEither` indicating either success (null value) or an error message.
  FutureEither<void> createDivisionForCourse(DivisionModel division,
      String courseId, String universityId, String divisionId) async {
    try {
      await _firestore
          .collection("university")
          .doc(universityId)
          .collection('courses')
          .doc(courseId)
          .collection('divisions')
          .doc(divisionId)
          .set(division.toMap());
      return right(null);
    } catch (e) {
      print('Error creating division: $e');
      return left(e.toString());
    }
  }

  /// Retrieves all divisions associated with a course from Firestore.
  ///
  /// Returns a `FutureEither` containing either a list of `DivisionModel` objects
  /// or an error message if an exception occurs.
  FutureEither<List<DivisionModel>> getDivisionsForCourse(
      String courseId, String universityId) async {
    try {
      final divisionsSnapshot = await _firestore
          .collection("university")
          .doc(universityId)
          .collection('courses')
          .doc(courseId)
          .collection('divisions')
          .get();

      final divisions = divisionsSnapshot.docs
          .map<DivisionModel>(
            (divisionDoc) => DivisionModel.fromMap(
              divisionDoc.data() as Map<String, dynamic>,
            ),
          )
          .toList();

      return right(divisions);
    } catch (e) {
      print('Error fetching divisions: $e');
      return left(e.toString());
    }
  }
}
