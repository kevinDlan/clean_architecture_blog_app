import 'dart:io';

import 'package:blog_app/features/blog/domain/usecase/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecase/upload_blog.dart';
import 'package:blog_app/usecase/use_case.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/blog.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  BlogBloc({required UploadBlog uploadBlog, required GetAllBlogs getAllBlogs})
      : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        super(BlogInitial()) {
    on<BlogEvent>(
        (BlogEvent event, Emitter<BlogState> emit) => emit(BlogLoading()));
    on<BlogUploadEvent>(_onBlogUpload);
    on<BlogFetchAllBlogsEvent>(_onAllBlogsFetch);
  }

  void _onBlogUpload(BlogUploadEvent event, Emitter<BlogState> emit) async {
    final res = await _uploadBlog(
      UploadBlogParams(
        userId: event.userId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
      ),
    );

    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogSuccess()),
    );
  }

  void _onAllBlogsFetch(
      BlogFetchAllBlogsEvent event, Emitter<BlogState> emit) async {
    final res = await _getAllBlogs(NoParams());

    res.fold(
      (l) => emit(
        BlogFailure(l.message),
      ),
      (r) => emit(BlogsDisplaySuccess(r)),
    );
  }
}
