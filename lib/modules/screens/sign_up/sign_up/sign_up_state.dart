part of 'sign_up_cubit.dart';

abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoadingState extends SignUpState {}

class SignUpSuccessState extends SignUpState {}

class SignUpFailureState extends SignUpState {
  final String error;

  SignUpFailureState(this.error);
}

class ChangePasswordVisibilityState extends SignUpState {}

class ChangeSelectedLevelState extends SignUpState {}
