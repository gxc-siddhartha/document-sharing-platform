import 'package:document_sharing_app/core/router/router_service.dart';
import 'package:document_sharing_app/features/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../data/models/university_model.dart';
import '../data/repository/university_repository.dart';
import '../../../../../core/widgets/helper_functions.dart';

class UniversityController extends GetxController {
  // Dependencies
  final UniversityRepository _universityRepo = Get.put(UniversityRepository());
  final HomeController _homeController = Get.find();

  // Reactive State (Observables)
  final RxString searchQuery = ''.obs;
  final RxList<UniversityModel> universities = <UniversityModel>[].obs;
  final Rx<UniversityModel> selectedUniversity =
      UniversityModel.emptyObject().obs;
  final RxBool isLoading = false.obs;

  // Getters for Reactive State
  String get userSearchQuery => searchQuery.value;
  List<UniversityModel> get filteredUniversities => universities;
  UniversityModel? get currentUniversity =>
      selectedUniversity.value.id.isEmpty ? null : selectedUniversity.value;

  RxBool universitySelected = false.obs;

  // --- Business Logic ---

  /// Fetches universities matching the search query.
  void searchUniversities() async {
    final result = await _universityRepo.fetchUniversities(searchQuery.value);
    result.fold(
      (error) => print(error), // Log errors for debugging
      (universityList) => universities.value = universityList,
    );
  }

  /// Creates and adds a new university.
  void createNewUniversity(BuildContext context, String name, String city,
      String state, String country) async {
    isLoading.value = true;
    // Input Validation (could be moved to a separate function for clarity)
    if (name.trim().isEmpty ||
        city.trim().isEmpty ||
        state.trim().isEmpty ||
        country.trim().isEmpty) {
      HelperFunctions.showCustomSnackBar(
          context, "Missing Information. Please fill in all fields.");
      isLoading.value = false;
      return;
    }

    final newUniversity = UniversityModel(
      name: name,
      name_lowerspace: name
          .toLowerCase(), // Assuming this is for case-insensitive filtering later
      id: const Uuid().v4(),
      city: city,
      state: state,
      country: country,
    );

    final result = await _universityRepo.addUniversity(newUniversity);

    result.fold(
      (error) => {
        isLoading.value = false,
        HelperFunctions.showCustomSnackBar(
            context, error.toString()), // More specific error message
      },
      (_) async {
        selectedUniversity.value =
            newUniversity; // Immediately update the selected university

        await Future.delayed(
          const Duration(seconds: 1),
          () {
            context.pushReplacementNamed(RouterConstants.homeScreenRouteName);
            isLoading.value = false;
          },
        );
      },
    );
  }

  /// Fetches university details by ID and potentially adds it to user model.
  void fetchUniversityDetails(BuildContext context) async {
    isLoading.value = true;
    if (currentUniversity != null) {
      final result =
          await _universityRepo.fetchUniversityById(currentUniversity!.id);
      result.fold(
        (l) => print(l), // Handle potential errors here if needed
        (r) async {
          final addResult = await _universityRepo.addUniversityToUser(r);
          addResult.fold(
              (l) => {
                    print(l),
                  }, (r) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              _homeController.fetchUserProfile();
              context.pop();
            });
          }); // Again, handle errors here if needed
        },
      );
    }
  }

  // --- UI Interaction ---

  /// Updates search query and triggers a fresh search.
  void onSearchQueryChanged(String query) {
    searchQuery.value = query;
    searchUniversities();
  }

  void onUniversitySelected(UniversityModel model) {
    selectedUniversity.value = model;
  }

  // (This might be redundant if you're filtering in the repository)
  void updateFilteredList(List<UniversityModel> list) {
    universities.value = list;
  }
}
