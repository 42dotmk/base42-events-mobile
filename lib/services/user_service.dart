import 'dart:convert';
import 'package:base42_events_mobile/consts/api.dart';
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

  Future<User?> addUser(String email, String username, String password) async {
    try {
      var url = Uri.parse(registerUserApiUrl);

      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        User model = User.fromJson(data['user']);
        return model;
      } else {
        var errorData = jsonDecode(response.body);
        String error = errorData['error']?['message'] ?? 'Registration failed';
        throw Exception(error);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<User?> loginUser(String email, String password) async {
    try {
      var url = Uri.parse(loginUserApiUrl);

      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"identifier": email, "password": password}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        User model = User.fromJson(data['user']);
        return model;
      } else {
        var errorData = jsonDecode(response.body);
        String error = errorData['error']?['message'] ?? 'Login failed';
        throw Exception(error);
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}
