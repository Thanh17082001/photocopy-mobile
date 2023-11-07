import 'package:flutter/material.dart';

import '../../service/auth_service.dart';
import '../../model/auth_model.dart';

class AuthManager with ChangeNotifier {
  AuthModel? _authModel;
  final AuthService _authService = AuthService();

  bool get isLogin {
    return _authModel != null;
  }

  AuthModel? get authModel {
    return _authModel;
  }

  void setAuthModel(AuthModel? auth) {
    _authModel = auth;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final response = await _authService.login(email, password);
    setAuthModel(response);
  }

  Future<bool> register(String email, String password, String fullName,
      String phoneNumber) async {
    final response =
        await _authService.register(email, password, fullName, phoneNumber);
    return response;
  }

  Future<void> logout() async {
    await _authService.logout();
    _authModel = null;
    notifyListeners();
  }
}
