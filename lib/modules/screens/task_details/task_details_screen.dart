import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:todo_app_task/models/tasks_model.dart';
import 'package:todo_app_task/modules/cubit/cubit.dart';
import 'package:todo_app_task/modules/cubit/states.dart';
import 'package:todo_app_task/shared/common_fun/function.dart';

import '../../../shared/components/components.dart';
import '../../../shared/network/remote/end_points.dart';
import '../../../shared/styles/colors.dart';
import '../tasks/tasks_screen.dart';

class TaskDetailsScreen extends StatelessWidget {
  String id;
  TaskDetailsScreen({super.key, required this.id});
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    HomeCubit.get(context).getTask(id);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: leadingIcon(),
          onPressed: () {
            navigateAndFinish(context, TasksScreen());
          },
        ),
        title: const Text('Task Details'),
        actions: [
          BlocBuilder<HomeCubit, HomeStates>(
            builder: (context, state) {
              TasksModel? taskModel = HomeCubit.get(context).taskModel;
              return PopupMenuButton<String>(
                position: PopupMenuPosition.under,
                icon: const Icon(Icons.more_vert_outlined),
                onSelected: (String result) {
                  HomeCubit.get(context).selectOption(
                    context,
                    option: result,
                    id: id,
                    title: taskModel!.title,
                    priority: taskModel.priority,
                    desc: taskModel.desc,
                    dueDate: taskModel.updatedAt,
                    status: taskModel.status,
                  );
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeStates>(
        builder: (context, state) {
          var cubit = HomeCubit.get(context);
          print(cubit.taskModel?.image);
          if (state is TaskDetailsSuccess) {
            print(cubit.taskModel?.image);

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: Image.network(
                        '$TASK_IMAGE${HomeCubit.get(context).taskModel!.image}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/default_todo.jpeg',
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      cubit.taskModel!.title!,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      cubit.taskModel!.desc!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    dataPreviewFiled(
                        title: 'End Date',
                        icon: IconButton(
                            onPressed: () {},
                            icon: ImageIcon(
                              const AssetImage(
                                'assets/icons/calendar.png',
                              ),
                              size: 24,
                              color: defaultColor,
                            )),
                        value: formatDateString(cubit.taskModel!.updatedAt!)),
                    dataPreviewFiled(
                      title: 'Status',
                      textColor: defaultColor,
                      value: cubit.taskModel!.status!,
                    ),
                    dataPreviewFiled(
                      title: 'Priority',
                      preIcon: ImageIcon(
                        const AssetImage(
                          'assets/icons/flag.png',
                        ),
                        size: 20,
                        color: defaultColor,
                      ),
                      textColor: defaultColor,
                      value: cubit.taskModel!.priority!,
                    ),
                    QrImageView(
                      data: cubit.taskModel!.sId!,
                      version: QrVersions.auto,
                      padding: const EdgeInsets.all(20),
                      errorStateBuilder: (cxt, err) {
                        return const Center(
                          child: Text(
                            'Uh oh! Something went wrong...',
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            );
          } else if (state is TaskDetailsFailure) {
            return Center(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Something Went Wrong'),
                  TextButton(
                      onPressed: () {
                        cubit.getTask(id);
                      },
                      child: const Text('Try Again'))
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
