import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/login_model.dart';
import '../../../../shared/network/remote/dio_help.dart';
import '../../../../shared/network/remote/end_points.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());
  static LoginCubit get(context) => BlocProvider.of(context);

  LoginModel? loginModel;
  Future<void> userLogin({
    required phone,
    required password,
  }) async {
    emit(LoginLoadingState());
    try {
      Response response = await DioHelp.postData(
        url: LOGIN,
        data: {
          'phone': phone,
          'password': password,
        },
      );
      loginModel = LoginModel.fromJson(response.data);
      emit(LoginSuccessState());
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        emit(LoginFailureState('Check Your Phone and Password '));
      } else if (e.type == DioExceptionType.connectionError) {
        emit(LoginFailureState('Check Your Internet '));
      }
    } catch (e) {
      emit(LoginFailureState('Something Went Wrong Try Again'));
    }
  }

  IconData suffix = Icons.remove_red_eye_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ChangePasswordVisibilityState());
  }
}
