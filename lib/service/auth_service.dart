import 'package:photocopy/model/auth_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<AuthModel?> login(String email, String password) async {
    final user = {'email': email, 'password': password};
    const String ipDevice = "10.0.2.2";
    try {
      final headers = {'Content-Type': 'application/json'};
      final url = Uri.parse('http://${ipDevice}:3000/user/login');

      final response =
          await http.post(url, headers: headers, body: json.encode(user));
      final result = json.decode(response.body);
      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }
      if (result['status']) {
        final user = result['user']['user'];
        _saveAuthToken(AuthModel.fromJson(user));
        return AuthModel.fromJson(result);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> register(String email, String password, String fullName,
      String phoneNumber) async {
    final user = {
      'email': email,
      'password': password,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
    };
    const String ipDevice = "10.0.2.2";
    final headers = {'Content-Type': 'application/json'};
    final url = Uri.parse('http://${ipDevice}:3000/user/register');

    final response =
        await http.post(url, headers: headers, body: json.encode(user));
    final result = json.decode(response.body);

    if (response.statusCode != 200) {
      throw Exception(json.decode(response.body)['error']);
    }
    if (result['status']) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    const String ipDevice = "10.0.2.2";
    final headers = {'Content-Type': 'application/json'};
    final url = Uri.parse('http://${ipDevice}:3000/user/logout');

    final response = await http.get(url, headers: headers);
    if (response.statusCode != 200) {
      throw Exception(json.decode(response.body)['error']);
    }
    await clearSavedAuthToken();
  }

  Future<void> _saveAuthToken(AuthModel authModel) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', json.encode(authModel.toJson()));
  }

  Future<void> clearSavedAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
  }
}
