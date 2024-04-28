// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:blog_app/core/errors/exception.dart';
import 'package:blog_app/core/errors/failure.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:blog_app/usecase/use_case.dart';
import 'package:fpdart/fpdart.dart';

class UploadBlog implements UseCase<Blog, UploadBlogParams> {
  final BlogRepository blogRepository;

  UploadBlog(this.blogRepository);

  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams params) async {
    try {
      return await blogRepository.uploadBlog(
          image: params.image,
          title: params.title,
          content: params.content,
          userId: params.userId,
          topics: params.topics);
    } on ServerException catch (error) {
      return left(Failure(error.message));
    }
  }
}

class UploadBlogParams {
  final String userId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;

  UploadBlogParams({
    required this.userId,
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
  });
}
