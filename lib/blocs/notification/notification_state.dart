part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NewNotificationTodoTrigger extends NotificationState {
  final Todo todo;
  final String message;
  final String? desc;
  const NewNotificationTodoTrigger(
      {required this.todo, required this.message, this.desc});
}
