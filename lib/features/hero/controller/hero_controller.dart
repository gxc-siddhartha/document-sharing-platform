import 'package:document_sharing_app/features/hero/repository/hero_repository.dart';
import 'package:get/get.dart';

// Controller for managing hero screen logic
class HeroScreenController extends GetxController {
  // Reactive variable to track if the user is logged in
  final RxBool _isLoggedIn = false.obs;

  // Instance of HeroScreenRepository to handle authentication logic
  final HeroScreenRepository _heroScreenRepository =
      Get.put(HeroScreenRepository());

  // Getter for the logged-in status
  bool get isLoggedIn => _isLoggedIn.value;

  // Function to set the status of the user's authentication
  Future<void> updateAuthenticationStatus() async {
    final result = await _heroScreenRepository.isAuthenticated();
    result.fold(
      (failure) {
        // Handle error if needed
      },
      (isAuthenticated) {
        _isLoggedIn.value = isAuthenticated;
      },
    );
  }
}
