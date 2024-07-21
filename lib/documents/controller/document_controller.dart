import 'dart:io';
import 'package:document_sharing_app/documents/data/model/document_model.dart';
import 'package:document_sharing_app/documents/data/repository/documents_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class DocumentController extends GetxController {
  // Injected repository for data access
  final DocumentsRepository _documentsRepository =
      Get.put<DocumentsRepository>(DocumentsRepository());

  // Observables for UI state
  RxList<DocumentModel> _documents = <DocumentModel>[].obs;
  Rx<File?> _selectedFile = Rx<File?>(null);
  RxBool _isDialogLoading = false.obs;
  RxBool _isLoading = false.obs;

  // Getters for easy access to reactive variables
  List<DocumentModel> get documents => _documents;
  File? get selectedFile => _selectedFile.value;
  bool get isDialogLoading => _isDialogLoading.value;
  bool get isLoading => _isLoading.value;

  /// Creates a new document with the given details and uploads it to the repository.
  void createDocument(
      BuildContext context,
      String universityName,
      String name,
      String description,
      String universityId,
      String courseId,
      String divisionId,
      String subjectId) async {
    // Validate input
    if (name.isNotEmpty &&
        description.isNotEmpty &&
        selectedFile != null &&
        selectedFile != File("")) {
      _isDialogLoading.value = true;

      // Upload file and get download URL
      final uploadResult = await _documentsRepository.uploadFileAndGetUrl(
          selectedFile!, universityName);

      uploadResult.fold((l) {
        print('Error uploading file: $l'); // Handle upload error
      }, (downloadUrl) async {
        final documentId = const Uuid().v4();
        final dateCreated = DateTime.now().millisecondsSinceEpoch.toString();

        final document = DocumentModel(
            name: name,
            description: description,
            documentId: documentId,
            fileDownloadUrl: downloadUrl,
            createdAt: dateCreated);

        // Add document to Firestore
        final addResult = await _documentsRepository.createDocument(
          document,
          universityId,
          courseId,
          divisionId,
          subjectId,
        );
        addResult.fold((l) {
          print('Error adding document: $l'); // Handle add error
        }, (_) {
          _documents.add(document); // Update local document list
          context.pop(); // Close the dialog
          _resetFields(); // Reset form fields
          _isDialogLoading.value = false;
        });
      });
    } else {
      // Handle validation errors (show message to user)
      print("Form fields and file selection are required");
    }
  }

  /// Fetches documents for a given subject and updates the list.
  void fetchDocuments(String universityId, String courseId, String divisionId,
      String subjectId) async {
    _isLoading.value = true;
    _resetFields();

    final fetchResult = await _documentsRepository.fetchDocuments(
        universityId, courseId, divisionId, subjectId);

    fetchResult.fold(
      (l) {
        print('Error fetching documents: $l'); // Handle fetch error
      },
      (documents) {
        _documents.value = documents;
        _isLoading.value = false;
      },
    );
  }

  /// Resets the controller's state.
  void _resetFields() {
    _selectedFile.value = null;
    _documents.value = [];
  }

  void updateSelectedFile(File file) {
    _selectedFile.value = file;
  }
}
