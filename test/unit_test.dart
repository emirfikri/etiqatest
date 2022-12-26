import 'package:etiqa/configs/firebase_options.dart';
import 'package:etiqa/models/todos_model.dart';
import 'package:etiqa/repositories/todo/todo_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  test('Initializes toDoList with empty', () {
    List<Todo> _items = [];
    expect(_items.length, 0);
  });

  test('Added toDoList', () {
    List<Todo> _items = [];
    _items.add(Todo(
      id: UniqueKey().toString(),
      title: 'Test',
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      iscompleted: false,
      status: 'Pending',
      userId: 3,
    ));
    expect(_items.length, 1);
  });

  test('ToDo is completed', () {
    List<Todo> _items = [];
    _items.add(Todo(
      id: UniqueKey().toString(),
      title: 'Test',
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      iscompleted: false,
      status: 'Pending',
      userId: 3,
    ));

    _items[0].iscompleted = true;
    expect(_items[0].iscompleted, true);
  });

  test('ToDo is removed', () {
    List<Todo> _items = [];
    _items.add(Todo(
      id: UniqueKey().toString(),
      title: 'Test',
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      iscompleted: false,
      status: 'Pending',
      userId: 3,
    ));

    _items.removeLast();
    expect(_items.isEmpty, true);
  });
}
