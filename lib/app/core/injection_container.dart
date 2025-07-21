import 'bloc/post_bloc.dart';
import 'repositories/post_repository.dart';
import 'services/api_services.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerSingleton<ApiServices>(ApiServices());
  getIt.registerSingleton<PostRepository>(PostRepository(getIt<ApiServices>()));
  getIt.registerFactory<PostBloc>(() => PostBloc(getIt<PostRepository>()));
}