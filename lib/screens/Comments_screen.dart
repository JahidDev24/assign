import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siyatech_assig_app/blocs/Comment_controller/bloc/comments_bloc.dart';
import 'package:siyatech_assig_app/repositories/hacker_news_repository.dart';
import 'package:siyatech_assig_app/utils/Extantion.dart';
import 'package:siyatech_assig_app/widgets/Comment_buttom_sheet_tile.dart';

class CommentScreen extends StatelessWidget {
  List<int> ids;
  CommentScreen({super.key, required this.ids});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white54,
        elevation: 3,
        title: const Text(
          'Comments',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocProvider(
        create: (context) => CommentsBloc(repository: HackerNewsRepository())
          ..add(CommentsLoadRequested(ids: ids)),
        child: CommentList(
          ids: ids,
        ),
      ),
    );
  }
}

class CommentList extends StatelessWidget {
  final ids;
  const CommentList({super.key, required this.ids});
  @override
  Widget build(BuildContext context) {
    final scrollController = context.read<CommentsBloc>().scrollController;

    return BlocBuilder<CommentsBloc, CommentState>(
      builder: (context, state) {
        switch (state.status) {
          case CommentStatus.loading:
            return state.comment.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: scrollController,
                    itemCount: state.comment.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= state.comment.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final comment = state.comment[index];
                      return CommentsBottomSheet(
                        comments: comment,
                      );
                    },
                  );
          case CommentStatus.success:
            return ListView.builder(
              controller: scrollController,
              itemCount: state.hasReachedMax
                  ? state.comment.length
                  : state.comment.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.comment.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                final comment = state.comment[index];
                return CommentsBottomSheet(
                  comments: comment,
                );
              },
            );
          case CommentStatus.failure:
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Failed to load comment: ${state.error}',
                    textAlign: TextAlign.center,
                  ),
                  4.toSpace,
                  OutlinedButton(
                      onPressed: () {
                        context
                            .read<CommentsBloc>()
                            .add(CommentsLoadRequested(ids: ids));
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
