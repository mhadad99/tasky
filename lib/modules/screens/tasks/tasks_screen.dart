import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_task/models/tasks_model.dart';
import 'package:todo_app_task/modules/cubit/cubit.dart';
import 'package:todo_app_task/modules/cubit/states.dart';
import 'package:todo_app_task/modules/screens/qr_scanner/qr_scanner.dart';
import 'package:todo_app_task/shared/components/components.dart';

import '../../../shared/common_fun/function.dart';
import '../../../shared/network/remote/end_points.dart';
import '../../../shared/styles/colors.dart';
import '../add_task/add_task_screen.dart';
import '../profile/profile_screen.dart';
import '../task_details/task_details_screen.dart';

class TasksScreen extends StatelessWidget {
  final List<String> status = [
    'All',
    'InProgress',
    'Waiting',
    'Finished',
  ];
  bool isSelected = false;
  Key refreshKey = GlobalKey<RefreshIndicatorState>();
  TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => HomeCubit()
          ..initState()
          ..getTasks(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              "Logo",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const ImageIcon(
                  AssetImage(
                    'assets/icons/user.png',
                  ),
                  size: 24,
                ),
                onPressed: () {
                  navigateTo(context, ProfileScreen());
                },
              ),
              IconButton(
                icon: ImageIcon(
                  const AssetImage(
                    'assets/icons/logout.png',
                  ),
                  size: 24,
                  color: defaultColor,
                ),
                onPressed: () {
                  HomeCubit.get(context).signOut(context);
                },
              ),
            ],
          ),
          body: BlocConsumer<HomeCubit, HomeStates>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is GetTasksErrorState) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Something Went Wrong '),
                    TextButton(
                        onPressed: () {
                          HomeCubit.get(context).getTasks();
                        },
                        child: const Text('Try again')),
                  ],
                );
              } else if (state is GetTasksLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return RefreshIndicator(
                  onRefresh: HomeCubit.get(context).getTasks,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('My Tasks',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 50,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => filterIcon(context,
                                label: status[index], index: index),
                            itemCount: status.length,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ConditionalBuilder(
                          condition:
                              HomeCubit.get(context).tasksModel.isNotEmpty,
                          builder: (context) => Expanded(
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller:
                                  HomeCubit.get(context).scrollController,
                              shrinkWrap: true,
                              itemCount:
                                  HomeCubit.get(context).tasksModel.length,
                              itemBuilder: (context, index) {
                                final task =
                                    HomeCubit.get(context).tasksModel[index];
                                return taskCard(context, task: task);
                              },
                            ),
                          ),
                          fallback: (context) => const Center(
                            child: Text(
                              "You Don't Have Any Tasks Right Now\n Try To Add More",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        if (state is GetMoreTasksLoadingState)
                          const Padding(
                            padding: EdgeInsets.all(8),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        if (state is GetMoreTasksErrorState)
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextButton(
                              child: const Text('Try Again'),
                              onPressed: () {
                                HomeCubit.get(context).getTasks();
                              },
                            ),
                          )
                      ],
                    ),
                  ),
                );
              }
            },
          ),
          floatingActionButton: Stack(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  heroTag: 'addTask',
                  onPressed: () {
                    navigateTo(context, AddTaskScreen());
                  },
                  backgroundColor: defaultColor,
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.add,
                    color: textInWidgetsColor,
                    size: 35,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 70.0),
                  child: FloatingActionButton(
                      heroTag: 'qrcode',
                      onPressed: () {
                        navigateTo(context, const QrScanner());
                      },
                      shape: const CircleBorder(),
                      child: ImageIcon(
                        const AssetImage(
                          'assets/icons/qr_code.png',
                        ),
                        size: 24,
                        color: defaultColor,
                      )),
                ),
              ),
            ],
          ),
        ));
  }
}

Widget filterIcon(context, {required String label, required int index}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: ChoiceChip(
      showCheckmark: false,
      label: Text(
        label,
        style: TextStyle(
            color: HomeCubit.get(context).selectedChipIndex == index
                ? Colors.white
                : Colors.black45),
      ),
      selected: HomeCubit.get(context).selectedChipIndex == index,
      onSelected: (bool selected) {
        HomeCubit.get(context)
            .selectFilterChip(selected: selected, index: index);
      },
      //backgroundColor: Colors.grey[300],
      selectedColor: defaultColor,
      shape: const StadiumBorder(
          side: BorderSide(
        style: BorderStyle.none,
      )),
    ),
  );
}

Widget taskCard(context, {required TasksModel task}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            height: 80,
            child: Image.network(
              '$TASK_IMAGE${task.image}',
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
            width: 10,
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                //navigateTo(context, ProfileScreen());

                navigateTo(context, TaskDetailsScreen(id: task.sId!));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          task.title!,
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: getStatusColor(task.status!).withOpacity(.2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6))),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(task.status!),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    task.desc!,
                    style: const TextStyle(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      ImageIcon(
                        const AssetImage(
                          'assets/icons/flag.png',
                        ),
                        size: 20,
                        color: getPriorityColor(task.priority!),
                      ),
                      Text(
                        task.priority!,
                        style:
                            TextStyle(color: getPriorityColor(task.priority!)),
                      ),
                      const Spacer(),
                      Text(
                        formatDateString(task.updatedAt!),
                        style: const TextStyle(color: Colors.grey),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            width: 30,
            alignment: Alignment.topCenter,
            child: PopupMenuButton<String>(
              position: PopupMenuPosition.under,
              icon: const Icon(Icons.more_vert_outlined),
              onSelected: (String result) {
                HomeCubit.get(context).selectOption(
                  context,
                  option: result,
                  id: task.sId!,
                  title: task.title,
                  priority: task.priority,
                  desc: task.desc,
                  dueDate: task.updatedAt,
                  status: task.status,
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
            ),
          )
        ],
      ),
    ),
  );
}
