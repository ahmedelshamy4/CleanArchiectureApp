import 'package:clean_app/src/features/posts_features/presentation_layer/bloc/add_delete_update/add_delete_update_bloc.dart';
import 'package:clean_app/src/features/posts_features/presentation_layer/pages/posts_page.dart';
import 'package:clean_app/src/features/posts_features/presentation_layer/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain_layer/entities/post_entity.dart';
import '../widgets/add_delete_update_widget.dart';

class PostAddAndUpdatePage extends StatelessWidget {
  const PostAddAndUpdatePage({Key? key, this.post, this.isUpdate = false})
      : super(key: key);
  final Post? post;
  final bool isUpdate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarUtil(title: isUpdate ? 'Update Post' : 'Add Post'),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocConsumer<PostBloc, PostState>(
      listener: (context, state) {
        if (state is PostSuccessState) {
          showSnackBar(context, message: state.message, color: Colors.green);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const PostsPage()),
              (route) => false);
        } else if (state is PostErrorState) {
          showSnackBar(context,
              message: state.message, color: Colors.redAccent);
        }
      },
      builder: (context, state) {
        if (state is LoadingPostState) {
          return const LoadingUtil();
        } else {
          return FormWidget(
            isUpdate: isUpdate,
            post: isUpdate ? post : null,
          );
        }
      },
    );
  }
}
