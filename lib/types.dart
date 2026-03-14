import 'package:base42_events_mobile/models/user.dart';

// Strapi returns { user: User, jwt: String, expiresIn?: int }
class AuthResponse {
  final User user;
  final String jwt;
  final int? expiresIn;

  AuthResponse({required this.user, required this.jwt, this.expiresIn});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: User.fromJson(json['user']),
      jwt: json['jwt'],
      expiresIn: json['expiresIn'],
    );
  }
}
