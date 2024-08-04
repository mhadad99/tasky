part of 'add_task_cubit.dart';

abstract class AddTaskStates {}

class AddTaskInitialState extends AddTaskStates {}

class AddTaskLoadingState extends AddTaskStates {}

class AddTaskSuccessState extends AddTaskStates {}

class AddTaskFailureState extends AddTaskStates {}

class UploadImageLoadingState extends AddTaskStates {}

class UploadImageSuccessState extends AddTaskStates {}

class UploadImageFailureState extends AddTaskStates {}

class ChangeSelectedPriorityState extends AddTaskStates {}
