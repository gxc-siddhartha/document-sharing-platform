import 'package:document_sharing_app/core/router/router_service.dart';
import 'package:document_sharing_app/core/widgets/helper_widgets.dart';
import 'package:document_sharing_app/features/home/controller/home_controller.dart';
import 'package:document_sharing_app/features/home/dialog/add_course_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- Controller ---
  final HomeController _homeController = Get.put(HomeController());

  String formatDate(String date) {
    final formattedDate = DateFormat("MMMM d, yyyy").format(
      DateTime.fromMillisecondsSinceEpoch(
        int.parse(
          date,
        ),
      ),
    );
    return formattedDate;
  }

  @override
  void initState() {
    super.initState();
    // Fetch user profile data after the widget is built
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _homeController.fetchUserProfile(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _homeController.isLoading
          ? const GenLoader() // Show loading indicator during initial data fetching
          : Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {}, // Placeholder action for the leading icon
                  icon: const Icon(CupertinoIcons.bars),
                ),
                actions: [
                  IconButton(
                    onPressed: () => _homeController
                        .signOutUser(context), // Trigger sign-out
                    icon: const Icon(CupertinoIcons.clear),
                  ),
                ],
                title: const Text("Home"),
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  _homeController.fetchUserProfile();
                },
                child: _homeController
                        .hasUniversity // Use the getter for reactive value
                    ? _buildCourseList(context)
                    : _buildUniversityPrompt(context),
              ),
              floatingActionButton: _homeController.hasUniversity
                  ? FloatingActionButton(
                      onPressed: () => _showAddCourseDialog(context),
                      child: const Icon(CupertinoIcons.add),
                    )
                  : null, // No FAB if the user doesn't have a university
            ),
    );
  }

  // --- Widget Builders ---

  /// Builds the list of courses when the user has a university.
  Widget _buildCourseList(BuildContext context) {
    return _homeController.courses.length == 0
        ? Center(
            child: Text("Add a course to get started"),
          )
        : ListView.builder(
            itemCount: _homeController.courses.length,
            itemBuilder: (context, index) {
              final course = _homeController.courses[index];
              Container(
                decoration: BoxDecoration(),
              );
              return ListTile(
                onTap: () {
                  context.goNamed(
                    RouterConstants.divisionScreenRouteName,
                    pathParameters: {
                      "courseId": course.uid,
                      "universityId":
                          _homeController.activeUser!.current_university!.id,
                    },
                  );
                },
                trailing: const Icon(
                  CupertinoIcons.chevron_right,
                  size: 18,
                ),
                tileColor: index.isOdd
                    ? Theme.of(context).colorScheme.tertiary.withOpacity(0.1)
                    : Colors.transparent,
                title: Expanded(child: Text(course.name)),
                subtitle: Text(
                  formatDate(
                    course.dateCreated,
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              );
            },
          );
  }

  /// Builds a prompt for the user to select a university if they haven't yet.
  Widget _buildUniversityPrompt(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          textAlign: TextAlign.center,
          "Please select an institution to get started.",
        ),
        TextButton(
          onPressed: () => context.goNamed(RouterConstants
              .selectUniversityRouteName), // Navigate to university selection
          child: const Text("Select"),
        ),
      ],
    );
  }

  // --- Helper Methods ---

  /// Shows the bottom sheet dialog for adding a new course.
  void _showAddCourseDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      builder: (_) => AddCourseDialog(homeController: _homeController),
    );
  }
}
