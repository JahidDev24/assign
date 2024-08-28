part of 'comments_bloc.dart';

enum CommentStatus { initial, loading, success, failure }

class CommentState extends Equatable {
  final CommentStatus status;
  final List<CommentTile> comment;
  final bool hasReachedMax;
  final String? error;

  const CommentState({
    this.status = CommentStatus.initial,
    this.comment = const <CommentTile>[],
    this.hasReachedMax = false,
    this.error,
  });

  CommentState copyWith({
    CommentStatus? status,
    List<CommentTile>? comment,
    bool? hasReachedMax,
    String? error,
  }) {
    return CommentState(
      status: status ?? this.status,
      comment: comment ?? this.comment,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, comment, hasReachedMax, error];
}
