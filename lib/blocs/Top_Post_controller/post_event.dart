part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

class PostLoadRequested extends PostEvent {}

class PostLoadMoreRequested extends PostEvent {}
