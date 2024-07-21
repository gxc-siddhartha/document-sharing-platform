import 'dart:convert';

class SubjectModel {
  final String name;
  final String subjectId;
  final String createdDate;
  SubjectModel({
    required this.name,
    required this.subjectId,
    required this.createdDate,
  });

  static SubjectModel emptyObject() {
    return SubjectModel(
      name: "",
      subjectId: "",
      createdDate: "",
    );
  }

  SubjectModel copyWith({
    String? name,
    String? subjectId,
    String? createdDate,
  }) {
    return SubjectModel(
      name: name ?? this.name,
      subjectId: subjectId ?? this.subjectId,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'subjectId': subjectId,
      'createdDate': createdDate,
    };
  }

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      name: map['name'] ?? '',
      subjectId: map['subjectId'] ?? '',
      createdDate: map['createdDate'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SubjectModel.fromJson(String source) =>
      SubjectModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'SubjectModel(name: $name, subjectId: $subjectId, createdDate: $createdDate)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubjectModel &&
        other.name == name &&
        other.subjectId == subjectId &&
        other.createdDate == createdDate;
  }

  @override
  int get hashCode => name.hashCode ^ subjectId.hashCode ^ createdDate.hashCode;
}
