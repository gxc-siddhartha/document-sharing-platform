import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:document_sharing_app/features/initial/data/models/user_model.dart';

class CourseModel {
  final String name;
  final String name_lowerspace;
  final String uid;
  final String dateCreated;
  final String createdBy;
  final UserModel? details;
  CourseModel({
    required this.name,
    required this.name_lowerspace,
    required this.uid,
    required this.dateCreated,
    required this.createdBy,
    this.details,
  });

  CourseModel copyWith({
    String? name,
    String? name_lowerspace,
    String? uid,
    String? dateCreated,
    String? createdBy,
    ValueGetter<UserModel?>? details,
  }) {
    return CourseModel(
      name: name ?? this.name,
      name_lowerspace: name_lowerspace ?? this.name_lowerspace,
      uid: uid ?? this.uid,
      dateCreated: dateCreated ?? this.dateCreated,
      createdBy: createdBy ?? this.createdBy,
      details: details != null ? details() : this.details,
    );
  }

  static CourseModel emptyObject() {
    return CourseModel(
        name: "", name_lowerspace: "", uid: "", dateCreated: "", createdBy: "");
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'name_lowerspace': name_lowerspace,
      'uid': uid,
      'dateCreated': dateCreated,
      'createdBy': createdBy,
      'details': details?.toMap(),
    };
  }

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      name: map['name'] ?? '',
      name_lowerspace: map['name_lowerspace'] ?? '',
      uid: map['uid'] ?? '',
      dateCreated: map['dateCreated'] ?? '',
      createdBy: map['createdBy'] ?? '',
      details:
          map['details'] != null ? UserModel.fromMap(map['details']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CourseModel.fromJson(String source) =>
      CourseModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CourseModel(name: $name, name_lowerspace: $name_lowerspace, uid: $uid, dateCreated: $dateCreated, createdBy: $createdBy, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CourseModel &&
        other.name == name &&
        other.name_lowerspace == name_lowerspace &&
        other.uid == uid &&
        other.dateCreated == dateCreated &&
        other.createdBy == createdBy &&
        other.details == details;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        name_lowerspace.hashCode ^
        uid.hashCode ^
        dateCreated.hashCode ^
        createdBy.hashCode ^
        details.hashCode;
  }
}
