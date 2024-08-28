import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siyatech_assig_app/Model/Comment.dart';
import 'package:siyatech_assig_app/utils/Error_handler.dart';
import '../../../repositories/hacker_news_repository.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentState> {
  final HackerNewsRepository repository;
  List<int> _ids = [];
  int _startIndex = 0;
  static const _limit = 10;
  late final ScrollController _scrollController;

  CommentsBloc({required this.repository}) : super(const CommentState()) {
    _scrollController = ScrollController()..addListener(_onScroll);
    on<CommentsLoadRequested>(_onPostLoadRequested);
    on<CommentsLoadMoreRequested>(_onPostLoadMoreRequested);
  }

  ScrollController get scrollController => _scrollController;

  Future<void> _onPostLoadRequested(
      CommentsLoadRequested event, Emitter<CommentState> emit) async {
    emit(state.copyWith(status: CommentStatus.loading));
    try {
      debugPrint("i am here : ${event.ids}");
      _ids = event.ids;
      final comment =
          await _fetchComment(0, _ids.length >= _limit ? _limit : _ids.length);

      emit(state.copyWith(
        status: CommentStatus.success,
        comment: comment,
        hasReachedMax: _ids.length <= _limit,
      ));
    } catch (error) {
      debugPrint("error" + error.toString());
      String message;
      if (error is DioException) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Something Went wrong";
      }
      emit(state.copyWith(
        status: CommentStatus.failure,
        error: message.toString(),
      ));
    }
  }

  Future<void> _onPostLoadMoreRequested(
      CommentsLoadMoreRequested event, Emitter<CommentState> emit) async {
    if (state.hasReachedMax) return;

    emit(state.copyWith(status: CommentStatus.loading));
    try {
      final comment = await _fetchComment(_startIndex, _limit);
      emit(state.copyWith(
        status: CommentStatus.success,
        comment: List.of(state.comment)..addAll(comment),
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
        status: CommentStatus.failure,
        error: message.toString(),
      ));
    }
  }

  Future<List<CommentTile>> _fetchComment(int startIndex, int limit) async {
    final endIndex =
        (startIndex + limit <= _ids.length) ? startIndex + limit : _ids.length;
    final idsToFetch = _ids.sublist(startIndex, endIndex);
    _startIndex = endIndex;
    return Future.wait(idsToFetch.map(repository.fetchComment));
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      add(CommentsLoadMoreRequested());
    }
  }

  @override
  Future<void> close() {
    _scrollController.dispose();
    return super.close();
  }
}
