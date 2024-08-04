abstract class HomeStates {}

class InitialGetTasksState extends HomeStates {}

class GetTasksLoadingState extends HomeStates {}

class GetTasksSuccessState extends HomeStates {}

class GetTasksErrorState extends HomeStates {}

class GetMoreTasksLoadingState extends HomeStates {}

class GetMoreTasksSuccessState extends HomeStates {}

class GetMoreTasksErrorState extends HomeStates {}

class SelectChipFilter extends HomeStates {}

class ScannedQRCodeState extends HomeStates {}

class ScannedQRCodeSuccessState extends HomeStates {}

class TaskDetailsLoading extends HomeStates {}

class TaskDetailsSuccess extends HomeStates {}

class TaskDetailsFailure extends HomeStates {
  final String error;

  TaskDetailsFailure(this.error);
}

class ChangeSelectedDropState extends HomeStates {}

// class ChangeSelectedPriorityState extends HomeStates {}
//
// class ChangeSelectedPriorityState extends HomeStates {}
//
// class ChangeSelectedPriorityState extends HomeStates {}
