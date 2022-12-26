import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:etiqa/models/todos_model.dart';
import 'package:etiqa/repositories/notification/notification_repository.dart';
import 'package:etiqa/repositories/repositories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final TodoRepository _todoRepository;
  late final StreamSubscription todosubscription;
  NotificationBloc({TodoRepository? todoRepository, required int userId})
      : _todoRepository = todoRepository ?? TodoRepository(),
        super(NotificationInitial()) {
    final UserRepository userRepository = UserRepository();
    Stream incomingtodo = _todoRepository.getTodoList(userId: userId);

    todosubscription = incomingtodo.listen(
      (element) {
        for (var changes in element.docChanges) {
          if (changes.type == DocumentChangeType.modified) {
            Todo todo = Todo.fromDatabaseJson(changes.doc.data());
            String message = 'Todo ${todo.id} has been updated';
            String desc = todo.toString();
            if (!isClosed) {
              add(NewNotificationfromTodoUpdate(
                  todo: todo, message: message, desc: desc));
            }
          }
          if (changes.type == DocumentChangeType.removed) {
            Todo todo = Todo.fromDatabaseJson(changes.doc.data());
            String message = 'Todo ${todo.id} has been removed';
            String desc = 'removed on ${DateTime.now()}';
            if (!isClosed) {
              add(NewNotificationfromTodoUpdate(
                  todo: todo, message: message, desc: desc));
            }
          }
        }
      },
    );

    on<NewNotificationfromTodoUpdate>((event, emit) async {
      var token = await userRepository.getUserToken(userId: userId.toString());
      NotificationRepository notificationrepository = NotificationRepository();
      if (token != null) {
        await notificationrepository.sendNotification(
            token: token, title: event.message, body: event.desc);
      }
      emit(
          NewNotificationTodoTrigger(todo: event.todo, message: event.message));
      emit(NotificationInitial());
    });
  }

  @override
  Future<void> close() {
    todosubscription.cancel();
    return super.close();
  }
}
