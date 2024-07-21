import 'package:document_sharing_app/features/subjects/data/subject_model.dart';
import 'package:document_sharing_app/features/subjects/repository/subject_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class SubjectController extends GetxController {
  // Injected repository for data access
  final SubjectRepository _subjectRepository = Get.put<SubjectRepository>(
    SubjectRepository(),
  );

  // Observables for UI state
  RxBool _isLoading = false.obs;
  RxBool _isDialogLoading = false.obs;
  RxList<SubjectModel> _subjects = <SubjectModel>[].obs;

  // Getters for easy access to reactive variables
  bool get isLoading => _isLoading.value;
  bool get isDialogLoading => _isDialogLoading.value;
  List<SubjectModel> get subjects => _subjects;

  /// Creates a new subject in the specified division.
  /// Handles name validation, subject creation, and UI updates.
  void createSubject(BuildContext context, String name, String universityId,
      String courseId, String divisionId) async {
    if (name.trim().isNotEmpty) {
      // Validate input
      _isDialogLoading.value = true; // Start loading state

      final subjectId = const Uuid().v4();
      final subjectName = await toBeginningOfSentenceCase(name); // Format name
      final createdDate = DateTime.now().millisecondsSinceEpoch.toString();

      final newSubject = SubjectModel(
        name: subjectName,
        subjectId: subjectId,
        createdDate: createdDate,
      );

      final result = await _subjectRepository.createSubject(
          newSubject, universityId, courseId, divisionId);

      result.fold((l) {
        // Handle error, e.g., show a Snackbar or alert dialog
        print("Error creating subject: $l");
      }, (r) {
        _subjects.add(
            newSubject); // Update local list for immediate UI feedback (optional)
        context.pop(); // Close dialog/bottom sheet
        _isDialogLoading.value = false; // Stop loading state
      });
    } else {
      // Handle empty name input, e.g., show an error message
      print("Subject name cannot be empty");
    }
  }

  /// Fetches the list of subjects for a given division.
  /// Handles loading state, error display, and UI updates.
  void fetchSubjects(BuildContext context, String universityId, String courseId,
      String divisionId) async {
    _isLoading.value = true;
    _resetSubjects(); // Clear previous subjects (if any)

    final result = await _subjectRepository.fetchSubjects(
        universityId, courseId, divisionId);

    result.fold((l) {
      // Handle error, e.g., show a Snackbar or alert dialog
      print("Error fetching subjects: $l");
    }, (fetchedSubjects) async {
      _subjects.value = fetchedSubjects;
      _isLoading.value = false;
      // Optional: Delay to simulate loading (remove in production)
      // await Future.delayed(const Duration(seconds: 1));
    });
  }

  /// Resets the subject list.
  void _resetSubjects() {
    _subjects.value = [];
  }
}
