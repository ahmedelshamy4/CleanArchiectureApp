import 'package:clean_app/src/features/posts_features/presentation_layer/bloc/posts/postes_bloc.dart';
import 'package:clean_app/src/features/posts_features/presentation_layer/widgets/post_list_widget.dart';
import 'package:clean_app/src/features/posts_features/presentation_layer/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/colors.dart';
import 'create_or_update_postPage.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _buildBody() {
      return BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          final PostsBloc bloc = PostsBloc.get(context);
          if (state is PostsInitial) {
            bloc.add(GetAllPostsEvent());
            return const LoadingUtil();
          } else if (state is LoadingPostsState) {
            return const LoadingUtil();
          } else if (state is LoadedPostsState) {
            return RefreshIndicator(
              child: PostListWidget(posts: state.posts),
              onRefresh: () async => bloc.add(RefreshPostsEvent()),
            );
          } else if (state is ErrorPostsState) {
            return ErrorMessageWidget(
              message: state.message,
            );
          } else {
            return const ErrorMessageWidget(
              message: 'state.message',
            );
          }
        },
      );
    }
    FloatingActionButton _buildFloatingButton(BuildContext context) {
      return FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: whiteClr,
          size: 30,
        ),
        onPressed: () => onNavigate(
          context,
          page: const PostAddAndUpdatePage(),
        ),
      );
    }
    return Scaffold(
      appBar: appBarUtil(title: 'Posts'),
      body: _buildBody(),
      floatingActionButton: _buildFloatingButton(context),
    );
  }
}
