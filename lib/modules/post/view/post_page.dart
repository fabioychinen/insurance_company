
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/core/bloc/post_bloc.dart';
import '../../../app/core/models/post_model.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostErrorState) {
            return Center(child: Text('Erro: ${state.error}'));
          } else if (state is PostLoadedState) {
            return ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts[index];
                return ListTile(
                  title: Text(post.title),
                  subtitle: Text(post.body),
                );
              },
            );
          } else if (state is PostCreatedState) {
            context.read<PostBloc>().add(LoadPostsEvent());
            return const SizedBox.shrink();
          }
          return const Center(child: Text('Pressione para carregar'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final newPost = Post(
            userId: 1,
            id: 0,
            title: 'Novo Post MVVM',
            body: 'Conteúdo gerado pelo BLoC',
          );
          context.read<PostBloc>().add(CreatePostEvent(newPost));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}