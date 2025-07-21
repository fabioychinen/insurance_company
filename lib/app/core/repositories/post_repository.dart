import 'package:insurance_company/app/core/models/post_model.dart';

import '../services/api_services.dart';

class PostRepository {
  final ApiServices apiServices;

  PostRepository(this.apiServices);

  Future<List<Post>> fetchPosts() async {
    final data = await apiServices.getPosts();
    return data.map<Post>((json) => Post.fromJson(json)).toList();
  }

  Future<Post> fetchPostById(int id) async {
    final data = await apiServices.getPostById(id);
    return Post.fromJson(data);
  }

  Future<Post> createPost(Post post) async {
    final data = await apiServices.createPost(post.toJson());
    return Post.fromJson(data);
  }
}