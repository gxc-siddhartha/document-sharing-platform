import 'dart:convert';

class DocumentModel {
  final String name;
  final String description;
  final String documentId;
  final String fileDownloadUrl;
  final String createdAt;
  DocumentModel({
    required this.name,
    required this.description,
    required this.documentId,
    required this.fileDownloadUrl,
    required this.createdAt,
  });

  DocumentModel copyWith({
    String? name,
    String? description,
    String? documentId,
    String? fileDownloadUrl,
    String? createdAt,
  }) {
    return DocumentModel(
      name: name ?? this.name,
      description: description ?? this.description,
      documentId: documentId ?? this.documentId,
      fileDownloadUrl: fileDownloadUrl ?? this.fileDownloadUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'documentId': documentId,
      'fileDownloadUrl': fileDownloadUrl,
      'createdAt': createdAt,
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      documentId: map['documentId'] ?? '',
      fileDownloadUrl: map['fileDownloadUrl'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentModel.fromJson(String source) =>
      DocumentModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DocumentModel(name: $name, description: $description, documentId: $documentId, fileDownloadUrl: $fileDownloadUrl, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DocumentModel &&
        other.name == name &&
        other.description == description &&
        other.documentId == documentId &&
        other.fileDownloadUrl == fileDownloadUrl &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        description.hashCode ^
        documentId.hashCode ^
        fileDownloadUrl.hashCode ^
        createdAt.hashCode;
  }
}
