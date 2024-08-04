// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:todo_app_task/modules/screens/edit_screen/edit_screen.dart';
// import 'package:todo_app_task/shared/components/components.dart';
// import 'package:todo_app_task/shared/components/constants.dart';
//
// import '../../../../models/one_task_model.dart';
// import '../../../../shared/network/remote/dio_help.dart';
// import '../../../../shared/network/remote/end_points.dart';
//
// part 'task_details_state.dart';
//
// class TaskDetailsCubit extends Cubit<TaskDetailsStates> {
//   TaskDetailsCubit() : super(TaskDetailsInitial());
//
//   static TaskDetailsCubit get(context) =>
//       BlocProvider.of<TaskDetailsCubit>(context);
//
//   OneTaskModel? oneTaskModel;
//   Future<void> getTask(id) async {
//     print(id);
//     print(accessToken);
//     emit(TaskDetailsLoading());
//     DioHelp.getData(
//       url: '$GET_ONE$id',
//     ).then((onValue) {
//       oneTaskModel = OneTaskModel.fromJson(onValue.data);
//       emit(TaskDetailsSuccess());
//     }).catchError((onError) {
//       emit(TaskDetailsFailure(onError.toString()));
//     });
//   }
//
//   Future<void> deleteTask(context, {required id}) async {
//     try {
//       DioHelp.deleteData(url: '$DELETE$id');
//       Navigator.pop(context);
//     } on Exception catch (e) {
//       print(e.toString());
//       // TODO
//     }
//   }
//
//   void selectOption(context, String option, String id) {
//     if (option == 'delete') {
//       deleteTask(context, id: id);
//     }
//     if (option == 'edit') {
//       navigateTo(context, EditScreen());
//     }
//   }
// }
