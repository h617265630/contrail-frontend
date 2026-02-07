import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'app_config.dart';

class AuthStorage {
  AuthStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _defaultOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  Future<String?> readToken() async {
    return _storage.read(key: AppConfig.tokenStorageKey, iOptions: _defaultOptions);
  }

  Future<void> writeToken(String? token) async {
    if (token == null || token.isEmpty) {
      await _storage.delete(key: AppConfig.tokenStorageKey, iOptions: _defaultOptions);
      return;
    }
    await _storage.write(key: AppConfig.tokenStorageKey, value: token, iOptions: _defaultOptions);
  }

  Future<String?> readUserJson() async {
    return _storage.read(key: AppConfig.userStorageKey, iOptions: _defaultOptions);
  }

  Future<void> writeUserJson(String? json) async {
    if (json == null || json.isEmpty) {
      await _storage.delete(key: AppConfig.userStorageKey, iOptions: _defaultOptions);
      return;
    }
    await _storage.write(key: AppConfig.userStorageKey, value: json, iOptions: _defaultOptions);
  }

  Future<void> clear() async {
    await writeToken(null);
    await writeUserJson(null);
  }
}
