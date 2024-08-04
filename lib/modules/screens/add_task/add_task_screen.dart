import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_task/modules/cubit/cubit.dart';
import 'package:todo_app_task/modules/screens/add_task/add_task_cubit/add_task_cubit.dart';
import 'package:todo_app_task/modules/screens/tasks/tasks_screen.dart';
import 'package:todo_app_task/shared/components/components.dart';

import '../../../shared/styles/colors.dart';

class AddTaskScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  TextEditingController dateController = TextEditingController();

  String priority = 'medium';

  AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddTaskCubit(),
      child: BlocConsumer<AddTaskCubit, AddTaskStates>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              leading: IconButton(
                icon: leadingIcon(),
                onPressed: () {
                  navigateAndFinish(context, TasksScreen());
                },
              ),
              title: const Text("Add New Task"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: defaultDotBox(function: () {
                          AddTaskCubit.get(context).pickAndUploadImage();
                        }),
                      ),
                      if (state is UploadImageLoadingState)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: LinearProgressIndicator(),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Task Title',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      defaultFormField(
                        controller: titleController,
                        type: TextInputType.text,
                        validate: (onValue) {
                          if (onValue.isEmpty) {
                            return "Please Enter The Title.";
                          }
                        },
                        hint: 'Enter Title Here',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Task Description',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      defaultFormField(
                        maxLines: 8,
                        controller: descriptionController,
                        type: TextInputType.text,
                        validate: (onValue) {
                          if (onValue.isEmpty) {
                            return "Please Enter Description.";
                          }
                        },
                        hint: 'Enter Description Here.....',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Priority',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      defaultDropDown(
                        onChanged: (s) {
                          AddTaskCubit.get(context).selectPriority(s);
                        },
                        value: AddTaskCubit.get(context).selectedPriority,
                        items: AddTaskCubit.get(context).priorityList,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Due '
                        'date',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      defaultFormField(
                        readonly: true,
                        controller: dateController,
                        type: TextInputType.none,
                        validate: (onValue) {
                          if (onValue.isEmpty) {
                            return "Please Enter The Date.";
                          }
                        },
                        suffix: ImageIcon(
                          AssetImage(
                            'assets/icons/calendar.png',
                          ),
                          size: 24,
                          color: defaultColor,
                        ),
                        suffixPressed: () {
                          showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2101))
                              .then((onValue) {
                            dateController.text =
                                DateFormat.yMMMd().format(onValue!);
                          }).catchError((onError) {
                            dateController.text = '';
                          });
                        },
                        hint: 'Choose due date',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultToDoButton(
                        context,
                        text: "Add Task",
                        function: () {
                          if (formKey.currentState!.validate()) {
                            AddTaskCubit.get(context).createTask(
                              context,
                              title: titleController.text,
                              desc: descriptionController.text,
                              dueDate: dateController.text,
                            );
                            HomeCubit.get(context).getTasks();
                            navigateAndFinish(context, TasksScreen());
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
