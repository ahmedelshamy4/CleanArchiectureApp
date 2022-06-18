import 'dart:convert';
import 'dart:io';

import 'package:clean_app/src/core/constant/api_constant.dart';
import 'package:clean_app/src/features/posts_features/data_layer/models/post_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../../../core/errors/exception.dart';

abstract class RemoteDataSource {
  Future<List<PostModel>> getAllPosts();

  Future<Unit> deletePost(int postId);

  Future<Unit> addPost(PostModel postModel);

  Future<Unit> updatePost(PostModel postModel);
}

class PostRemoteDataSourceImplWithHttp implements RemoteDataSource {
  final http.Client client;

  PostRemoteDataSourceImplWithHttp({required this.client});

  @override
  Future<List<PostModel>> getAllPosts() async {
    final http.Response response = await http.get(
      Uri.parse('$baseUrl/posts'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> decodedJson = json.decode(response.body) as List;
      final List<PostModel> posts = decodedJson
          .map<PostModel>((postModel) => PostModel.fromJson(postModel))
          .toList();
      return Future.value(posts);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> addPost(PostModel postModel) async {
    final jsonBody = {
      'title': postModel.title,
      'body': postModel.body,
    };
    final http.Response response = await http.post(
      Uri.parse(baseUrl + "/posts"),
      body: jsonBody,
    );
    if (response.statusCode == 201) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> deletePost(int postId) async {
    final http.Response response =
    await http.delete(Uri.parse(baseUrl + '/posts/$postId'));
    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> updatePost(PostModel postModel) async {
    final String postId = postModel.id.toString();
    final jsonBody = {
      'title': postModel.title,
      'body': postModel.body,
    };
    final http.Response response = await http.put(
      Uri.parse(baseUrl + '/posts/$postId'),
      body: jsonBody,
    );
    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }
}
