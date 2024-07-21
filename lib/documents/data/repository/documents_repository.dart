import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:document_sharing_app/core/typedefs/typedefs.dart';
import 'package:document_sharing_app/documents/data/model/document_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class DocumentsRepository {
  // Use dependency injection (could also be done via constructor)
  final FirebaseStorage _storage =
      Get.put<FirebaseStorage>(FirebaseStorage.instance);
  final FirebaseFirestore _firestore = Get.find<FirebaseFirestore>();

  /// Uploads a file to Firebase Storage and returns its download URL.
  ///
  /// Takes a `File` object and the `universityName` as parameters. Returns a `FutureEither`
  /// containing either the download URL as a string or an error message if an exception occurs.
  FutureEither<String> uploadFileAndGetUrl(
    File file,
    String universityName,
  ) async {
    try {
      final fileName = const Uuid().v4();
      final storageRef =
          _storage.ref().child("files").child(universityName).child(fileName);

      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return right(downloadUrl);
    } catch (e) {
      // Log the error for better debugging
      print('Error uploading file: $e');
      return left(e.toString());
    }
  }

  /// Adds a document to a specific subject in Firestore.
  ///
  /// Takes a `DocumentModel`, along with university, course, division, and subject IDs.
  /// Returns a `FutureEither` with a null value on success or an error message if an exception
  /// occurs.
  FutureEither<void> createDocument(
    DocumentModel document,
    String universityId,
    String courseId,
    String divisionId,
    String subjectId,
  ) async {
    try {
      final documentsCollection = _firestore
          .collection("university")
          .doc(universityId)
          .collection('courses')
          .doc(courseId)
          .collection('divisions')
          .doc(divisionId)
          .collection('subjects')
          .doc(subjectId)
          .collection('documents');

      await documentsCollection.doc(document.documentId).set(document.toMap());

      return right(null);
    } catch (e) {
      // Log the error for better debugging
      print('Error adding document: $e');
      return left(e.toString());
    }
  }

  /// Fetches all documents associated with a subject from Firestore.
  ///
  /// Returns a `FutureEither` with either a list of `DocumentModel` objects or an error
  /// message if an exception occurs.
  FutureEither<List<DocumentModel>> fetchDocuments(
    String universityId,
    String courseId,
    String divisionId,
    String subjectId,
  ) async {
    try {
      final documentsSnapshot = await _firestore
          .collection("university")
          .doc(universityId)
          .collection('courses')
          .doc(courseId)
          .collection('divisions')
          .doc(divisionId)
          .collection('subjects')
          .doc(subjectId)
          .collection('documents')
          .get();

      final documents = documentsSnapshot.docs
          .map((doc) =>
              DocumentModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      return right(documents);
    } catch (e) {
      // Log the error for better debugging
      print('Error fetching documents: $e');
      return left(e.toString());
    }
  }
}
