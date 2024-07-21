import 'dart:io';

import 'package:document_sharing_app/documents/controller/document_controller.dart';
import 'package:document_sharing_app/features/home/controller/home_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class AddDocumentDialog extends StatefulWidget {
  final String universityId;

  final String courseId;
  final String divisionId;
  final String subjectId;
  final DocumentController documentController;
  final HomeController homeController;
  const AddDocumentDialog({
    super.key,
    required this.documentController,
    required this.homeController,
    required this.universityId,
    required this.courseId,
    required this.divisionId,
    required this.subjectId,
  });

  @override
  State<AddDocumentDialog> createState() => _AddDocumentDialogState();
}

class _AddDocumentDialogState extends State<AddDocumentDialog> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowCompression: true,
      compressionQuality: 30,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc', 'png'],
    );

    List<File> files = result!.paths.map((path) => File(path!)).toList();
    widget.documentController.updateSelectedFile(files[0]);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Add Document",
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
                    "Select and add the details for the file that has to be added."),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        pickFile();
                      },
                      child: Container(
                        height: 135,
                        width: 130,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(
                            12,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.doc,
                              size: 25,
                              color: Theme.of(context)
                                  .colorScheme
                                  .background
                                  .withOpacity(
                                    0.6,
                                  ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Add File",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context)
                                    .colorScheme
                                    .background
                                    .withOpacity(
                                      0.8,
                                    ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              hintText: "Name",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: descriptionController,
                            decoration: const InputDecoration(
                              hintText: "Description",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: widget.documentController.isDialogLoading
                      ? null
                      : () async {
                          widget.documentController.createDocument(
                            context,
                            widget.homeController.activeUser!
                                .current_university!.name,
                            nameController.text,
                            descriptionController.text,
                            widget.universityId,
                            widget.courseId,
                            widget.divisionId,
                            widget.subjectId,
                          );
                        },
                  child: Text(
                    widget.documentController.isDialogLoading
                        ? "Please wait, uploading.."
                        : "Submit",
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
