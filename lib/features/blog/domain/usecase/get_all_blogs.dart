import 'package:blog_app/core/errors/exception.dart';
import 'package:blog_app/core/errors/failure.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:blog_app/usecase/use_case.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/blog.dart';

class GetAllBlogs implements UseCase<List<Blog>, NoParams> {
  final BlogRepository blogRepository;
  GetAllBlogs(this.blogRepository);
  @override
  Future<Either<Failure, List<Blog>>> call(NoParams params) async {
    try {
      return await blogRepository.getAllBlogs();
    } on ServerException catch (error) {
      return left(Failure(error.message));
    }
  }
}
