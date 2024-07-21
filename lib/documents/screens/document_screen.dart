import 'package:document_sharing_app/core/widgets/helper_widgets.dart';
import 'package:document_sharing_app/documents/controller/document_controller.dart';
import 'package:document_sharing_app/documents/dialogs/add_document_dialog.dart';
import 'package:document_sharing_app/features/home/controller/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentScreen extends StatefulWidget {
  final String universityId;
  final String courseId;
  final String divisionId;
  final String subjectId;
  const DocumentScreen({
    super.key,
    required this.universityId,
    required this.courseId,
    required this.divisionId,
    required this.subjectId,
  });

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  final DocumentController documentController = Get.put(DocumentController());
  final HomeController homeController = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      documentController.fetchDocuments(
        widget.universityId,
        widget.courseId,
        widget.divisionId,
        widget.subjectId,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => documentController.isLoading
          ? const GenLoader()
          : Scaffold(
              appBar: AppBar(
                title: const Text("Documents"),
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  documentController.fetchDocuments(
                    widget.universityId,
                    widget.courseId,
                    widget.divisionId,
                    widget.subjectId,
                  );
                },
                child: documentController.documents.isEmpty
                    ? Container()
                    : ListView.builder(
                        itemCount: documentController.documents.length,
                        itemBuilder: (context, index) {
                          final doc = documentController.documents[index];
                          return Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  _launchUrl(doc.fileDownloadUrl);
                                },
                                leading: Container(
                                  width: 40,
                                  child: Center(
                                    child: Icon(
                                      CupertinoIcons.doc_append,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                trailing: const Icon(
                                  CupertinoIcons.down_arrow,
                                  size: 20,
                                ),
                                title: Text(
                                  doc.name,
                                ),
                                subtitle: Text(doc.description),
                              ),
                              const Divider(),
                            ],
                          );
                        },
                      ),
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
                    builder: (_) => AddDocumentDialog(
                      documentController: documentController,
                      homeController: homeController,
                      divisionId: widget.divisionId,
                      courseId: widget.courseId,
                      subjectId: widget.subjectId,
                      universityId: widget.universityId,
                    ),
                  );
                  documentController.fetchDocuments(
                    widget.universityId,
                    widget.courseId,
                    widget.divisionId,
                    widget.subjectId,
                  );
                },
                child: const Icon(
                  CupertinoIcons.add,
                ),
              ),
            ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
