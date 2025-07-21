import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:insurance_company/app/core/models/post_model.dart';
import 'package:insurance_company/app/core/repositories/post_repository.dart';
import 'package:insurance_company/app/core/services/api_services.dart';

class MockApiServices extends Mock implements ApiServices {}

void main() {
  late MockApiServices mockApi;
  late PostRepository repository;

  setUp(() {
    mockApi = MockApiServices();
    repository = PostRepository(mockApi);
  });

  group('PostRepository', () {
    test('fetchPosts returns a list of Post', () async {
      final mockJsonList = [
        {'id': 1, 'userId': 999, 'title': 'title 1', 'body': 'body 1'},
        {'id': 2, 'userId': 888, 'title': 'title 2', 'body': 'body 2'},
      ];
      when(() => mockApi.getPosts()).thenAnswer((_) async => mockJsonList);

      final result = await repository.fetchPosts();

      expect(result, isA<List<Post>>());
      expect(result.length, 2);
      expect(result[0].id, 1);
      expect(result[1].title, 'title 2');
      verify(() => mockApi.getPosts()).called(1);
    });

    test('fetchPostById returns a single Post', () async {
      final mockJson = {'id': 10, 'userId': 777, 'title': 'Post 10', 'body': 'Body 10'};
      when(() => mockApi.getPostById(10)).thenAnswer((_) async => mockJson);

      final result = await repository.fetchPostById(10);

      expect(result, isA<Post>());
      expect(result.id, 10);
      expect(result.title, 'Post 10');
      expect(result.userId, 777);
      verify(() => mockApi.getPostById(10)).called(1);
    });

    test('createPost calls api and returns created Post', () async {
      final post = Post(id: 0, userId: 42, title: 'New Post', body: 'Hello');
      final mockCreatedJson = {'id': 123, 'userId': 42, 'title': 'New Post', 'body': 'Hello'};

      when(() => mockApi.createPost(post.toJson()))
          .thenAnswer((_) async => mockCreatedJson);

      final result = await repository.createPost(post);

      expect(result, isA<Post>());
      expect(result.id, 123);
      expect(result.title, 'New Post');
      expect(result.userId, 42);
      verify(() => mockApi.createPost(post.toJson())).called(1);
    });
  });
}