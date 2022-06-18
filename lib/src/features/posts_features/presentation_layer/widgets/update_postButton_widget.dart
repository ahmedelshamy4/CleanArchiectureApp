import 'package:clean_app/src/features/posts_features/domain_layer/entities/post_entity.dart';
import 'package:clean_app/src/features/posts_features/presentation_layer/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../pages/create_or_update_postPage.dart';

class UpdatePostButtonWidget extends StatelessWidget {
  const UpdatePostButtonWidget({Key? key, required this.post})
      : super(key: key);
  final Post post;

  @override
  Widget build(BuildContext context) {
    return ElevatedButtonUtil(
      child: Row(
        children: const [
          Icon(
            Icons.edit,
            size: 22,
            color: whiteClr,
          ),
          SizedBox(width: 10),
          Text(
            'Update',
            style: TextStyle(
              color: whiteClr,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      onClick: () => onNavigate(context,
          page: PostAddAndUpdatePage(
            isUpdate: true,
            post: post,
          )),
    );
  }
}
