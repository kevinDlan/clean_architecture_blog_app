import 'dart:io';
import 'package:blog_app/core/errors/exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/blog_model.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadBlogImage(
      {required File image, required BlogModel blog});
  Future<List<BlogModel>> getAllBlog();
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;

  BlogRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogData =
          await supabaseClient.from("blogs").insert(blog.toJson()).select();

      return BlogModel.fromJson(blogData.first);
    } on PostgrestException catch (error) {
      throw ServerException(error.message);
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  @override
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  }) async {
    try {
      supabaseClient.storage.from('blog_images').upload(
            blog.id,
            image,
          );

      return supabaseClient.storage.from('blog_images').getPublicUrl(blog.id);
    } on StorageException catch (error) {
      throw ServerException(error.message);
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlog() async {
    try {
      final blogs =
          await supabaseClient.from('blogs').select('*, profiles (name)');

      return blogs
          .map(
            (blog) => BlogModel.fromJson(blog).copyWith(
              userName: blog['profiles']['name'],
            ),
          )
          .toList();
    } on PostgrestException catch (error) {
      throw ServerException(error.message);
    } catch (error) {
      throw ServerException(error.toString());
    }
  }
}
