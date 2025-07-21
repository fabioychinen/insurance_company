import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/post_model.dart';
import '../repositories/post_repository.dart';

class PostBloc extends Cubit<PostState> {
  final PostRepository repository;

  PostBloc(this.repository) : super(PostInitial());

  Future<void> fetchPosts() async {
    emit(PostLoading());
    try {
      final posts = await repository.fetchPosts();
      emit(PostLoaded(posts));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }
}

abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<Post> posts;
  PostLoaded(this.posts);
}

class PostError extends PostState {
  final String message;
  PostError(this.message);
}