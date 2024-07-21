import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:document_sharing_app/features/university/data/models/university_model.dart';

class UserModel {
  final String name;
  final String email;
  final String? profile_image;
  final String uid;
  final String? university_email;
  final UniversityModel? current_university;
  final bool? isAdmin;
  UserModel({
    required this.name,
    required this.email,
    this.profile_image,
    required this.uid,
    this.university_email,
    this.current_university,
    this.isAdmin,
  });

  UserModel copyWith({
    String? name,
    String? email,
    ValueGetter<String?>? profile_image,
    String? uid,
    ValueGetter<String?>? university_email,
    ValueGetter<UniversityModel?>? current_university,
    ValueGetter<bool?>? isAdmin,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      profile_image:
          profile_image != null ? profile_image() : this.profile_image,
      uid: uid ?? this.uid,
      university_email:
          university_email != null ? university_email() : this.university_email,
      current_university: current_university != null
          ? current_university()
          : this.current_university,
      isAdmin: isAdmin != null ? isAdmin() : this.isAdmin,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profile_image': profile_image,
      'uid': uid,
      'university_email': university_email,
      'current_university': current_university?.toMap(),
      'isAdmin': isAdmin,
    };
  }

  static UserModel emptyObject() {
    return UserModel(
      name: "",
      email: "",
      uid: "",
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profile_image: map['profile_image'],
      uid: map['uid'] ?? '',
      university_email: map['university_email'],
      current_university: map['current_university'] != null
          ? UniversityModel.fromMap(map['current_university'])
          : null,
      isAdmin: map['isAdmin'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, profile_image: $profile_image, uid: $uid, university_email: $university_email, current_university: $current_university, isAdmin: $isAdmin)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.name == name &&
        other.email == email &&
        other.profile_image == profile_image &&
        other.uid == uid &&
        other.university_email == university_email &&
        other.current_university == current_university &&
        other.isAdmin == isAdmin;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        profile_image.hashCode ^
        uid.hashCode ^
        university_email.hashCode ^
        current_university.hashCode ^
        isAdmin.hashCode;
  }
}
