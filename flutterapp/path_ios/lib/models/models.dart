import 'package:intl/intl.dart';

DateTime? _parseDateTime(dynamic v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  final s = v.toString();
  if (s.isEmpty) return null;
  return DateTime.tryParse(s);
}

int? _asInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  final n = int.tryParse(v.toString());
  return n;
}

double? _asDouble(dynamic v) {
  if (v == null) return null;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  return double.tryParse(v.toString());
}

String _asString(dynamic v) => v == null ? '' : v.toString();

class UserProfile {
  UserProfile({
    required this.id,
    required this.username,
    required this.email,
    this.displayName,
    this.avatarUrl,
    this.bio,
    this.isActive,
    this.isSuperuser,
  });

  final int id;
  final String username;
  final String email;
  final String? displayName;
  final String? avatarUrl;
  final String? bio;
  final bool? isActive;
  final bool? isSuperuser;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: _asInt(json['id']) ?? 0,
      username: _asString(json['username']),
      email: _asString(json['email']),
      displayName: json['display_name']?.toString(),
      avatarUrl: json['avatar_url']?.toString(),
      bio: json['bio']?.toString(),
      isActive: json['is_active'] as bool?,
      isSuperuser: json['is_superuser'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'display_name': displayName,
        'avatar_url': avatarUrl,
        'bio': bio,
        'is_active': isActive,
        'is_superuser': isSuperuser,
      };
}

class Category {
  Category({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    required this.isSystem,
  });

  final int id;
  final String name;
  final String code;
  final String? description;
  final bool isSystem;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: _asInt(json['id']) ?? 0,
      name: _asString(json['name']),
      code: _asString(json['code']),
      description: json['description']?.toString(),
      isSystem: (json['is_system'] as bool?) ?? false,
    );
  }
}

class ChapterItem {
  ChapterItem({
    required this.startSeconds,
    required this.timestamp,
    required this.title,
    this.description,
  });

  final int startSeconds;
  final String timestamp;
  final String title;
  final String? description;

  factory ChapterItem.fromJson(Map<String, dynamic> json) {
    return ChapterItem(
      startSeconds: _asInt(json['start_seconds']) ?? 0,
      timestamp: _asString(json['timestamp']),
      title: _asString(json['title']),
      description: json['description']?.toString(),
    );
  }
}

class UrlExtractResponse {
  UrlExtractResponse({
    required this.title,
    this.description,
    this.thumbnailUrl,
    this.author,
    this.publishDate,
    this.videoId,
    this.durationSeconds,
    this.platform,
    required this.chapters,
  });

  final String title;
  final String? description;
  final String? thumbnailUrl;
  final String? author;
  final String? publishDate;
  final String? videoId;
  final int? durationSeconds;
  final String? platform;
  final List<ChapterItem> chapters;

  factory UrlExtractResponse.fromJson(Map<String, dynamic> json) {
    final rawChapters = (json['chapters'] as List?) ?? const [];
    return UrlExtractResponse(
      title: _asString(json['title']),
      description: json['description']?.toString(),
      thumbnailUrl: json['thumbnail_url']?.toString(),
      author: json['author']?.toString(),
      publishDate: json['publish_date']?.toString(),
      videoId: json['video_id']?.toString(),
      durationSeconds: _asInt(json['duration_seconds']),
      platform: json['platform']?.toString(),
      chapters: rawChapters.whereType<Map>().map((e) => ChapterItem.fromJson(Map<String, dynamic>.from(e))).toList(),
    );
  }
}

class DbResource {
  DbResource({
    required this.id,
    required this.resourceType,
    required this.platform,
    required this.title,
    required this.sourceUrl,
    this.summary,
    this.thumbnail,
    this.categoryId,
    this.categoryName,
    this.difficulty,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
    this.isSystemPublic,
    this.manualWeight,
    this.behaviorWeight,
    this.effectiveWeight,
    this.addedAt,
    this.lastOpened,
    this.openCount,
    this.completionStatus,
  });

  final int id;
  final String resourceType;
  final String platform;
  final String title;
  final String sourceUrl;
  final String? summary;
  final String? thumbnail;
  final int? categoryId;
  final String? categoryName;
  final String? difficulty;
  final Map<String, dynamic> tags;
  final String createdAt;
  final String updatedAt;
  final bool? isSystemPublic;

  final double? manualWeight;
  final double? behaviorWeight;
  final double? effectiveWeight;
  final String? addedAt;
  final String? lastOpened;
  final int? openCount;
  final bool? completionStatus;

  factory DbResource.fromJson(Map<String, dynamic> json) {
    return DbResource(
      id: _asInt(json['id']) ?? 0,
      resourceType: _asString(json['resource_type']),
      platform: _asString(json['platform']),
      title: _asString(json['title']),
      sourceUrl: _asString(json['source_url']),
      summary: json['summary']?.toString(),
      thumbnail: json['thumbnail']?.toString(),
      categoryId: _asInt(json['category_id']),
      categoryName: json['category_name']?.toString(),
      difficulty: json['difficulty']?.toString(),
      tags: (json['tags'] is Map) ? Map<String, dynamic>.from(json['tags'] as Map) : <String, dynamic>{},
      createdAt: _asString(json['created_at']),
      updatedAt: _asString(json['updated_at']),
      isSystemPublic: json['is_system_public'] as bool?,
      manualWeight: _asDouble(json['manual_weight']),
      behaviorWeight: _asDouble(json['behavior_weight']),
      effectiveWeight: _asDouble(json['effective_weight']),
      addedAt: json['added_at']?.toString(),
      lastOpened: json['last_opened']?.toString(),
      openCount: _asInt(json['open_count']),
      completionStatus: json['completion_status'] as bool?,
    );
  }

  String get createdAtText {
    final dt = _parseDateTime(createdAt);
    if (dt == null) return createdAt;
    return DateFormat('yyyy-MM-dd HH:mm').format(dt.toLocal());
  }
}

class DbResourceDetail extends DbResource {
  DbResourceDetail({
    required super.id,
    required super.resourceType,
    required super.platform,
    required super.title,
    required super.sourceUrl,
    super.summary,
    super.thumbnail,
    super.categoryId,
    super.categoryName,
    super.difficulty,
    required super.tags,
    required super.createdAt,
    required super.updatedAt,
    super.isSystemPublic,
    super.manualWeight,
    super.behaviorWeight,
    super.effectiveWeight,
    super.addedAt,
    super.lastOpened,
    super.openCount,
    super.completionStatus,
    this.video,
    this.doc,
    this.article,
  });

  final Map<String, dynamic>? video;
  final Map<String, dynamic>? doc;
  final Map<String, dynamic>? article;

  factory DbResourceDetail.fromJson(Map<String, dynamic> json) {
    return DbResourceDetail(
      id: _asInt(json['id']) ?? 0,
      resourceType: _asString(json['resource_type']),
      platform: _asString(json['platform']),
      title: _asString(json['title']),
      sourceUrl: _asString(json['source_url']),
      summary: json['summary']?.toString(),
      thumbnail: json['thumbnail']?.toString(),
      categoryId: _asInt(json['category_id']),
      categoryName: json['category_name']?.toString(),
      difficulty: json['difficulty']?.toString(),
      tags: (json['tags'] is Map) ? Map<String, dynamic>.from(json['tags'] as Map) : <String, dynamic>{},
      createdAt: _asString(json['created_at']),
      updatedAt: _asString(json['updated_at']),
      isSystemPublic: json['is_system_public'] as bool?,
      manualWeight: _asDouble(json['manual_weight']),
      behaviorWeight: _asDouble(json['behavior_weight']),
      effectiveWeight: _asDouble(json['effective_weight']),
      addedAt: json['added_at']?.toString(),
      lastOpened: json['last_opened']?.toString(),
      openCount: _asInt(json['open_count']),
      completionStatus: json['completion_status'] as bool?,
      video: (json['video'] is Map) ? Map<String, dynamic>.from(json['video'] as Map) : null,
      doc: (json['doc'] is Map) ? Map<String, dynamic>.from(json['doc'] as Map) : null,
      article: (json['article'] is Map) ? Map<String, dynamic>.from(json['article'] as Map) : null,
    );
  }
}

class PublicLearningPath {
  PublicLearningPath({
    required this.id,
    required this.title,
    this.type,
    this.description,
    required this.isPublic,
    required this.isActive,
    this.coverImageUrl,
    this.categoryId,
    this.categoryName,
  });

  final int id;
  final String title;
  final String? type;
  final String? description;
  final bool isPublic;
  final bool isActive;
  final String? coverImageUrl;
  final int? categoryId;
  final String? categoryName;

  factory PublicLearningPath.fromJson(Map<String, dynamic> json) {
    return PublicLearningPath(
      id: _asInt(json['id']) ?? 0,
      title: _asString(json['title']),
      type: json['type']?.toString(),
      description: json['description']?.toString(),
      isPublic: (json['is_public'] as bool?) ?? false,
      isActive: (json['is_active'] as bool?) ?? false,
      coverImageUrl: json['cover_image_url']?.toString(),
      categoryId: _asInt(json['category_id']),
      categoryName: json['category_name']?.toString(),
    );
  }
}

class PathItem {
  PathItem({
    required this.id,
    required this.learningPathId,
    required this.resourceId,
    required this.resourceType,
    required this.title,
    required this.orderIndex,
    this.stage,
    this.purpose,
    this.estimatedTime,
    required this.isOptional,
    this.resourceData,
  });

  final int id;
  final int learningPathId;
  final int resourceId;
  final String resourceType;
  final String title;
  final int orderIndex;
  final String? stage;
  final String? purpose;
  final int? estimatedTime;
  final bool isOptional;
  final DbResource? resourceData;

  factory PathItem.fromJson(Map<String, dynamic> json) {
    return PathItem(
      id: _asInt(json['id']) ?? 0,
      learningPathId: _asInt(json['learning_path_id']) ?? 0,
      resourceId: _asInt(json['resource_id']) ?? 0,
      resourceType: _asString(json['resource_type']),
      title: _asString(json['title']),
      orderIndex: _asInt(json['order_index']) ?? 0,
      stage: json['stage']?.toString(),
      purpose: json['purpose']?.toString(),
      estimatedTime: _asInt(json['estimated_time']),
      isOptional: (json['is_optional'] as bool?) ?? false,
      resourceData: (json['resource_data'] is Map)
          ? DbResource.fromJson(Map<String, dynamic>.from(json['resource_data'] as Map))
          : null,
    );
  }
}

class PublicLearningPathDetail extends PublicLearningPath {
  PublicLearningPathDetail({
    required super.id,
    required super.title,
    super.type,
    super.description,
    required super.isPublic,
    required super.isActive,
    super.coverImageUrl,
    super.categoryId,
    super.categoryName,
    required this.pathItems,
  });

  final List<PathItem> pathItems;

  factory PublicLearningPathDetail.fromJson(Map<String, dynamic> json) {
    final raw = (json['path_items'] as List?) ?? const [];
    return PublicLearningPathDetail(
      id: _asInt(json['id']) ?? 0,
      title: _asString(json['title']),
      type: json['type']?.toString(),
      description: json['description']?.toString(),
      isPublic: (json['is_public'] as bool?) ?? false,
      isActive: (json['is_active'] as bool?) ?? false,
      coverImageUrl: json['cover_image_url']?.toString(),
      categoryId: _asInt(json['category_id']),
      categoryName: json['category_name']?.toString(),
      pathItems: raw.whereType<Map>().map((e) => PathItem.fromJson(Map<String, dynamic>.from(e))).toList(),
    );
  }
}

class ProgressRow {
  ProgressRow({
    required this.pathItemId,
    required this.progressPercentage,
    this.lastWatchedTime,
  });

  final int pathItemId;
  final int progressPercentage;
  final String? lastWatchedTime;

  factory ProgressRow.fromJson(Map<String, dynamic> json) {
    return ProgressRow(
      pathItemId: _asInt(json['path_item_id']) ?? 0,
      progressPercentage: _asInt(json['progress_percentage']) ?? 0,
      lastWatchedTime: json['last_watched_time']?.toString(),
    );
  }
}

class LearningPathComment {
  LearningPathComment({
    required this.id,
    required this.learningPathId,
    required this.userId,
    required this.username,
    required this.content,
    required this.createdAt,
  });

  final int id;
  final int learningPathId;
  final int userId;
  final String username;
  final String content;
  final String createdAt;

  factory LearningPathComment.fromJson(Map<String, dynamic> json) {
    return LearningPathComment(
      id: _asInt(json['id']) ?? 0,
      learningPathId: _asInt(json['learning_path_id']) ?? 0,
      userId: _asInt(json['user_id']) ?? 0,
      username: _asString(json['username']),
      content: _asString(json['content']),
      createdAt: _asString(json['created_at']),
    );
  }
}

class UserFile {
  UserFile({
    required this.id,
    required this.userId,
    this.title,
    required this.fileType,
    this.originalFilename,
    this.contentType,
    this.sizeBytes,
    this.content,
    required this.fileUrl,
    required this.createdAt,
  });

  final int id;
  final int userId;
  final String? title;
  final String fileType;
  final String? originalFilename;
  final String? contentType;
  final int? sizeBytes;
  final String? content;
  final String fileUrl;
  final String createdAt;

  factory UserFile.fromJson(Map<String, dynamic> json) {
    return UserFile(
      id: _asInt(json['id']) ?? 0,
      userId: _asInt(json['user_id']) ?? 0,
      title: json['title']?.toString(),
      fileType: _asString(json['file_type']),
      originalFilename: json['original_filename']?.toString(),
      contentType: json['content_type']?.toString(),
      sizeBytes: _asInt(json['size_bytes']),
      content: json['content']?.toString(),
      fileUrl: _asString(json['file_url']),
      createdAt: _asString(json['created_at']),
    );
  }
}

class UserImage {
  UserImage({
    required this.id,
    required this.userId,
    this.title,
    required this.imageUrl,
    required this.createdAt,
  });

  final int id;
  final int userId;
  final String? title;
  final String imageUrl;
  final String createdAt;

  factory UserImage.fromJson(Map<String, dynamic> json) {
    return UserImage(
      id: _asInt(json['id']) ?? 0,
      userId: _asInt(json['user_id']) ?? 0,
      title: json['title']?.toString(),
      imageUrl: _asString(json['image_url']),
      createdAt: _asString(json['created_at']),
    );
  }
}

class ReaderExtractResponse {
  ReaderExtractResponse({
    required this.url,
    required this.title,
    this.siteName,
    this.byline,
    this.excerpt,
    required this.contentHtml,
    required this.wordCount,
    required this.extractedAt,
  });

  final String url;
  final String title;
  final String? siteName;
  final String? byline;
  final String? excerpt;
  final String contentHtml;
  final int wordCount;
  final String extractedAt;

  factory ReaderExtractResponse.fromJson(Map<String, dynamic> json) {
    return ReaderExtractResponse(
      url: _asString(json['url']),
      title: _asString(json['title']),
      siteName: json['site_name']?.toString(),
      byline: json['byline']?.toString(),
      excerpt: json['excerpt']?.toString(),
      contentHtml: _asString(json['content_html']),
      wordCount: _asInt(json['word_count']) ?? 0,
      extractedAt: _asString(json['extracted_at']),
    );
  }
}
