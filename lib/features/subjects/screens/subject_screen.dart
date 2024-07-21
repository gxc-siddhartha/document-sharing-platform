import 'package:document_sharing_app/core/router/router_service.dart';
import 'package:document_sharing_app/core/widgets/helper_widgets.dart';
import 'package:document_sharing_app/features/subjects/controller/subject_controller.dart';
import 'package:document_sharing_app/features/subjects/dialogs/add_subject_dailog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class SubjectScreen extends StatefulWidget {
  final String universityId;
  final String courseId;
  final String divisionId;
  const SubjectScreen({
    super.key,
    required this.universityId,
    required this.courseId,
    required this.divisionId,
  });

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  final SubjectController subjectController = Get.put(SubjectController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      subjectController.fetchSubjects(
          context, widget.universityId, widget.courseId, widget.divisionId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => subjectController.isLoading
          ? const GenLoader()
          : Scaffold(
              appBar: AppBar(
                title: const Text("Subjects"),
              ),
              body: subjectController.subjects.isEmpty
                  ? null
                  : ListView.builder(
                      itemCount: subjectController.subjects.length,
                      itemBuilder: (context, index) {
                        final subject = subjectController.subjects[index];
                        return ListTile(
                          onTap: () {
                            context.goNamed(
                                RouterConstants.documentScreenRouteName,
                                pathParameters: {
                                  'universityId': widget.universityId,
                                  "courseId": widget.courseId,
                                  "divisionId": widget.divisionId,
                                  "subjectId": subject.subjectId,
                                });
                          },
                          title: Text(subject.name),
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
                    builder: (_) => AddSubjectDialog(
                      subjectController: subjectController,
                      courseId: widget.courseId,
                      universityId: widget.universityId,
                      divisionId: widget.divisionId,
                    ),
                  );
                  if (context.mounted) {
                    subjectController.fetchSubjects(
                      context,
                      widget.universityId,
                      widget.courseId,
                      widget.divisionId,
                    );
                  }
                },
                child: Icon(CupertinoIcons.add),
              ),
            ),
    );
  }
}
