import 'dart:convert';
import 'dart:developer' as developer;
import 'package:base42_events_mobile/consts/api.dart';
import 'package:base42_events_mobile/types.dart';
import 'package:http/http.dart' as http;
import 'package:base42_events_mobile/models/user.dart';

class UserService {
  Future<List<User>> getUsersData() async {
    try {
      var url = Uri.parse(usersApiUrl);

      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<User> model = usersFromJson(response.body);
        return model;
      } else {
        String error = jsonDecode(response.body)['error']['message'];
        throw Exception(error);
      }
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
  }

  Future<AuthResponse> loginWithKeycloak(String keycloakAccessToken) async {
    final url = Uri.parse(
      '$exchangeKeycloakTokenApiUrl?code=$keycloakAccessToken',
    );

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = User.fromJson(data['user']);
      return AuthResponse(
        user: user,
        jwt: data['jwt'],
        expiresIn: data['expiresIn'],
      );
    } else {
      String error;
      try {
        final errorData = jsonDecode(response.body);
        error = errorData['error']?['message'] ?? 'Keycloak login failed';
      } catch (_) {
        error =
            'Keycloak login failed (HTTP ${response.statusCode}, ${response.reasonPhrase}, response body: ${response.body})';
      }
      throw Exception(error);
    }
  }

  Future<void> logout(String token) async {
    try {
      var url = Uri.parse(logoutUserApiUrl);

      var response = await postWithAuth(url.toString(), token, {});

      if (response.statusCode != 200 && response.statusCode != 403) {
        var errorData = jsonDecode(response.body);
        String error = errorData['error']?['message'] ?? 'Logout failed';
        developer.log('Logout API warning: $error', name: 'UserService');
      }
    } catch (e) {
      developer.log(
        'Logout API call failed (non-critical): $e',
        name: 'UserService',
        error: e,
      );
    }
  }

  Future<User> getCurrentAuthenticatedUser(String token) async {
    try {
      var url = Uri.parse(currentAuthenticatedUserApiUrl);

      var response = await getWithAuth(url.toString(), token);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        var errorData = jsonDecode(response.body);
        String error =
            errorData['error']?['message'] ??
            'Failed to fetch current authenticated user';
        throw Exception(error);
      }
    } catch (e) {
      throw Exception('Failed to fetch current authenticated user: $e');
    }
  }

  Future<http.Response> getWithAuth(String url, String token) async {
    return await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
  }

  Future<http.Response> postWithAuth(
    String url,
    String token,
    Map<String, dynamic> body,
  ) async {
    return await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );
  }

  Future<void> updateFcmToken(String token, String fcmToken) async {
    try {
      var url = Uri.parse(addFcmTokenApiUrl);

      var response = await postWithAuth(
        url.toString(),
        token,
        {'fcmToken': fcmToken},
      );

      if (response.statusCode == 200) {
        developer.log('FCM token updated successfully', name: 'UserService');
      } else {
        String error;
        try {
          var errorData = jsonDecode(response.body);
          error = errorData['error']?['message'] ?? 'Failed to update FCM token';
        } catch (_) {
          error = 'Failed to update FCM token (HTTP ${response.statusCode})';
        }
        developer.log(
          'Failed to update FCM token: $error (Status: ${response.statusCode})',
          name: 'UserService',
        );
        throw Exception(error);
      }
    } catch (e) {
      developer.log(
        'Error updating FCM token: $e',
        name: 'UserService',
        error: e,
      );
      rethrow;
    }
  }
}
