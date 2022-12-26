import 'package:etiqa/blocs/export_bloc.dart';
import 'package:etiqa/repositories/repositories.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../helpers/constants.dart';
import '../../helpers/style.dart';
import '../../models/todos_model.dart';
import '../../models/user_model.dart';
import '../../widgets/illustration.dart';
import 'deletetodo_popup.dart';
import 'todo_card.dart';
import 'todo_form_view.dart';

class TodoPage extends StatelessWidget {
  final User user;
  const TodoPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TodoBloc todoBloc = TodoBloc(todoRepository: context.read<TodoRepository>())
      ..add(InitializedTodo(userId: user.userId));

    return BlocProvider(
      create: (context) => todoBloc,
      child: TodoView(user: user),
    );
  }
}

class TodoView extends StatefulWidget {
  final User user;
  const TodoView({Key? key, required this.user}) : super(key: key);

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  final List<Todo> _items = [];
  // The key of the list
  final GlobalKey<AnimatedListState> _key = GlobalKey();

  void _addItem(Todo thistodo) {
    bool alreadyin = _items.any(
      (element) => element.id.contains(thistodo.id),
    );
    if (kDebugMode) {
      print("alreadyin $alreadyin");
    }
    if (!alreadyin) {
      _items.insert(_items.length, thistodo);
      if (mounted) {
        _key.currentState!.insertItem(_items.length - 1,
            duration: const Duration(seconds: 1));
      }
    }
  }

  void _updateItem(int index, Todo thistodo) {
    _items.insert(index, thistodo);
    if (mounted) {
      _key.currentState!
          .insertItem(index, duration: const Duration(seconds: 1));
    }
  }

  void _removeItem(int index) {
    if (mounted) {
      _key.currentState!.removeItem(index, (_, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            child: SizedBox(
              height: 150,
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 20),
                elevation: 10,
                color: Colors.red[400],
                child: const Center(
                  child:
                      Text("I am going away", style: TextStyle(fontSize: 28)),
                ),
              ),
            ),
          ),
        );
      }, duration: const Duration(seconds: 1));
      _items.removeAt(index);
    }
  }

  void _clearAllItems() {
    for (var i = 0; i <= _items.length - 1; i++) {
      _key.currentState?.removeItem(0,
          (BuildContext context, Animation<double> animation) {
        return Container();
      });
    }
    _items.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackground,
      appBar: AppBar(
        title: const Text("To-Do List"),
        backgroundColor: kprimarytheme,
        actions: const <Widget>[],
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (state is TodoLoaded) {
            state.todoList.listen((element) {
              for (var changes in element.docChanges) {
                if (changes.type == DocumentChangeType.added) {
                  Todo newtodo = Todo.fromDatabaseJson(changes.doc.data()!);
                  _addItem(newtodo);
                } else if (changes.type == DocumentChangeType.modified) {
                  Todo newtodo = Todo.fromDatabaseJson(changes.doc.data()!);
                  int index =
                      _items.indexWhere((item) => item.id.contains(newtodo.id));
                  _removeItem(index);
                  _updateItem(index, newtodo);
                } else if (changes.type == DocumentChangeType.removed) {
                  Todo newtodo = Todo.fromDatabaseJson(changes.doc.data()!);
                  int index =
                      _items.indexWhere((item) => item.id.contains(newtodo.id));
                  _removeItem(index);
                }
              }
            });
            return Container(
                margin: EdgeInsets.only(bottom: Constants.height * 0.005),
                child: RefreshIndicator(
                  onRefresh: () async {
                    _clearAllItems();
                    context
                        .read<TodoBloc>()
                        .add(InitializedTodo(userId: widget.user.userId));
                  },
                  child: AnimatedList(
                    key: _key,
                    initialItemCount: _items.length,
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index, animation) {
                      return Column(
                        children: [
                          SlideTransition(
                            key: UniqueKey(),
                            position: Tween<Offset>(
                              begin: const Offset(-1, -0.5),
                              end: const Offset(0, 0),
                            ).animate(animation),
                            child: SizeTransition(
                              axis: Axis.vertical,
                              sizeFactor: animation,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                child: ToDoCard(
                                  title: _items[index].title ?? '',
                                  endDate:
                                      _items[index].endDate ?? DateTime.now(),
                                  startDate:
                                      _items[index].startDate ?? DateTime.now(),
                                  checkBoxValue: _items[index].iscompleted,
                                  onTap: () {
                                    print("ontap ${_items[index].id}");
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) => ToDoFormView(
                                                  user: widget.user,
                                                  todo: _items[index],
                                                )));
                                  },
                                  onChanged: (bool? value) {
                                    context.read<TodoBloc>().add(SettoCompleted(
                                        todo: _items[index],
                                        isCompleted: value!));
                                  },
                                  onTrash: () {
                                    showdeleteConfirm(
                                        todo: _items[index], context: context);
                                  },
                                ),
                              ),
                            ),
                          ),
                          if (index == _items.length - 1) ...[
                            SizedBox(
                              height: Constants.height * 0.2,
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ));
          } else if (state is TodoError) {
            return Center(
              child: Text(state.error),
            );
          }
          return const ToDoIllustration();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kprimarytheme,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ToDoFormView(
                user: widget.user,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
