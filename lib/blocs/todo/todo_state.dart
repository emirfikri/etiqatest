part of 'todo_bloc.dart';

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final Stream todoList;
  const TodoLoaded({required this.todoList});
}

class TodoError extends TodoState {
  final String error;
  const TodoError({required this.error});
}
