part of 'comments_bloc.dart';

sealed class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List<Object> get props => [];
}

class CommentsLoadRequested extends CommentsEvent {
  final ids;
  CommentsLoadRequested({this.ids});
}

class CommentsLoadMoreRequested extends CommentsEvent {}
