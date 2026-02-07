import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../api/api.dart';
import '../core/api_client.dart';
import '../core/auth_storage.dart';

class AppServices {
  AppServices._(this.authStorage, this.apiClient)
      : authApi = AuthApi(apiClient),
        userApi = UserApi(apiClient),
        categoryApi = CategoryApi(apiClient),
        resourceApi = ResourceApi(apiClient),
        learningPathApi = LearningPathApi(apiClient),
        progressApi = ProgressApi(apiClient),
        readerApi = ReaderApi(apiClient),
        userFileApi = UserFileApi(apiClient),
        userImageApi = UserImageApi(apiClient);

  final AuthStorage authStorage;
  final ApiClient apiClient;

  final AuthApi authApi;
  final UserApi userApi;
  final CategoryApi categoryApi;
  final ResourceApi resourceApi;
  final LearningPathApi learningPathApi;
  final ProgressApi progressApi;
  final ReaderApi readerApi;
  final UserFileApi userFileApi;
  final UserImageApi userImageApi;

  static Future<AppServices> create({
    required String? Function() tokenProvider,
    required void Function() onUnauthorized,
  }) async {
    final secureStorage = const FlutterSecureStorage();
    final authStorage = AuthStorage(secureStorage);
    final client = ApiClient(tokenProvider: tokenProvider, onUnauthorized: onUnauthorized);
    return AppServices._(authStorage, client);
  }
}
