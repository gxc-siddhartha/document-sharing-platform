import 'package:document_sharing_app/core/router/router_service.dart';
import 'package:document_sharing_app/core/widgets/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:document_sharing_app/features/university/controller/university_controller.dart';
import 'package:go_router/go_router.dart';

/// Screen for selecting a university.
class UniversitySelectionScreen extends StatefulWidget {
  const UniversitySelectionScreen({Key? key}) : super(key: key);

  @override
  State<UniversitySelectionScreen> createState() =>
      _UniversitySelectionScreenState();
}

class _UniversitySelectionScreenState extends State<UniversitySelectionScreen> {
  final UniversityController _universityController =
      Get.put(UniversityController()); // Using GetX for state management

  final TextEditingController _universitySearchController =
      TextEditingController();

  @override
  void dispose() {
    _universitySearchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _universityController.updateFilteredList(
      [],
    );
    _universityController.onSearchQueryChanged("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => _universityController.isLoading.value
            ? const Loader() // Placeholder for loading indicator
            : Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Select Your University",
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
                          "Select your university from the drop-down\nto get started",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextField(
                          controller: _universitySearchController,
                          onChanged: (value) {
                            _universityController.onSearchQueryChanged(
                                value); // Update search query
                            _universityController.searchUniversities();
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Search",
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Obx(
                          () => _universityController
                                  .filteredUniversities.isEmpty
                              ? Container() // Placeholder for empty state
                              : Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    boxShadow: [
                                      BoxShadow(
                                        spreadRadius: 5,
                                        blurRadius: 20,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground
                                            .withOpacity(
                                              0.1,
                                            ),
                                      ),
                                    ],
                                  ),
                                  width: double.infinity,
                                  child: ListView.builder(
                                    itemCount: _universityController
                                        .filteredUniversities.length,
                                    itemBuilder: (context, index) {
                                      final university = _universityController
                                          .filteredUniversities[index];

                                      if (university.name == '') {
                                        return Container();
                                      }
                                      return GestureDetector(
                                        onTap: () {
                                          _universityController
                                              .onUniversitySelected(
                                                  university); // Select university
                                          _universitySearchController.text =
                                              university.name;
                                          _universityController
                                              .updateFilteredList([]);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                            vertical: 10,
                                          ),
                                          child: Text(
                                            university.name,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                // Action for adding a university
                                context.goNamed(
                                  RouterConstants.addUniversityRouteName,
                                );
                              },
                              child: Text(
                                "Can't find yours? Add Here",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 36.0),
                          child: ElevatedButton(
                            onPressed: () {
                              // Action for starting
                              _universityController
                                  .fetchUniversityDetails(context);
                            },
                            child: const Text(
                              "Get Started",
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
