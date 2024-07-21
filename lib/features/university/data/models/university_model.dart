import 'dart:convert';

class UniversityModel {
  final String name;
  final String name_lowerspace;
  final String id;
  final String city;
  final String state;
  final String country;
  UniversityModel({
    required this.name,
    required this.name_lowerspace,
    required this.id,
    required this.city,
    required this.state,
    required this.country,
  });

  UniversityModel copyWith({
    String? name,
    String? name_lowerspace,
    String? id,
    String? city,
    String? state,
    String? country,
  }) {
    return UniversityModel(
      name: name ?? this.name,
      name_lowerspace: name_lowerspace ?? this.name_lowerspace,
      id: id ?? this.id,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'name_lowerspace': name_lowerspace,
      'id': id,
      'city': city,
      'state': state,
      'country': country,
    };
  }

  factory UniversityModel.fromMap(Map<String, dynamic> map) {
    return UniversityModel(
      name: map['name'] ?? '',
      name_lowerspace: map['name_lowerspace'] ?? '',
      id: map['id'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      country: map['country'] ?? '',
    );
  }

  static UniversityModel emptyObject() {
    return UniversityModel(
      name: '',
      name_lowerspace: '',
      id: '',
      city: '',
      state: "",
      country: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UniversityModel.fromJson(String source) =>
      UniversityModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UniversityModel(name: $name, name_lowerspace: $name_lowerspace, id: $id, city: $city, state: $state, country: $country)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UniversityModel &&
        other.name == name &&
        other.name_lowerspace == name_lowerspace &&
        other.id == id &&
        other.city == city &&
        other.state == state &&
        other.country == country;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        name_lowerspace.hashCode ^
        id.hashCode ^
        city.hashCode ^
        state.hashCode ^
        country.hashCode;
  }
}
