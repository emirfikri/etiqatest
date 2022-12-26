import 'package:etiqa/blocs/export_bloc.dart';
import 'package:etiqa/models/todos_model.dart';
import 'package:etiqa/models/user_model.dart';
import 'package:flutter/material.dart';

import '../../helpers/style.dart';
import 'todo_form_field.dart';

class ToDoFormView extends StatelessWidget {
  final User user;
  final Todo? todo;
  ToDoFormView({Key? key, required this.user, this.todo}) : super(key: key);

  final TextEditingController titleController = TextEditingController();
  final TextEditingController startdateController = TextEditingController();
  final TextEditingController enddateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (todo != null) {
      titleController.text = todo!.title;
      startdateController.text = todo!.startDate.toString().split(' ')[0];
      enddateController.text = todo!.endDate.toString().split(' ')[0];
    }
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kprimarytheme,
          titleSpacing: 0,
          automaticallyImplyLeading: true,
          title: const Text('Add new To-Do List'),
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.keyboard_arrow_left_sharp, size: 30),
          ),
        ),
        body: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            children: <Widget>[
              ToDoFormField(
                label: 'To-Do Title',
                hintText: 'Please key in your To-Do title',
                maxLines: 6,
                controller: titleController,
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please input title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ToDoFormField(
                label: 'Start Date',
                hintText: 'Select a date',
                controller: startdateController,
                onChanged: (value) {
                  print("value== $value");
                },
                validator: (String? value) {
                  if (value != '' && value != null) {
                    DateTime startdate =
                        DateTime.parse(startdateController.text);
                    DateTime enddate = DateTime.parse(enddateController.text);
                    if (startdate.isAfter(enddate)) {
                      return "start date must be before end date";
                    }
                    return null;
                  } else {
                    return "Please select start date";
                  }
                },
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                    currentDate: DateTime.now(),
                  );
                  if (picked != null && picked != '') {
                    var date = picked.toString().split(' ')[0];
                    startdateController.text = date;
                  }
                },
              ),
              const SizedBox(height: 20),
              ToDoFormField(
                label: 'Estimate End Date',
                hintText: 'Select a date',
                controller: enddateController,
                onChanged: (value) {
                  print("value== $value");
                },
                validator: (String? value) {
                  if (value != '' && value != null) {
                    DateTime startdate =
                        DateTime.parse(startdateController.text);
                    DateTime enddate = DateTime.parse(enddateController.text);
                    if (startdate.isAfter(enddate)) {
                      return "End date must be after start date";
                    }
                    return null;
                  } else {
                    return "Please select end date";
                  }
                },
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                    currentDate: DateTime.now(),
                  );
                  if (picked != null && picked != '') {
                    var date = picked.toString().split(' ')[0];
                    enddateController.text = date;
                  }
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () {
            if (formKey.currentState!.validate()) {
              if (todo != null) {
                Todo newtodo = todo!.copyWith(
                    title: titleController.text,
                    startDate: DateTime.parse(startdateController.text),
                    endDate: DateTime.parse(enddateController.text));
                context.read<TodoBloc>().add(UpdateTodo(todo: newtodo));
              } else {
                context.read<TodoBloc>().add(AddedNewTodo(
                    userId: user.userId,
                    title: titleController.text,
                    enddate: enddateController.text,
                    startdate: startdateController.text));
              }
              Navigator.pop(context);
            }
          },
          child: Container(
            height: 65,
            width: double.infinity,
            color: Colors.black,
            alignment: Alignment.center,
            child: Text(todo != null ? 'Update' : 'Create',
                style: const TextStyle(color: Colors.white, fontSize: 20)),
          ),
        ),
      ),
    );
  }
}
