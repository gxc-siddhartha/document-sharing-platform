import 'package:document_sharing_app/core/router/router_service.dart';
import 'package:document_sharing_app/core/widgets/helper_widgets.dart';
import 'package:document_sharing_app/features/divisions/controller/division_controller.dart';
import 'package:document_sharing_app/features/divisions/dialogs/add_division_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class DivisionScreen extends StatefulWidget {
  final String universityId;
  final String courseId;
  const DivisionScreen(
      {super.key, required this.universityId, required this.courseId});

  @override
  State<DivisionScreen> createState() => _DivisionScreenState();
}

class _DivisionScreenState extends State<DivisionScreen> {
  final DivisionController divisionController = Get.put(DivisionController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        divisionController.fetchCourseAndDivisions(
          widget.universityId,
          widget.courseId,
        );
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => divisionController.isLoading
          ? const GenLoader()
          : Scaffold(
              appBar: AppBar(
                title: Text("Divisions for ${divisionController.course.name}"),
              ),
              body: divisionController.divisions.isEmpty
                  ? Container()
                  : ListView.builder(
                      itemCount: divisionController.divisions.length,
                      itemBuilder: (context, index) {
                        final division = divisionController.divisions[index];
                        return ListTile(
                          onTap: () {
                            context.goNamed(
                              RouterConstants.subjectScreenRouteName,
                              pathParameters: {
                                "universityId": widget.universityId,
                                "courseId": widget.courseId,
                                "divisionId": division.divisionId,
                              },
                            );
                          },
                          trailing: const Icon(
                            CupertinoIcons.chevron_right,
                            size: 20,
                          ),
                          title: Text(division.name),
                        );
                      },
                    ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    builder: (_) => AddDivisionDialog(
                      divisionController: divisionController,
                      courseId: widget.courseId,
                      universityId: widget.universityId,
                    ),
                  );
                  divisionController.fetchDivisions(
                    widget.universityId,
                    widget.courseId,
                  );
                },
                child: const Icon(
                  CupertinoIcons.add,
                ),
              ),
            ),
    );
  }
}
