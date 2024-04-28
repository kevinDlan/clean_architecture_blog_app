import 'package:blog_app/features/blog/domain/entities/blog.dart';

class BlogModel extends Blog {
  BlogModel(
      {required super.id,
      required super.userId,
      required super.title,
      required super.content,
      required super.imgUrl,
      required super.topics,
      required super.updatedAt,
      super.userName});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id,
      "user_id": userId,
      "title": title,
      "content": content,
      "img_url": imgUrl,
      "topics": topics,
      "updated_at": updatedAt.toIso8601String()
    };
  }

  factory BlogModel.fromJson(Map<String, dynamic> map) {
    return BlogModel(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      imgUrl: map['img_url'] ?? '',
      topics: List<String>.from(map['topics'] ?? []),
      updatedAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at']),
    );
  }

  BlogModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    String? imgUrl,
    List<String>? topics,
    DateTime? updatedAt,
    String? userName,
  }) {
    return BlogModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      imgUrl: imgUrl ?? this.imgUrl,
      topics: topics ?? this.topics,
      updatedAt: updatedAt ?? this.updatedAt,
      userName: userId ?? this.userName,
    );
  }
}
