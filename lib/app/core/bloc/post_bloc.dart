import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurance_company/app/core/models/post_model.dart';

import '../repositories/post_repository.dart';



abstract class PostEvent {}

class LoadPostsEvent extends PostEvent {}

class CreatePostEvent extends PostEvent {
  final Post post;
  CreatePostEvent(this.post);
}


abstract class PostState {}

class PostInitialState extends PostState {}

class PostLoadingState extends PostState {}

class PostLoadedState extends PostState {
  final List<Post> posts;
  PostLoadedState(this.posts);
}

class PostCreatedState extends PostState {
  final Post post;
  PostCreatedState(this.post);
}

class PostErrorState extends PostState {
  final String error;
  PostErrorState(this.error);
}

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository _repository;

  PostBloc(this._repository) : super(PostInitialState()) {
    on<LoadPostsEvent>(_onLoadPosts);
    on<CreatePostEvent>(_onCreatePost);
  }

  FutureOr<void> _onLoadPosts(
    LoadPostsEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(PostLoadingState());
    try {
      final posts = await _repository.fetchPosts();
      emit(PostLoadedState(posts));
    } catch (e) {
      emit(PostErrorState(e.toString()));
    }
  }

  FutureOr<void> _onCreatePost(
    CreatePostEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(PostLoadingState());
    try {
      final createdPost = await _repository.createPost(event.post);
      emit(PostCreatedState(createdPost));
      add(LoadPostsEvent());
    } catch (e) {
      emit(PostErrorState(e.toString()));
    }
  }
}