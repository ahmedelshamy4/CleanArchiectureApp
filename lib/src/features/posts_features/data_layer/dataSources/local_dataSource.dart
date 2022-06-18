import 'dart:convert';

import 'package:clean_app/src/core/errors/exception.dart';

import 'package:clean_app/src/features/posts_features/data_layer/models/post_model.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constant/cache_keys.dart';

abstract class LocalDataSource {
  Future<List<PostModel>> getCachedPosts();

  Future<Unit> cachePosts(List<PostModel> postModel);
}

class PostLocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences sharedPreferences;

  PostLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<Unit> cachePosts(List<PostModel> postModel) async {
    List postModelToJson = postModel
        .map<Map<String, dynamic>>((postModel) => postModel.toJson())
        .toList();
    sharedPreferences.setString(cachedPosts, json.encode(postModelToJson));
    return Future.value(unit);
  }

  @override
  Future<List<PostModel>> getCachedPosts() {
    final String? jsonString = sharedPreferences.getString(cachedPosts);
    if (jsonString != null) {
      final List<dynamic> decodeJsonData = json.decode(jsonString);
      final List<PostModel> jsonToPostModels = decodeJsonData
          .map<PostModel>(
            (jsonPostModel) => PostModel.fromJson(jsonPostModel),
          )
          .toList();
      return Future.value(jsonToPostModels);
    } else {
      throw EmptyCacheException();
    }
  }
}
