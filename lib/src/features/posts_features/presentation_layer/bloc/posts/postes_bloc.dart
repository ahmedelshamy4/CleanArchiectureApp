import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failures_handling.dart';
import '../../../domain_layer/entities/post_entity.dart';
import '../../../domain_layer/useCases/get_all_posts.dart';

part 'postes_event.dart';

part 'postes_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final GetAllPostsUseCase getAllPostsUseCase;
  final FailuresHandling failuresHandling;

  static get(BuildContext context) => BlocProvider.of<PostsBloc>(context);

  PostsBloc({
    required this.getAllPostsUseCase,
    required this.failuresHandling,
  }) : super(PostsInitial()) {
    on<PostsEvent>((event, emit) async {
      if (event is GetAllPostsEvent || event is RefreshPostsEvent) {
        emit(LoadingPostsState());
        final posts = await getAllPostsUseCase();
        posts.fold(
          (left) {
            emit(
              ErrorPostsState(
                  message: failuresHandling.onHandlingFailures(failure: left)),
            );
          },
          (right) {
            emit(LoadedPostsState(posts: right));
          },
        );
      }
    });
  }
}
