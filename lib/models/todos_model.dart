import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String id;
  final int userId;
  String title;
  DateTime? startDate;
  DateTime? endDate;
  String status;
  bool iscompleted;

  Todo({
    required this.id,
    required this.userId,
    required this.title,
    this.startDate,
    this.endDate,
    required this.status,
    this.iscompleted = false,
  });

  Todo copyWith({
    String? id,
    int? userId,
    String? title,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    bool? iscompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      iscompleted: iscompleted ?? this.iscompleted,
    );
  }

  factory Todo.fromDatabaseJson(Map<String, dynamic> data) => Todo(
        id: data['id'],
        title: data['title'],
        startDate: data['startDate'].toDate(),
        endDate: data['endDate'].toDate(),
        status: data['status'],
        userId: data['userId'],
        iscompleted: data['iscompleted'],
      );

  Map<String, dynamic> toDatabaseJson() => {
        "id": id,
        "title": title,
        "startDate": startDate,
        "endDate": endDate,
        "status": status,
        "userId": userId,
        "iscompleted": iscompleted,
      };

  @override
  String toString() =>
      "id: $id, title: $title, startDate: $startDate, endDate: $endDate, status: $status,userId: $userId,iscompleted: $iscompleted";

  @override
  List<Object?> get props =>
      [id, title, startDate, endDate, status, userId, iscompleted];
}
