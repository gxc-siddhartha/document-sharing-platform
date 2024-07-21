import 'package:document_sharing_app/features/divisions/controller/division_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class AddDivisionDialog extends StatefulWidget {
  final String universityId;
  final String courseId;
  final DivisionController divisionController;
  const AddDivisionDialog({
    super.key,
    required this.divisionController,
    required this.courseId,
    required this.universityId,
  });

  @override
  State<AddDivisionDialog> createState() => _AddDivisionDialogState();
}

class _AddDivisionDialogState extends State<AddDivisionDialog> {
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
                      "Add Division",
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
                  "Add the name of the division that you want to add to this course.",
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: "Eg. Year 1",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                widget.divisionController.isAddingDivision
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
                          widget.divisionController.createDivisionForCourse(
                            context,
                            nameController.text,
                            widget.universityId,
                            widget.courseId,
                          );
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
