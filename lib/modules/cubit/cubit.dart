import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_task/models/tasks_model.dart';
import 'package:todo_app_task/modules/cubit/states.dart';
import 'package:todo_app_task/modules/screens/tasks/tasks_screen.dart';
import 'package:todo_app_task/shared/network/remote/end_points.dart';

import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/local/cache.dart';
import '../../shared/network/remote/dio_help.dart';
import '../screens/edit_screen/edit_screen.dart';
import '../screens/login/login_screen.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(InitialGetTasksState());

  static HomeCubit get(context) => BlocProvider.of(context);

  final ScrollController scrollController = ScrollController();

  void initState() {
    scrollController.addListener(loadMorePages);
  }

  bool lastPage = false;
  int page = 2;

  void loadMorePages() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !lastPage) {
      getMoreTasks(pageNum: page);
      page++;
    }
  }

  List<TasksModel> tasksModel = [];

  Future<void> getTasks() async {
    emit(GetTasksLoadingState());
    DioHelp.getData(
      url: GET_TASKS,
    ).then((onValue) {
      lastPage = false;
      page = 2;
      tasksModel = [];
      for (final task in onValue.data) {
        TasksModel.fromJson(task);
        tasksModel.add(TasksModel.fromJson(task));
      }
      emit(GetTasksSuccessState());
    }).catchError((onError) {
      emit(GetTasksErrorState());
    });
  }

  Future<void> getTaskByStatus({required String status}) async {
    emit(GetTasksLoadingState());
    DioHelp.getData(url: '/todos?status=$status').then((onValue) {
      lastPage = false;
      page = 2;
      tasksModel = [];
      for (final task in onValue.data) {
        TasksModel.fromJson(task);
        tasksModel.add(TasksModel.fromJson(task));
      }
      emit(GetTasksSuccessState());
    }).catchError((onError) {
      emit(GetTasksErrorState());
    });
  }

  Future<void> getMoreTasks({required int pageNum}) async {
    emit(GetMoreTasksLoadingState());
    DioHelp.getData(
      url: '/todos?page=$pageNum',
    ).then((onValue) {
      int lengthBeforeLoading = tasksModel.length;
      for (final task in onValue.data) {
        TasksModel.fromJson(task);
        tasksModel.add(TasksModel.fromJson(task));
      }
      lastPage = (lengthBeforeLoading == tasksModel.length);
      emit(GetMoreTasksSuccessState());
    }).catchError((onError) {
      emit(GetMoreTasksErrorState());
    });
  }

  // bool isSelected = false;
  // void selectFilterChip(
  //   context, {
  //   required String label,
  //   required bool selected,
  // }) {
  //   isSelected = selected;
  //   if (label == 'All') {
  //     getTasks();
  //   } else if (label == 'Waiting') {
  //     getTaskByStatus(status: 'waiting');
  //   } else if (label == 'InProgress') {
  //     getTaskByStatus(status: 'inProgress');
  //   } else if (label == 'Finished') {
  //     getTaskByStatus(status: 'finished');
  //   }
  //   emit(SelectChipFilter());
  // }

  int selectedChipIndex = 0;

  void selectFilterChip({required bool selected, required int index}) {
    selectedChipIndex = (selected ? index : null)!;
    if (index == 0) {
      getTasks();
    } else if (index == 2) {
      getTaskByStatus(status: 'waiting');
    } else if (index == 1) {
      getTaskByStatus(status: 'inProgress');
    } else if (index == 3) {
      getTaskByStatus(status: 'finished');
    }
    emit(SelectChipFilter());
  }

  void signOut(context) {
    DioHelp.postData(
      url: LOGOUT,
      data: {'refresh_token': refreshToken},
    ).then(
      (value) {
        CacheHelper.removeData(key: 'access_token').then((value) {
          accessToken = '';
        });
        CacheHelper.removeData(key: 'refresh_token').then((value) {
          refreshToken = '';
        });

        navigateAndFinish(context, LoginScreen());
        showToast(text: 'You are Logout', state: ToastState.SUCCESS);
      },
    ).catchError((onError) {
      CacheHelper.removeData(key: 'access_token').then((value) {
        accessToken = '';
      });
      CacheHelper.removeData(key: 'refresh_token').then((value) {
        refreshToken = '';
      }).then((onValue) {
        navigateAndFinish(context, LoginScreen());
        showToast(
            text: 'You are Logout, Try Login Again ',
            state: ToastState.WARNING);
      });
    });
  }

  TasksModel? taskModel;
  Future<void> getTask(id) async {
    emit(TaskDetailsLoading());
    DioHelp.getData(
      url: '$GET_ONE$id',
    ).then((onValue) {
      taskModel = TasksModel.fromJson(onValue.data);
      emit(TaskDetailsSuccess());
    }).catchError((onError) {
      emit(TaskDetailsFailure(onError.toString()));
    });
  }

  Future<void> deleteTask(context, {required id}) async {
    try {
      DioHelp.deleteData(url: '$DELETE$id').then((onValue) {
        navigateAndFinish(context, TasksScreen());
      });
    } on Exception catch (e) {
      print(e.toString());
      // TODO
    }
  }

  void selectOption(
    context, {
    required String option,
    required String id,
    String? title,
    String? desc,
    String? status,
    String? priority,
    String? dueDate,
  }) {
    if (option == 'delete') {
      deleteTask(context, id: id);
    }
    if (option == 'edit') {
      setPriorityAndStatus(priority: priority!, status: status!);

      navigateTo(
          context,
          EditScreen(
            id: id,
            title: title!,
            desc: desc!,
            dueDate: dueDate!,
            priority: priority,
            status: status,
          ));
    }
  }

  Future<void> editTask({id, title, desc, dueDate}) async {
    DioHelp.putData(url: '$GET_ONE$id', data: {
      "title": title,
      "desc": desc,
      "priority": selectedPriority, //low , medium , high
      "status": selectedStatus,
      "dueDate": dueDate,
    }).then((onValue) {
      taskModel = TasksModel.fromJson(onValue.data);
    }).catchError((onError) {});
  }

  String selectedPriority = 'medium';
  String selectedStatus = 'waiting';

  void setPriorityAndStatus(
      {required String priority, required String status}) {
    selectedStatus = status;
    selectedPriority = priority;
  }

  List<String> priorityList = ['high', 'medium', 'low'];

  void selectPriority(value) {
    selectedPriority = value;
    emit(ChangeSelectedDropState());
  }

  List<String> statusList = ['waiting', 'inProgress', 'finished'];

  void selectStatus(value) {
    selectedStatus = value;
    emit(ChangeSelectedDropState());
  }
}
