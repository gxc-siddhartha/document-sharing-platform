import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:document_sharing_app/core/typedefs/typedefs.dart';
import 'package:document_sharing_app/features/subjects/data/subject_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';

class SubjectRepository {
  // Use dependency injection for testability (could also be done via constructor)
  final FirebaseFirestore _firestore = Get.find<FirebaseFirestore>();

  /// Adds a subject to a specific division in Firestore.
  ///
  /// Takes a `SubjectModel` object containing subject details, along with the university, course,
  /// and division IDs. Returns a `FutureEither` with either a null value on success or an error
  /// message if an exception occurs.
  FutureEither<void> createSubject(SubjectModel subjectModel,
      String universityId, String courseId, String divisionId) async {
    try {
      final subjectsCollection = _firestore
          .collection("university")
          .doc(universityId)
          .collection('courses')
          .doc(courseId)
          .collection('divisions')
          .doc(divisionId)
          .collection('subjects');

      await subjectsCollection
          .doc(subjectModel.subjectId)
          .set(subjectModel.toMap());
      return right(null);
    } catch (e) {
      // Log the error for debugging
      print('Error creating subject: $e');
      return left(e.toString());
    }
  }

  /// Retrieves a list of subjects belonging to a specific division from Firestore.
  ///
  /// Returns a `FutureEither` with either a list of `SubjectModel` objects if successful, or
  /// an error message if an exception occurs.
  FutureEither<List<SubjectModel>> fetchSubjects(
      String universityId, String courseId, String divisionId) async {
    try {
      final subjectsSnapshot = await _firestore
          .collection("university")
          .doc(universityId)
          .collection('courses')
          .doc(courseId)
          .collection('divisions')
          .doc(divisionId)
          .collection('subjects')
          .get();

      final List<SubjectModel> subjects = subjectsSnapshot.docs
          .map(
              (doc) => SubjectModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      return right(subjects);
    } catch (e) {
      // Log the error for debugging
      print('Error fetching subjects: $e');
      return left(e.toString());
    }
  }
}
