import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:insurance_company/app/core/models/post_model.dart';
import 'package:insurance_company/app/core/repositories/post_repository.dart';
import 'package:insurance_company/app/core/bloc/post_bloc.dart';

class MockPostRepository extends Mock implements PostRepository {}

void main() {
  late MockPostRepository mockRepository;
  late PostBloc bloc;

  setUp(() {
    mockRepository = MockPostRepository();
    bloc = PostBloc(mockRepository);
  });

  test('emits [PostLoadingState, PostLoadedState] when LoadPostsEvent is added', () async {
    final posts = [
      Post(id: 1, userId: 2, title: 'title', body: 'body'),
      Post(id: 2, userId: 2, title: 'title2', body: 'body2'),
    ];
    when(() => mockRepository.fetchPosts()).thenAnswer((_) async => posts);

    bloc.add(LoadPostsEvent());

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<PostLoadingState>(),
        isA<PostLoadedState>().having((s) => (s).posts, 'posts', posts),
      ]),
    );
  });

  test('emits [PostLoadingState, PostErrorState] when repository throws on load', () async {
    when(() => mockRepository.fetchPosts()).thenThrow(Exception('error'));

    bloc.add(LoadPostsEvent());

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<PostLoadingState>(),
        isA<PostErrorState>(),
      ]),
    );
  });

  test('emits [PostLoadingState, PostCreatedState, PostLoadingState, PostLoadedState] when CreatePostEvent is added', () async {
    final post = Post(id: 0, userId: 99, title: 'new', body: 'body');
    final created = Post(id: 5, userId: 99, title: 'new', body: 'body');
    final posts = [created];

    when(() => mockRepository.createPost(post)).thenAnswer((_) async => created);
    when(() => mockRepository.fetchPosts()).thenAnswer((_) async => posts);

    bloc.add(CreatePostEvent(post));

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<PostLoadingState>(),
        isA<PostCreatedState>().having((s) => (s).post, 'post', created),
        isA<PostLoadingState>(),
        isA<PostLoadedState>().having((s) => (s).posts, 'posts', posts),
      ]),
    );
  });

  test('emits [PostLoadingState, PostErrorState] when repository throws on create', () async {
    final post = Post(id: 0, userId: 99, title: 'new', body: 'body');
    when(() => mockRepository.createPost(post)).thenThrow(Exception('create error'));

    bloc.add(CreatePostEvent(post));

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<PostLoadingState>(),
        isA<PostErrorState>(),
      ]),
    );
  });
}