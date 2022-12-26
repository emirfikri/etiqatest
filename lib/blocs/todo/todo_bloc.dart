import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/todos_model.dart';
import '../../repositories/todo/todo_repository.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository _todoRepository;
  TodoBloc({TodoRepository? todoRepository})
      : _todoRepository = todoRepository ?? TodoRepository(),
        super(TodoInitial()) {
    on<InitializedTodo>((event, emit) async {
      emit(TodoLoading());
      try {
        var incomingtodo = _todoRepository.getTodoList(userId: event.userId);
        emit(TodoLoaded(todoList: incomingtodo));
      } catch (e) {
        emit(TodoError(error: e.toString()));
      }
    });

    on<AddedNewTodo>((event, emit) async {
      try {
        var id = await _todoRepository.getTodoId();
        Todo thistodo = Todo(
          id: id,
          userId: event.userId,
          title: event.title,
          status: 'Pending',
          startDate: DateTime.parse(event.startdate),
          endDate: DateTime.parse(event.enddate),
        );
        await _todoRepository.addTodo(todo: thistodo);
      } catch (e) {
        print(e.toString());
        emit(TodoError(error: e.toString()));
      }
    });

    on<UpdateTodo>((event, emit) async {
      try {
        await _todoRepository.updateTodo(
            data: event.todo.toDatabaseJson(), todoid: event.todo.id);
      } catch (e) {
        print(e.toString());
        emit(TodoError(error: e.toString()));
      }
    });

    on<SettoCompleted>((event, emit) async {
      try {
        await _todoRepository.updateTodo(
            data: {'iscompleted': event.isCompleted}, todoid: event.todo.id);
      } catch (e) {
        print(e.toString());
        emit(TodoError(error: e.toString()));
      }
    });

    on<DeleteTodo>((event, emit) async {
      try {
        await _todoRepository.deleteTodo(todoid: event.todo.id);
      } catch (e) {
        print(e.toString());
        emit(TodoError(error: e.toString()));
      }
    });
  }
}
