import 'dart:convert';

class DivisionModel {
  final String name;
  final String divisionId;
  final String dateCreated;
  DivisionModel({
    required this.name,
    required this.divisionId,
    required this.dateCreated,
  });

  DivisionModel copyWith({
    String? name,
    String? divisionId,
    String? dateCreated,
  }) {
    return DivisionModel(
      name: name ?? this.name,
      divisionId: divisionId ?? this.divisionId,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  static DivisionModel emptyObject() {
    return DivisionModel(
      name: "",
      divisionId: "",
      dateCreated: "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'divisionId': divisionId,
      'dateCreated': dateCreated,
    };
  }

  factory DivisionModel.fromMap(Map<String, dynamic> map) {
    return DivisionModel(
      name: map['name'] ?? '',
      divisionId: map['divisionId'] ?? '',
      dateCreated: map['dateCreated'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DivisionModel.fromJson(String source) =>
      DivisionModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'DivisionModel(name: $name, divisionId: $divisionId, dateCreated: $dateCreated)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DivisionModel &&
        other.name == name &&
        other.divisionId == divisionId &&
        other.dateCreated == dateCreated;
  }

  @override
  int get hashCode =>
      name.hashCode ^ divisionId.hashCode ^ dateCreated.hashCode;
}
