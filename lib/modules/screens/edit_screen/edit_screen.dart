import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_task/modules/cubit/cubit.dart';
import 'package:todo_app_task/modules/cubit/states.dart';
import 'package:todo_app_task/modules/screens/tasks/tasks_screen.dart';
import 'package:todo_app_task/shared/common_fun/function.dart';

import '../../../shared/components/components.dart';
import '../../../shared/styles/colors.dart';

class EditScreen extends StatelessWidget {
  String id;
  String title;
  String desc;
  String priority;
  String status;
  String dueDate;
  EditScreen({
    super.key,
    required this.id,
    required this.title,
    required this.desc,
    required this.priority,
    required this.status,
    required this.dueDate,
  });

  var formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = title;
    descriptionController.text = desc;
    dateController.text = formatDateString(dueDate);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Task"),
      ),
      body: BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        HomeCubit.get(context).selectPriority(s);
                      },
                      value: HomeCubit.get(context).selectedPriority,
                      items: HomeCubit.get(context).priorityList,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Status',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    defaultDropDown(
                      onChanged: (s) {
                        HomeCubit.get(context).selectStatus(s);
                      },
                      value: HomeCubit.get(context).selectedStatus!,
                      items: HomeCubit.get(context).statusList,
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
                        const AssetImage(
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
                        });
                      },
                      hint: 'Choose due date',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    defaultToDoButton(
                      context,
                      text: "Edit Task",
                      function: () {
                        if (formKey.currentState!.validate()) {
                          HomeCubit.get(context).editTask(
                            id: id,
                            title: titleController.text,
                            desc: descriptionController.text,
                            dueDate: dateController.text,
                          );
                          HomeCubit.get(context).getTask(id);
                          navigateAndFinish(context, TasksScreen());
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
