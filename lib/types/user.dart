import 'package:base42_events_mobile/models/user.dart';

class UserFieldConfig {
  final String key;
  final String label;
  final String originalValue;

  const UserFieldConfig({
    required this.key,
    required this.label,
    required this.originalValue,
  });
}

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

class UpdateProfileBody {
  final String? username;
  final String? firstName;
  final String? lastName;

  UpdateProfileBody({this.username, this.firstName, this.lastName});

  Map<String, dynamic> toJson() => {
    if (username != null) 'username': username,
    if (firstName != null) 'firstName': firstName,
    if (lastName != null) 'lastName': lastName,
  };
}

class OptionalProfilePicture<T> {
  final T? _value;
  final bool _isPresent;

  const OptionalProfilePicture.value(this._value) : _isPresent = true;
  const OptionalProfilePicture.absent() : _value = null, _isPresent = false;

  bool get isPresent => _isPresent;
  T? get value => _value;
}
