import 'package:document_sharing_app/features/subjects/controller/subject_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class AddSubjectDialog extends StatefulWidget {
  final String universityId;
  final String courseId;
  final String divisionId;
  final SubjectController subjectController;
  const AddSubjectDialog(
      {super.key,
      required this.subjectController,
      required this.courseId,
      required this.universityId,
      required this.divisionId});

  @override
  State<AddSubjectDialog> createState() => _AddSubjectDialogState();
}

class _AddSubjectDialogState extends State<AddSubjectDialog> {
  final nameController = TextEditingController();
  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 24,
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  12,
                ),
                topRight: Radius.circular(
                  12,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Add Subject",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          context.pop();
                        },
                        child: Text(
                          "Close",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Add the subject that you want to add to this division.",
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: "Eg. Mathematics I",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                widget.subjectController.isDialogLoading
                    ? ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.tertiary.withOpacity(
                                  0.5,
                                ),
                          ),
                        ),
                        onPressed: () async {},
                        child: const Text(
                          "Add",
                        ),
                      )
                    : ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Theme.of(context).colorScheme.tertiary)),
                        onPressed: () async {
                          widget.subjectController.createSubject(
                              context,
                              nameController.text,
                              widget.universityId,
                              widget.courseId,
                              widget.divisionId);
                        },
                        child: const Text(
                          "Add",
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
