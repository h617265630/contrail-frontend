import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../app/token_holder.dart';
import '../app/services.dart';
import '../models/models.dart';

class AuthState extends ChangeNotifier {
  AuthState(this._services, this._tokenHolder);

  final AppServices _services;
  final TokenHolder _tokenHolder;

  String? _token;
  UserProfile? _user;
  bool _initializing = true;

  String? get token => _token;
  UserProfile? get user => _user;
  bool get isAuthed => _token != null && _token!.isNotEmpty;
  bool get initializing => _initializing;

  void _setToken(String? next) {
    _token = (next == null || next.isEmpty) ? null : next;
    _tokenHolder.token = _token;
    notifyListeners();
  }

  void _setUser(UserProfile? next) {
    _user = next;
    notifyListeners();
  }

  Future<void> initialize() async {
    _initializing = true;
    notifyListeners();

    final storedToken = await _services.authStorage.readToken();
    final storedUserJson = await _services.authStorage.readUserJson();

    if (storedToken != null && storedToken.isNotEmpty) {
      _token = storedToken;
      _tokenHolder.token = storedToken;
      if (storedUserJson != null && storedUserJson.isNotEmpty) {
        try {
          final map = jsonDecode(storedUserJson) as Map<String, dynamic>;
          _user = UserProfile.fromJson(map);
        } catch (_) {
          _user = null;
        }
      }

      try {
        final profile = await _services.userApi.getMe();
        _user = profile;
        await _services.authStorage.writeUserJson(jsonEncode(profile.toJson()));
      } catch (_) {
        await logout();
      }
    }

    _initializing = false;
    notifyListeners();
  }

  Future<void> login({required String username, required String password}) async {
    final token = await _services.authApi.login(username: username, password: password);
    _setToken(token);
    await _services.authStorage.writeToken(token);

    final profile = await _services.userApi.getMe();
    _setUser(profile);
    await _services.authStorage.writeUserJson(jsonEncode(profile.toJson()));
  }

  Future<void> register({required String username, required String email, required String password}) async {
    await _services.authApi.register(username: username, email: email, password: password);
  }

  Future<void> fetchProfile({bool force = false}) async {
    if (!isAuthed) {
      _setUser(null);
      return;
    }
    if (_user != null && !force) return;

    final profile = await _services.userApi.getMe();
    _setUser(profile);
    await _services.authStorage.writeUserJson(jsonEncode(profile.toJson()));
  }

  Future<void> updateProfile({String? displayName, String? avatarUrl, String? bio}) async {
    final profile = await _services.userApi.updateMe(displayName: displayName, avatarUrl: avatarUrl, bio: bio);
    _setUser(profile);
    await _services.authStorage.writeUserJson(jsonEncode(profile.toJson()));
  }

  Future<void> uploadAvatarAndSave(String filePath) async {
    final url = await _services.userApi.uploadAvatar(File(filePath));
    await updateProfile(avatarUrl: url);
  }

  Future<void> changePassword({required String currentPassword, required String newPassword}) async {
    await _services.userApi.changePassword(currentPassword: currentPassword, newPassword: newPassword);
  }

  Future<void> logout() async {
    _token = null;
    _tokenHolder.token = null;
    _user = null;
    await _services.authStorage.clear();
    notifyListeners();
  }

  void handleUnauthorized() {
    logout();
  }
}
