import 'dart:io';

import 'package:dio/dio.dart';

import '../core/api_client.dart';
import '../models/models.dart';

class AuthApi {
  AuthApi(this._client);
  final ApiClient _client;

  Future<String> login({required String username, required String password}) async {
    final res = await _client.postJson<Map<String, dynamic>>(
      '/users/login',
      data: {
        'username': username,
        'password': password,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
      decoder: (data) => Map<String, dynamic>.from(data as Map),
    );
    final token = (res['access_token'] ?? '').toString();
    if (token.isEmpty) {
      throw ApiException(message: 'Login response did not include access_token');
    }
    return token;
  }

  Future<void> register({required String username, required String email, required String password}) async {
    await _client.postJson<Map<String, dynamic>>(
      '/users/register',
      data: {
        'username': username,
        'email': email,
        'password': password,
      },
      decoder: (data) => Map<String, dynamic>.from(data as Map),
    );
  }
}

class UserApi {
  UserApi(this._client);
  final ApiClient _client;

  Future<UserProfile> getMe() async {
    return _client.getJson<UserProfile>(
      '/users/me',
      decoder: (data) => UserProfile.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }

  Future<UserProfile> updateMe({String? displayName, String? avatarUrl, String? bio}) async {
    return _client.patchJson<UserProfile>(
      '/users/me',
      data: {
        ...?(displayName == null ? null : {'display_name': displayName}),
        ...?(avatarUrl == null ? null : {'avatar_url': avatarUrl}),
        ...?(bio == null ? null : {'bio': bio}),
      },
      decoder: (data) => UserProfile.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }

  Future<String> uploadAvatar(File file) async {
    final fd = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: file.uri.pathSegments.last),
    });

    final res = await _client.postJson<Map<String, dynamic>>(
      '/users/me/avatar',
      data: fd,
      decoder: (data) => Map<String, dynamic>.from(data as Map),
    );

    return (res['avatar_url'] ?? '').toString();
  }

  Future<void> changePassword({required String currentPassword, required String newPassword}) async {
    await _client.postJson<dynamic>(
      '/users/me/password',
      data: {
        'current_password': currentPassword,
        'new_password': newPassword,
      },
    );
  }
}

class CategoryApi {
  CategoryApi(this._client);
  final ApiClient _client;

  Future<List<Category>> list() async {
    return _client.getJson<List<Category>>(
      '/categories/',
      decoder: (data) {
        final arr = (data as List?) ?? const [];
        return arr
            .whereType<Map>()
            .map((e) => Category.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      },
    );
  }

  Future<Category> create({required String name, String? code, String? description}) async {
    return _client.postJson<Category>(
      '/categories/',
      data: {
        'name': name,
        ...?(code == null ? null : {'code': code}),
        ...?(description == null ? null : {'description': description}),
      },
      decoder: (data) => Category.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }
}

class ResourceApi {
  ResourceApi(this._client);
  final ApiClient _client;

  Future<UrlExtractResponse> extract(String url) async {
    return _client.postJson<UrlExtractResponse>(
      '/resources/extract',
      data: {'url': url},
      decoder: (data) => UrlExtractResponse.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }

  Future<List<DbResource>> listPublic() async {
    return _client.getJson<List<DbResource>>(
      '/resources',
      decoder: (data) {
        final arr = (data as List?) ?? const [];
        return arr
            .whereType<Map>()
            .map((e) => DbResource.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      },
    );
  }

  Future<List<DbResource>> listMine() async {
    return _client.getJson<List<DbResource>>(
      '/resources/me',
      decoder: (data) {
        final arr = (data as List?) ?? const [];
        return arr
            .whereType<Map>()
            .map((e) => DbResource.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      },
    );
  }

  Future<DbResource> createMineFromUrl({required String url, int? categoryId, bool? isPublic, double? manualWeight}) async {
    return _client.postJson<DbResource>(
      '/resources/me',
      data: {
        'url': url,
        ...?(categoryId == null ? null : {'category_id': categoryId}),
        ...?(isPublic == null ? null : {'is_public': isPublic}),
        ...?(manualWeight == null ? null : {'manual_weight': manualWeight}),
      },
      decoder: (data) => DbResource.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }

  Future<Map<String, dynamic>> attachPublicToMe({required int resourceId, double? manualWeight}) async {
    return _client.postJson<Map<String, dynamic>>(
      '/resources/me/$resourceId/attach',
      data: {
        ...?(manualWeight == null ? null : {'manual_weight': manualWeight}),
      },
      decoder: (data) => Map<String, dynamic>.from(data as Map),
    );
  }

  Future<void> deleteMine(int resourceId) async {
    await _client.deleteVoid('/resources/me/$resourceId');
  }

  Future<void> deletePublic(int resourceId) async {
    await _client.deleteVoid('/resources/$resourceId');
  }

  Future<DbResource> updateMine(int resourceId, Map<String, dynamic> payload) async {
    return _client.patchJson<DbResource>(
      '/resources/me/$resourceId',
      data: payload,
      decoder: (data) => DbResource.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }

  Future<DbResourceDetail> detailMine(int resourceId) async {
    return _client.getJson<DbResourceDetail>(
      '/resources/me/$resourceId',
      decoder: (data) => DbResourceDetail.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }

  Future<DbResourceDetail> detailPublic(int resourceId) async {
    return _client.getJson<DbResourceDetail>(
      '/resources/$resourceId',
      decoder: (data) => DbResourceDetail.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }
}

class LearningPathApi {
  LearningPathApi(this._client);
  final ApiClient _client;

  Future<List<PublicLearningPath>> listPublic() async {
    return _client.getJson<List<PublicLearningPath>>(
      '/learning-paths/public',
      decoder: (data) {
        final arr = (data as List?) ?? const [];
        return arr
            .whereType<Map>()
            .map((e) => PublicLearningPath.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      },
    );
  }

  Future<PublicLearningPathDetail> publicDetail(int id) async {
    return _client.getJson<PublicLearningPathDetail>(
      '/learning-paths/public/$id',
      decoder: (data) => PublicLearningPathDetail.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }

  Future<List<PublicLearningPath>> listMine() async {
    return _client.getJson<List<PublicLearningPath>>(
      '/learning-paths/',
      decoder: (data) {
        final arr = (data as List?) ?? const [];
        return arr
            .whereType<Map>()
            .map((e) => PublicLearningPath.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      },
    );
  }

  Future<PublicLearningPathDetail> mineDetail(int id) async {
    return _client.getJson<PublicLearningPathDetail>(
      '/learning-paths/$id',
      decoder: (data) => PublicLearningPathDetail.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }

  Future<PublicLearningPath> create({
    required String title,
    String? type,
    String? description,
    required bool isPublic,
    String? coverImageUrl,
    int? categoryId,
  }) async {
    return _client.postJson<PublicLearningPath>(
      '/learning-paths/',
      data: {
        'title': title,
        ...?(type == null ? null : {'type': type}),
        ...?(description == null ? null : {'description': description}),
        'is_public': isPublic,
        ...?(coverImageUrl == null ? null : {'cover_image_url': coverImageUrl}),
        ...?(categoryId == null ? null : {'category_id': categoryId}),
      },
      decoder: (data) => PublicLearningPath.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }

  Future<PublicLearningPath> update(int id, Map<String, dynamic> payload) async {
    return _client.patchJson<PublicLearningPath>(
      '/learning-paths/$id',
      data: payload,
      decoder: (data) => PublicLearningPath.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }

  Future<Map<String, dynamic>> attachPublicToMe(int id) async {
    return _client.postJson<Map<String, dynamic>>(
      '/learning-paths/me/$id/attach',
      data: {},
      decoder: (data) => Map<String, dynamic>.from(data as Map),
    );
  }

  Future<void> deleteMine(int id) async {
    await _client.deleteVoid('/learning-paths/$id');
  }

  Future<void> addItem(int learningPathId, Map<String, dynamic> payload) async {
    await _client.postJson<dynamic>('/learning-paths/$learningPathId/items', data: payload);
  }

  Future<void> removeItem(int learningPathId, int resourceId) async {
    await _client.deleteVoid('/learning-paths/$learningPathId/items/$resourceId');
  }

  Future<List<LearningPathComment>> listComments(int learningPathId) async {
    return _client.getJson<List<LearningPathComment>>(
      '/learning-paths/$learningPathId/comments',
      decoder: (data) {
        final arr = (data as List?) ?? const [];
        return arr
            .whereType<Map>()
            .map((e) => LearningPathComment.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      },
    );
  }

  Future<LearningPathComment> postComment(int learningPathId, String content) async {
    return _client.postJson<LearningPathComment>(
      '/learning-paths/$learningPathId/comments',
      data: {'content': content},
      decoder: (data) => LearningPathComment.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }
}

class ProgressApi {
  ProgressApi(this._client);
  final ApiClient _client;

  Future<List<ProgressRow>> listMineForPath(int learningPathId) async {
    return _client.getJson<List<ProgressRow>>(
      '/progress/me',
      queryParameters: {'learning_path_id': learningPathId},
      decoder: (data) {
        final arr = (data as List?) ?? const [];
        return arr
            .whereType<Map>()
            .map((e) => ProgressRow.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      },
    );
  }

  Future<ProgressRow> getMineForItem(int pathItemId) async {
    return _client.getJson<ProgressRow>(
      '/progress/me/item/$pathItemId',
      decoder: (data) => ProgressRow.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }

  Future<ProgressRow> upsertMine({required int pathItemId, required int progressPercentage}) async {
    return _client.putJson<ProgressRow>(
      '/progress/me',
      data: {
        'path_item_id': pathItemId,
        'progress_percentage': progressPercentage,
      },
      decoder: (data) => ProgressRow.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }
}

class ReaderApi {
  ReaderApi(this._client);
  final ApiClient _client;

  Future<ReaderExtractResponse> extract(String url) async {
    return _client.postJson<ReaderExtractResponse>(
      '/reader/extract',
      data: {'url': url},
      decoder: (data) => ReaderExtractResponse.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }
}

class UserFileApi {
  UserFileApi(this._client);
  final ApiClient _client;

  Future<List<UserFile>> listMine() async {
    return _client.getJson<List<UserFile>>(
      '/user-files/me',
      decoder: (data) {
        final arr = (data as List?) ?? const [];
        return arr
            .whereType<Map>()
            .map((e) => UserFile.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      },
    );
  }

  Future<UserFile> uploadMine({required File file, String? title}) async {
    final fd = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: file.uri.pathSegments.last),
      ...?(title == null ? null : {'title': title}),
    });

    return _client.postJson<UserFile>(
      '/user-files/me/upload',
      data: fd,
      decoder: (data) => UserFile.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }

  Future<String> fetchText(String fileUrl) async {
    return _client.getText(fileUrl);
  }
}

class UserImageApi {
  UserImageApi(this._client);
  final ApiClient _client;

  Future<List<UserImage>> listMine() async {
    return _client.getJson<List<UserImage>>(
      '/user-images/me',
      decoder: (data) {
        final arr = (data as List?) ?? const [];
        return arr
            .whereType<Map>()
            .map((e) => UserImage.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      },
    );
  }

  Future<UserImage> uploadMine({required File file, String? title}) async {
    final fd = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: file.uri.pathSegments.last),
      ...?(title == null ? null : {'title': title}),
    });

    return _client.postJson<UserImage>(
      '/user-images/me/upload',
      data: fd,
      decoder: (data) => UserImage.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }
}
