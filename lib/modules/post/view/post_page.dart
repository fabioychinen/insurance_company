import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurance_company/app/core/repositories/post_repository.dart';

import '../../../app/core/bloc/post_bloc.dart';
import '../../../app/core/injection_container.dart';
import '../../../app/core/models/post_model.dart';

class PostsPageDio extends StatelessWidget {
  const PostsPageDio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts (Dio)')),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostError) {
            return Center(child: Text(state.message));
          } else if (state is PostLoaded) {
            return ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts[index];
                return ListTile(
                  title: Text(post.title),
                  subtitle: Text('Post ID: ${post.id}'),
                  onTap: () {
                  },
                );
              },
            );
          }
          return const Center(child: Text('Pressione o botão para carregar'));
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => context.read<PostBloc>().fetchPosts(),
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () => _createPost(context),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  void _createPost(BuildContext context) async {
    final newPost = Post(
      userId: 1,
      id: 0,
      title: 'Novo Post',
      body: 'Conteúdo do novo post criado com Dio',
    );

    try {
      final createdPost = await getIt<PostRepository>().createPost(newPost);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post criado com ID: ${createdPost.id}')),
      );
      context.read<PostBloc>().fetchPosts();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
  }
}