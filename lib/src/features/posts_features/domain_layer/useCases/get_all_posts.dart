import 'package:clean_app/src/features/posts_features/domain_layer/respositories/post_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/post_entity.dart';

class GetAllPostsUseCase {
  final PostsRepository repository;

  GetAllPostsUseCase(this.repository);
  Future<Either<Failure, List<Post>>> call()async{
    return await repository.getAllPosts();
  }
}
