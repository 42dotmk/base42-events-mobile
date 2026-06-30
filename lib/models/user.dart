import 'dart:convert';
import 'package:base42_events_mobile/models/media.dart';
import 'package:base42_events_mobile/models/membership.dart';

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
    this.userType = 'user',
    this.stripeCustomerId,
    this.memberships = const [],
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
  String userType;
  String? stripeCustomerId;
  List<Membership> memberships;

  String get name => firstName;

  bool get isVolunteer => userType == 'volunteer';
  bool get isMember => userType == 'member';

  Membership? get activeMembership {
    try {
      return memberships.firstWhere((m) => m.isActive);
    } catch (_) {
      return null;
    }
  }

  factory User.fromJson(Map<String, dynamic> json) {
    List<Membership> parseMemberships(dynamic data) {
      if (data is List) {
        return data.map((m) => Membership.fromJson(m as Map<String, dynamic>)).toList();
      }
      return [];
    }

    return User(
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
      userType: json["userType"] as String? ?? 'user',
      stripeCustomerId: json["stripeCustomerId"] as String?,
      memberships: parseMemberships(json["memberships"]),
    );
  }

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
    'userType': userType,
    'stripeCustomerId': stripeCustomerId,
    'memberships': memberships.map((m) => m.toJson()).toList(),
  };
}
