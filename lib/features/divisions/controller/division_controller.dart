import 'package:document_sharing_app/features/divisions/model/division_model.dart';
import 'package:document_sharing_app/features/divisions/repository/division_repository.dart';
import 'package:document_sharing_app/features/home/data/models/course_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class DivisionController extends GetxController {
  // Injected repository for data access
  final DivisionRepository _divisionRepository =
      Get.put<DivisionRepository>(DivisionRepository());

  // Observables for UI state
  Rx<CourseModel> _course = CourseModel.emptyObject().obs;
  RxList<DivisionModel> _divisions = <DivisionModel>[].obs;
  RxBool _isLoading = false.obs;
  RxBool _isAddingDivision = false.obs;

  // Getters for easy access to reactive variables
  CourseModel get course => _course.value;
  List<DivisionModel> get divisions => _divisions;
  bool get isLoading => _isLoading.value;
  bool get isAddingDivision => _isAddingDivision.value;

  /// Fetches a course by its ID and then its divisions.
  void fetchCourseAndDivisions(String universityId, String courseId) async {
    _isLoading.value = true;

    final courseResult =
        await _divisionRepository.getCourseById(universityId, courseId);
    courseResult.fold(
      (failure) {
        // Handle the error, e.g., show a snackbar or dialog
        print("Error fetching course: $failure");
        _isLoading.value = false;
      },
      (fetchedCourse) {
        _course.value = fetchedCourse;
        fetchDivisions(universityId,
            courseId); // Immediately fetch divisions after getting the course
      },
    );
  }

  /// Adds a new division to a course.
  void createDivisionForCourse(BuildContext context, String name,
      String universityId, String courseId) async {
    _isAddingDivision.value = true;

    if (name.trim().isNotEmpty) {
      // Validate input
      final divisionId = const Uuid().v4();
      final newDivision = DivisionModel(
        name: name,
        divisionId: divisionId,
        dateCreated: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      final addResult = await _divisionRepository.createDivisionForCourse(
          newDivision, courseId, universityId, divisionId);

      addResult.fold(
        (failure) {
          print("Error adding division: $failure"); // Handle error
          _isAddingDivision.value = false;
        },
        (_) {
          // On success, update the local list (optional, but good for UI responsiveness)
          _divisions.add(newDivision);
          context
              .pop(); // Assuming context.pop() is meant to close a dialog/bottom sheet in GetX
          _isAddingDivision.value = false;
        },
      );
    } else {
      // Handle empty name input, e.g., show an error message
      print("Division name cannot be empty");
      _isAddingDivision.value = false;
    }
  }

  /// Fetches the divisions for a given course.
  void fetchDivisions(String universityId, String courseId) async {
    _isLoading.value = true;

    final divisionsResult =
        await _divisionRepository.getDivisionsForCourse(courseId, universityId);
    divisionsResult.fold(
        (failure) => print("Error fetching divisions: $failure"),
        (fetchedDivisions) => _divisions.value = fetchedDivisions);

    _isLoading.value = false;
  }

  /// Resets the controller's state.
  void reset() {
    _divisions.value = [];
    _course.value = CourseModel.emptyObject();
  }
}
