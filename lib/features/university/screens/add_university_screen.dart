import 'package:document_sharing_app/core/widgets/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:document_sharing_app/features/university/controller/university_controller.dart';
import 'package:go_router/go_router.dart';

/// Screen for adding a new university.
class AddUniversityScreen extends StatefulWidget {
  const AddUniversityScreen({super.key});

  @override
  State<AddUniversityScreen> createState() => _AddUniversityScreenState();
}

class _AddUniversityScreenState extends State<AddUniversityScreen> {
  final UniversityController _universityController =
      Get.find<UniversityController>(); // Using GetX for state management

  final TextEditingController _universityNameController =
      TextEditingController();
  final TextEditingController _universityCityController =
      TextEditingController();
  final TextEditingController _universityStateController =
      TextEditingController();
  final TextEditingController _universityCountryController =
      TextEditingController();

  @override
  void dispose() {
    _universityNameController.dispose();
    _universityCityController.dispose();
    _universityStateController.dispose();
    _universityCountryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _universityController.isLoading.value
          ? const GenLoader()
          : Scaffold(
              body: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.pop(); // Navigate back
                          },
                          child: const Row(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.chevron_left),
                                  Text("Select University")
                                ],
                              ),
                              Spacer()
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Add University",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            letterSpacing: -1,
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Here you have give us some details\nto correctly identify your institution.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextField(
                          controller: _universityNameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Name",
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _universityCityController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "City",
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _universityStateController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "State",
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _universityCountryController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Country",
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 36.0),
                          child: ElevatedButton(
                            onPressed: () {
                              _universityController.createNewUniversity(
                                context,
                                _universityNameController.text,
                                _universityCityController.text,
                                _universityStateController.text,
                                _universityCountryController.text,
                              ); // Create new university
                            },
                            child: const Text(
                              "Add",
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
