part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class GetOrderPendingStream extends NotificationEvent {
  final List branchId;
  const GetOrderPendingStream({required this.branchId});
}

class NewNotificationfromTodoUpdate extends NotificationEvent {
  final String message;
  final Todo todo;
  final String? desc;
  const NewNotificationfromTodoUpdate(
      {required this.todo, required this.message, this.desc});
}
