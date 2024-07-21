import 'package:document_sharing_app/features/hero/controller/hero_controller.dart';
import 'package:document_sharing_app/features/home/data/models/course_model.dart';
import 'package:document_sharing_app/features/home/data/repositories/home_repository.dart';
import 'package:document_sharing_app/features/initial/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:recase/recase.dart';
import 'package:uuid/uuid.dart';

class HomeController extends GetxController {
  // --- Dependencies ---
  final HomeRepository _homeRepository = Get.put(HomeRepository());
  final HeroScreenController _heroScreenController = Get.find();

  // --- Reactive State ---
  final RxBool _isLoading = false.obs; // Indicates general loading state
  final RxBool _isDialogLoading =
      false.obs; // Indicates loading state of dialog operations
  final Rx<UserModel?> _activeUser = Rx<UserModel?>(null);
  final RxBool _hasUniversity =
      false.obs; // Indicates whether the user has a university
  final RxList<CourseModel> _courses = <CourseModel>[].obs; // List of courses

  // --- Getters for Reactive State ---
  bool get isLoading => _isLoading.value;
  bool get isDialogLoading => _isDialogLoading.value;
  UserModel? get activeUser => _activeUser.value;
  bool get hasUniversity => _hasUniversity.value;
  List<CourseModel> get courses => _courses;

  // --- Life Cycle Methods ---

  // --- Authentication Methods ---
  /// Signs out the current user from the application.
  ///
  /// Triggers the sign-out process through the `HomeRepository`, updates the
  /// hero screen status, and optionally navigates the user to another screen
  /// upon completion.
  void signOutUser(BuildContext context) async {
    _isLoading.value = true;
    final result = await _homeRepository.signOutUser();

    // Optional: Navigate to another screen (e.g., login) after sign-out
    await Future.delayed(const Duration(seconds: 1));
    result.fold(
      (error) => print(error),
      (_) {
        _heroScreenController
            .updateAuthenticationStatus(); // Reset hero screen state
        _activeUser.value = null; // Clear user data
      },
    );

    _isLoading.value = false;
  }

  // --- User Profile Methods ---

  /// Fetches the currently logged-in user's profile and updates relevant state.
  void fetchUserProfile() async {
    _isLoading.value = true;
    final result = await _homeRepository.getCurrentUserProfile();

    result.fold(
      (error) {
        _isLoading.value = false;
      },
      (user) async {
        _activeUser.value = user; // Update the reactive user
        _updateUniversityStatus(); // Check if the user has a university
        if (_hasUniversity.value) {
          _fetchCourses(); // Fetch courses if the user is in a university
          // _isLoading.value = false;
        } else {
          _isLoading.value = false;
        }
      },
    );
  }

  /// Updates the `hasUniversity` state based on whether the user has a university associated with their profile.
  void _updateUniversityStatus() {
    _hasUniversity.value = _activeUser.value?.current_university != null;
  }

  // --- Course Management Methods ---

  /// Fetches courses for the user's university and updates the `courses` list.
  void _fetchCourses() async {
    _isLoading.value = true;
    final universityId = _activeUser.value!.current_university!
        .id; // Assuming the user has a university after _updateUniversityStatus()
    final result = await _homeRepository.getCoursesForUniversity(universityId);

    result.fold(
      (error) {
        _isLoading.value = false;
      },
      (courses) {
        _courses.value = courses;
        _isLoading.value = false;
      },
    );
  }

  /// Adds a new course to the user's university.
  void addCourse(String name, BuildContext context) async {
    final courseName = ReCase(name);
    final String formattedCourseName = courseName.titleCase;
    print(formattedCourseName);

    if (formattedCourseName != "" || formattedCourseName.isNotEmpty) {
      _isDialogLoading.value = true;

      final newCourse = CourseModel(
        name: formattedCourseName,
        name_lowerspace: name.toLowerCase(),
        uid: const Uuid().v4(),
        dateCreated: DateTime.now().millisecondsSinceEpoch.toString(),
        createdBy: _activeUser.value!.uid,
        details: _activeUser.value!,
      );

      final result = await _homeRepository.addCourseToUniversity(
          newCourse, _activeUser.value!.current_university!.id);

      result.fold(
        (error) => _isDialogLoading.value = false,
        (_) async {
          await Future.delayed(const Duration(seconds: 1));
          _isDialogLoading.value = false;
          if (context.mounted) {
            context.pop();
            _fetchCourses(); // Refresh the courses list after adding a new one
          }
        },
      );
    }
  }
}
