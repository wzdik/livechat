// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String id;
  String idAuth;
  String firstName;
  String lastName;
  DateTime dateOfBirth;
  String role;
  String email;
  DateTime createdAt;
  int v;

  User({
    required this.id,
    required this.idAuth,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.role,
    required this.email,
    required this.createdAt,
    required this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        idAuth: json["id_auth"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        dateOfBirth: DateTime.parse(json["dateOfBirth"]),
        role: json["role"],
        email: json["email"],
        createdAt: DateTime.parse(json["createdAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "id_auth": idAuth,
        "firstName": firstName,
        "lastName": lastName,
        "dateOfBirth": dateOfBirth.toIso8601String(),
        "role": role,
        "email": email,
        "createdAt": createdAt.toIso8601String(),
        "__v": v,
      };
}
