import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_app_task/models/tasks_model.dart';
import 'package:todo_app_task/shared/components/components.dart';
import 'package:todo_app_task/shared/components/constants.dart';
import 'package:todo_app_task/shared/network/remote/dio_help.dart';

import '../../../../shared/network/remote/end_points.dart';

part 'add_task_state.dart';

class AddTaskCubit extends Cubit<AddTaskStates> {
  AddTaskCubit() : super(AddTaskInitialState());

  static AddTaskCubit get(context) => BlocProvider.of(context);

  TasksModel? tasksModel;
  String? imageURL;

  Future<XFile?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(source: ImageSource.gallery);
  }

  Future<void> pickAndUploadImage() async {
    XFile? image = await pickImage();
    if (image != null) {
      try {
        emit(UploadImageLoadingState());
        await DioHelp.uploadImage(image).then((onValue) {
          imageURL = onValue.data['image'];
          showToast(
              text: 'Image Uploaded Successfully', state: ToastState.SUCCESS);
          emit(UploadImageSuccessState());
        });
      } on DioException catch (e) {
        if (e.type == DioExceptionType.badResponse) {
          showToast(text: 'Try With Another Image.', state: ToastState.WARNING);
          emit(UploadImageFailureState());
        } else if (e.type == DioExceptionType.connectionError) {
          showToast(text: 'Check Your Internet.', state: ToastState.WARNING);
          emit(UploadImageFailureState());
        }
      } catch (e) {
        showToast(
            text: 'Something Went Wrong, Try Again.',
            state: ToastState.WARNING);
        emit(UploadImageFailureState());
      }
    } else {
      showToast(text: 'No Image Selected', state: ToastState.WARNING);
      emit(UploadImageFailureState());
    }
  }

  String selectedPriority = 'medium';
  List<String> priorityList = ['high', 'medium', 'low'];

  void selectPriority(value) {
    selectedPriority = value;
    emit(ChangeSelectedPriorityState());
  }

  void createTask(context,
      {required title, required desc, required dueDate}) async {
    DioHelp.postData(url: CREATE, data: {
      "image": imageURL ?? defaultImage,
      "title": title,
      "desc": desc,
      "priority": selectedPriority, //low , medium , high
      "dueDate": dueDate,
    });
  }
}
