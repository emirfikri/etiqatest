part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class InitializedTodo extends TodoEvent {
  final int userId;

  const InitializedTodo({required this.userId});
}

class AddedNewTodo extends TodoEvent {
  final int userId;
  final String title;
  final String startdate;
  final String enddate;

  const AddedNewTodo({
    required this.userId,
    required this.title,
    required this.startdate,
    required this.enddate,
  });
}

class UpdateTodo extends TodoEvent {
  final Todo todo;
  const UpdateTodo({required this.todo});
}

class SettoCompleted extends TodoEvent {
  final Todo todo;
  final bool isCompleted;
  const SettoCompleted({required this.todo, required this.isCompleted});
}

class DeleteTodo extends TodoEvent {
  final Todo todo;
  const DeleteTodo({required this.todo});
}
