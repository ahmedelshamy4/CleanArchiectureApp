import 'package:clean_app/src/core/errors/exception.dart';
import 'package:clean_app/src/core/errors/failure.dart';
import 'package:clean_app/src/features/posts_features/data_layer/dataSources/local_dataSource.dart';
import 'package:clean_app/src/features/posts_features/data_layer/dataSources/remote_dataSource.dart';
import 'package:clean_app/src/features/posts_features/data_layer/models/post_model.dart';
import 'package:clean_app/src/features/posts_features/domain_layer/entities/post_entity.dart';
import 'package:clean_app/src/features/posts_features/domain_layer/respositories/post_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/network/network_info.dart';

typedef DeleteOrUpdateOrAddPots = Future<Unit> Function();

class PostsRepositoryImpl implements PostsRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PostsRepositoryImpl(this.networkInfo,
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, List<Post>>> getAllPosts() async {
    if (await networkInfo.isConnected) {
      try {
        final remotePosts = await remoteDataSource.getAllPosts();
        localDataSource.cachePosts(remotePosts);
        return Right(remotePosts);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localPosts = await localDataSource.getCachedPosts();
        return Right(localPosts);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> addPost(Post post) async {
    final PostModel postModel = PostModel(title: post.title, body: post.body);
    return await _organizeFutureFunction(
      () {
        return remoteDataSource.addPost(postModel);
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> deletePost(int postId) async {
    return await _organizeFutureFunction(
      () {
        return remoteDataSource.deletePost(postId);
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> updatePost(Post post) async {
    final PostModel postModel =
        PostModel(id: post.id, title: post.title, body: post.body);
    return await _organizeFutureFunction(
      () {
        return remoteDataSource.updatePost(postModel);
      },
    );
  }

  Future<Either<Failure, Unit>> _organizeFutureFunction(
    DeleteOrUpdateOrAddPots deleteOrUpdateOrAddPost,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await deleteOrUpdateOrAddPost();
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
