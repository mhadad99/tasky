part of 'login_cubit.dart';

@immutable
abstract class LoginStates {}

final class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {}

class LoginFailureState extends LoginStates {
  final String error;

  LoginFailureState(this.error);
}

class ChangePasswordVisibilityState extends LoginStates {}
