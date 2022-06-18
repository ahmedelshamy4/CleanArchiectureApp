import 'package:clean_app/src/core/errors/failures_handling.dart';
import 'package:clean_app/src/core/network/network_info.dart';
import 'package:clean_app/src/features/posts_features/data_layer/dataSources/local_dataSource.dart';
import 'package:clean_app/src/features/posts_features/data_layer/dataSources/remote_dataSource.dart';
import 'package:clean_app/src/features/posts_features/data_layer/repositories/post_repository_impl.dart';
import 'package:clean_app/src/features/posts_features/domain_layer/respositories/post_repo.dart';
import 'package:clean_app/src/features/posts_features/domain_layer/useCases/add_post.dart';
import 'package:clean_app/src/features/posts_features/domain_layer/useCases/delete_post.dart';
import 'package:clean_app/src/features/posts_features/domain_layer/useCases/get_all_posts.dart';
import 'package:clean_app/src/features/posts_features/domain_layer/useCases/update_post.dart';
import 'package:clean_app/src/features/posts_features/presentation_layer/bloc/add_delete_update/add_delete_update_bloc.dart';
import 'package:clean_app/src/features/posts_features/presentation_layer/bloc/posts/postes_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


final injector = GetIt.instance;

Future<void> init() async {
  ///POSTS FEATURE

  //Blocs
  injector.registerFactory(() => PostsBloc(
        getAllPostsUseCase: injector(),
        failuresHandling: injector(),
      ));
  injector.registerFactory(() => PostBloc(
        addPostUseCase: injector(),
        updatePostUseCase: injector(),
        deletePostUseCase: injector(),
        failuresHandling: injector(),
      ));
  //UseCases
  injector.registerLazySingleton(() => GetAllPostsUseCase(injector()));
  injector.registerLazySingleton(() => AddPostUseCase(injector()));
  injector.registerLazySingleton(() => DeletePostUseCase(injector()));
  injector.registerLazySingleton(() => UpdatePostUseCase(injector()));
  //Repository
  injector.registerLazySingleton<PostsRepository>(() => PostsRepositoryImpl(
      injector(),
      remoteDataSource: injector(),
      localDataSource: injector()));
  //Data Sources
  injector.registerLazySingleton<RemoteDataSource>(
      () => PostRemoteDataSourceImplWithHttp(client: injector()));
  injector.registerLazySingleton<LocalDataSource>(
      () => PostLocalDataSourceImpl(sharedPreferences: injector()));

  ///POSTS FEATURE

  //Core
  injector.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImplWithConnectionChecker(injector()));
  injector.registerLazySingleton(() => FailuresHandling());
  //External Plugins
  SharedPreferences preferences = await SharedPreferences.getInstance();
  injector.registerLazySingleton(() => preferences);
  injector.registerLazySingleton(() => InternetConnectionChecker());
  injector.registerLazySingleton(() => http.Client());
}
