import 'package:bloc/bloc.dart';
import 'package:clean_app/src/core/constant/constant.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/errors/failures_handling.dart';
import '../../../domain_layer/entities/post_entity.dart';
import '../../../domain_layer/useCases/add_post.dart';
import '../../../domain_layer/useCases/delete_post.dart';
import '../../../domain_layer/useCases/update_post.dart';

part 'add_delete_update_event.dart';

part 'add_delete_update_state.dart';

class PostBloc
    extends Bloc<AddDeleteUpdateEvent, PostState> {
  final AddPostUseCase addPostUseCase;
  final UpdatePostUseCase updatePostUseCase;
  final DeletePostUseCase deletePostUseCase;
  final FailuresHandling failuresHandling;

  PostBloc({
    required this.addPostUseCase,
    required this.updatePostUseCase,
    required this.deletePostUseCase,
    required this.failuresHandling,
  }) : super(PostInitialState()) {
    on<AddDeleteUpdateEvent>(
      (event, emit) async {
        if (event is AddPostEvent) {
          emit(LoadingPostState());
          final result = await addPostUseCase(event.post);
          emit(_handlingEitherResult(result, postAddSuccessfullyMessage));
        } else if (event is UpdatePostEvent) {
          emit(LoadingPostState());
          final result = await updatePostUseCase(event.post);
          emit(_handlingEitherResult(result, postUpdatedSuccessfullyMessage));
        } else if (event is DeletePostEvent) {
          emit(LoadingPostState());
          final result = await deletePostUseCase(event.postId);
          emit(_handlingEitherResult(result, postDeletedSuccessfullyMessage));
        }
      },
    );
  }

  PostState _handlingEitherResult(
      Either<Failure, Unit> either, String message) {
    return either.fold((left) {
      return PostErrorState(
          message: failuresHandling.onHandlingFailures(failure: left));
    }, (right) {
      return PostSuccessState(message: message);
    });
  }

  static PostBloc get(BuildContext context) =>
      BlocProvider.of<PostBloc>(context);
}
