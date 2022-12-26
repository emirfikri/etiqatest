import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/todos_model.dart';

class TodoRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<String> getTodoId() async {
    var data = await _firestore
        .collection('todo')
        .orderBy('id', descending: true)
        .limit(1)
        .get();
    int id = 1;
    if (data.docs.isNotEmpty) {
      id = int.parse(data.docs[0].get('id')) + 1;
    }
    return id.toString();
  }

  Future getTodowithId({required String todoId}) {
    return _firestore
        .collection('todo')
        .where('id', isEqualTo: todoId)
        .limit(1)
        .get();
  }

  Stream getTodoList({required int userId}) {
    return _firestore
        .collection('todo')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  Future<void> addTodo({required Todo todo}) async {
    await _firestore.collection('todo').doc(todo.id).set(todo.toDatabaseJson());
  }

  Future<void> updateTodo(
      {required String todoid, required Map<String, Object?> data}) async {
    await _firestore.collection('todo').doc(todoid).update(data);
  }

  Future<void> deleteTodo({required String todoid}) async {
    await _firestore.collection('todo').doc(todoid).delete();
    await _firestore.collection('todo').doc(todoid).delete();
  }
}
