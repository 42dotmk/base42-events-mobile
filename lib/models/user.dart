import 'dart:convert';
import 'package:base42_events_mobile/models/media.dart';

List<User> usersFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

User getSingleUserFromJson(String str) => User.fromJson(json.decode(str));

class User {
  User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.provider,
    required this.confirmed,
    required this.blocked,
    required this.createdAt,
    required this.updatedAt,
    this.profilePicture,
  });

  int id;
  String username;
  String email;
  String firstName;
  String lastName;
  String provider;
  bool confirmed;
  bool blocked;
  DateTime createdAt;
  DateTime updatedAt;
  Media? profilePicture;

  String get name => firstName;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    firstName: (json["firstName"] ?? json["name"] ?? '').toString(),
    lastName: (json["lastName"] ?? json["surname"] ?? '').toString(),
    provider: json["provider"],
    confirmed: json["confirmed"],
    blocked: json["blocked"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    profilePicture: json["profilePicture"] != null
        ? Media.fromJson(json["profilePicture"])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    'provider': provider,
    'confirmed': confirmed,
    'blocked': blocked,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'profilePicture': profilePicture?.toJson(),
  };
}
