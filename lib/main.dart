import 'package:clean_app/src/core/theme/app_theme.dart';
import 'package:clean_app/src/features/posts_features/presentation_layer/bloc/add_delete_update/add_delete_update_bloc.dart';
import 'package:clean_app/src/features/posts_features/presentation_layer/bloc/posts/postes_bloc.dart';
import 'package:clean_app/src/features/posts_features/presentation_layer/pages/posts_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injector_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.injector<PostsBloc>()),
        BlocProvider(create: (_) => di.injector<PostBloc>()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Posts App',
          theme: AppTheme().appTheme,
          home: const PostsPage()),
    );
  }
}
