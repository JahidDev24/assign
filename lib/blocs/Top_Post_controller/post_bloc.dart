import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siyatech_assig_app/utils/Error_handler.dart';
import '../../Model/post.dart';
import '../../repositories/hacker_news_repository.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final HackerNewsRepository repository;
  List<int> _ids = [];
  int _startIndex = 0;
  static const _limit = 10;
  late final ScrollController _scrollController;

  PostBloc({required this.repository}) : super(const PostState()) {
    _scrollController = ScrollController()..addListener(_onScroll);
    on<PostLoadRequested>(_onPostLoadRequested);
    on<PostLoadMoreRequested>(_onPostLoadMoreRequested);
  }

  ScrollController get scrollController => _scrollController;

  Future<void> _onPostLoadRequested(
      PostLoadRequested event, Emitter<PostState> emit) async {
    emit(state.copyWith(status: PostStatus.loading));
    try {
      _ids = await repository.fetchTopStoryIds();
      final posts = await _fetchPosts(0, _limit);
      emit(state.copyWith(
        status: PostStatus.success,
        posts: posts,
        hasReachedMax: _ids.length <= _limit,
      ));
    } catch (error) {
      String message;
      if (error is DioException) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Something Went wrong";
      }
      emit(state.copyWith(
        status: PostStatus.failure,
        error: message.toString(),
      ));
    }
  }

  Future<void> _onPostLoadMoreRequested(
      PostLoadMoreRequested event, Emitter<PostState> emit) async {
    if (state.hasReachedMax) return;

    emit(state.copyWith(status: PostStatus.loading));
    try {
      final posts = await _fetchPosts(_startIndex, _limit);
      emit(state.copyWith(
        status: PostStatus.success,
        posts: List.of(state.posts)..addAll(posts),
        hasReachedMax: _startIndex >= _ids.length,
      ));
    } catch (error) {
      String message;
      if (error is DioException) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Something Went wrong";
      }
      emit(state.copyWith(
        status: PostStatus.failure,
        error: message.toString(),
      ));
    }
  }

  Future<List<Post>> _fetchPosts(int startIndex, int limit) async {
    final endIndex =
        (startIndex + limit <= _ids.length) ? startIndex + limit : _ids.length;
    final idsToFetch = _ids.sublist(startIndex, endIndex);
    _startIndex = endIndex;
    return Future.wait(idsToFetch.map(repository.fetchPost));
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      add(PostLoadMoreRequested());
    }
  }

  @override
  Future<void> close() {
    _scrollController.dispose();
    return super.close();
  }
}
