import 'dart:convert';
import 'dart:developer' as developer;
import 'package:base42_events_mobile/consts/api.dart';
import 'package:base42_events_mobile/types/user.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:base42_events_mobile/models/user.dart';
import 'package:base42_events_mobile/models/user_event.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

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

  Future<void> changeAttendanceStatus({
    required String token,
    required int eventId,
    required int? userId,
    required String status,
  }) async {
    if (userId == null) {
      throw Exception('User ID is required to change attendance status');
    }

    try {
      var url = Uri.parse(changeAttendanceStatusApiUrl);
      var response = await postWithAuth(url.toString(), token, {
        'userId': userId,
        'eventId': eventId,
        'attendanceStatus': status,
      });

      if (response.statusCode != 200 && response.statusCode != 201) {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData['error']?['message'] ??
            errorData['message'] ??
            'Unable to update your attendance status';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Error updating attendance status: $e');
    }
  }

  Future<List<UserEventResponse>> getUserEventsWithDetails(
    String token,
    int userId,
  ) async {
    try {
      var url = Uri.parse(userEventsApiUrl);
      var response = await getWithAuth(url.toString(), token);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<dynamic> responseData = data['data'] ?? [];

        return responseData.map((item) {
          return UserEventResponse(
            eventId: item['eventId'],
            status: item['attendanceStatus'],
          );
        }).toList();
      } else {
        var errorData = jsonDecode(response.body);
        String error =
            errorData['error']?['message'] ??
            'Failed to fetch user events (HTTP ${response.statusCode})';
        throw Exception(error);
      }
    } catch (e) {
      throw Exception('Failed to fetch user events: $e');
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

  Future<http.Response> putWithAuth(
    String url,
    String token,
    Map<String, dynamic> body,
  ) async {
    return await http.put(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );
  }

  Future<User> updateUserProfile({
    required String token,
    required int userId,
    required UpdateProfileBody changedFields,
    XFile? profileImage,
  }) async {
    try {
      String? uploadedImageId;
      if (profileImage != null) {
        try {
          uploadedImageId = await _uploadProfileImage(token, profileImage);
        } catch (e) {
          debugPrint('Warning: Profile image upload failed: $e');
        }
      }

      final url = Uri.parse(updateUserApiUrl);
      final body = <String, dynamic>{
        'userId': userId,
        ...changedFields.toJson(),
        if (uploadedImageId != null) 'profilePicture': uploadedImageId,
      };

      final response = await putWithAuth(url.toString(), token, body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        var errorData = jsonDecode(response.body);
        String error =
            errorData['error']?['message'] ?? 'Failed to update profile';
        throw Exception(error);
      }
    } catch (e) {
      debugPrint('Error updating user profile: $e');
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<String> _uploadProfileImage(String token, XFile image) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(uploadImageApiUrl));

      request.headers['Authorization'] = 'Bearer $token';

      final bytes = await image.readAsBytes();
      final multipartFile = http.MultipartFile.fromBytes(
        'files',
        bytes,
        filename: image.name,
        contentType: MediaType('image', image.name.split('.').last),
      );

      request.files.add(multipartFile);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data is List && data.isNotEmpty) {
          final firstItem = data[0];

          if (firstItem is Map && firstItem.containsKey('id')) {
            return firstItem['id'].toString();
          } else if (firstItem is String) {
            return firstItem;
          } else {
            throw Exception('Unexpected upload response format: $firstItem');
          }
        } else {
          throw Exception('Invalid upload response format');
        }
      } else {
        var errorData = jsonDecode(response.body);
        String error =
            errorData['error']?['message'] ?? 'Failed to upload image';
        throw Exception(error);
      }
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }
}
