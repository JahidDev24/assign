import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siyatech_assig_app/blocs/Top_Post_controller/post_bloc.dart';
import 'package:siyatech_assig_app/utils/Extantion.dart';
import '../repositories/hacker_news_repository.dart';
import '../widgets/News_list_tile.dart';


class PostScreen extends StatelessWidget {
  PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white54,
        elevation: 3,
        title: const Text(
          'Top News Feed',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => PostBloc(repository: HackerNewsRepository())
          ..add(PostLoadRequested()),
        child: PostList(),
      ),
    );
  }
}

class PostList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scrollController = context.read<PostBloc>().scrollController;

    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        switch (state.status) {
          case PostStatus.loading:
            return state.posts.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: scrollController,
                    itemCount: state.posts.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= state.posts.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final post = state.posts[index];
                      return NewsItem(
                        title: post.title,
                        author: post.by,
                        category: post.type,
                        commentlistID: post.kids,
                        time: post.time,
                        urllaunch: post.url,
                      );
                    },
                  );
          case PostStatus.success:
            return ListView.builder(
              controller: scrollController,
              itemCount: state.hasReachedMax
                  ? state.posts.length
                  : state.posts.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.posts.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                final post = state.posts[index];
                return NewsItem(
                  title: post.title,
                  author: post.by,
                  category: post.type,
                  commentlistID: post.kids,
                  time: post.time,
                  urllaunch: post.url,
                );
              },
            );
          case PostStatus.failure:
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Failed to load posts: ${state.error}',
                    textAlign: TextAlign.center,
                  ),
                  4.toSpace,
                  OutlinedButton(
                      onPressed: () {
                        context.read<PostBloc>().add(PostLoadRequested());
                      },
                      child: Text("Retry"))
                ],
              ),
            ));
          default:
            return const Center(child: Text('Something went wrong'));
        }
      },
    );
  }
}
