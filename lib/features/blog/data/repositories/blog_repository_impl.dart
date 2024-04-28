import 'dart:io';
import 'package:blog_app/core/errors/failure.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constant/constant.dart';
import '../../../../core/errors/exception.dart';
import '../../domain/entities/blog.dart';
import '../datasources/blog_remote_data_source.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSource blogLocalDataSource;
  final ConnectionChecker connectionChecker;

  BlogRepositoryImpl(
    this.blogRemoteDataSource,
    this.blogLocalDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String userId,
    required List<String> topics,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constant.noConnectionErrorMessage));
      }
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        userId: userId,
        title: title,
        content: content,
        imgUrl: "",
        topics: topics,
        updatedAt: DateTime.now(),
      );

      final uploadedImgUrl = await blogRemoteDataSource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );

      blogModel = blogModel.copyWith(imgUrl: uploadedImgUrl);

      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blogModel);

      return right(uploadedBlog);
    } on ServerException catch (error) {
      return left(
        Failure(
          error.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final blogs = blogLocalDataSource.loadBlogs();
        return right(blogs);
      }
      final blogs = await blogRemoteDataSource.getAllBlog();
      blogLocalDataSource.uploadLocalBlogs(blogs: blogs);
      return right(blogs);
    } on ServerException catch (error) {
      return left(Failure(error.message));
    }
  }
}
