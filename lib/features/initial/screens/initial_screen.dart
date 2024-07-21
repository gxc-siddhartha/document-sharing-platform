import 'package:document_sharing_app/core/widgets/helper_widgets.dart'; // Assuming this contains the Loader widget
import 'package:document_sharing_app/features/initial/controller/initial_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  // Controller for authentication logic (renamed for consistency)
  final AuthenticationController _authController =
      Get.put<AuthenticationController>(AuthenticationController());

  @override
  void initState() {
    super.initState();
    // Initialization logic (checking for existing login) can be handled in the AuthenticationController
  }

  /// Triggers the Google sign-in process through the AuthenticationController.
  void _initiateGoogleSignIn() {
    _authController.signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => _authController.isLoading // Use the getter for isLoading
            ? const Loader() // Show loading indicator while authentication is in progress
            : Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/login_emote.png'),
                        const Text(
                          "Resoursa",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "A minimal solution for all your university needs",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 36),
                          child: ElevatedButton(
                            onPressed: _initiateGoogleSignIn,
                            child: const Text("Continue with Google"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
