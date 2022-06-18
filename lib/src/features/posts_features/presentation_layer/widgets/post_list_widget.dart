import 'package:clean_app/src/features/posts_features/presentation_layer/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../domain_layer/entities/post_entity.dart';
import '../pages/post_details_page.dart';

class PostListWidget extends StatelessWidget {
  final List<Post> posts;

  const PostListWidget({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(10.0),
      itemBuilder: (_, index) => PostItemWidget(
        number: index,
        post: posts[index],
      ),
      separatorBuilder: (_, index) => const Divider(
        color: mainClr,
        thickness: 2,
        height: 15,
      ),
      itemCount: posts.length,
    );
  }
}

class PostItemWidget extends StatelessWidget {
  final int number;
  final Post post;

  const PostItemWidget({Key? key, required this.number, required this.post})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onNavigate(
        context,
        page: PostDetailsPage(post: post),
      ),
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: const BoxDecoration(
              color: mainClr,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                (number + 1).toString(),
                style: const TextStyle(
                  color: whiteClr,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: PostWidgetUtil(post: post),
          ),
        ],
      ),
    );
  }
}
