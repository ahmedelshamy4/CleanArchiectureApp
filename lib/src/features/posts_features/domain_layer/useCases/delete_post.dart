import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';

import '../respositories/post_repo.dart';

class DeletePostUseCase {
  final PostsRepository repository;

  DeletePostUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int postId) async {
    return await repository.deletePost(postId);
  }
}
