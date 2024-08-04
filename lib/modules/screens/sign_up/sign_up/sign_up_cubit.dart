import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/login_model.dart';
import '../../../../shared/components/constants.dart';
import '../../../../shared/network/local/cache.dart';
import '../../../../shared/network/remote/dio_help.dart';
import '../../../../shared/network/remote/end_points.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  static SignUpCubit get(context) => BlocProvider.of(context);

  LoginModel? loginModel;

  void userRegister({
    required phone,
    required password,
    required displayName,
    required experienceYears,
    required address,
    required level,
  }) {
    emit(SignUpLoadingState());
    DioHelp.postData(
      url: REGISTER,
      data: {
        'phone': phone,
        'password': password,
        'displayName': displayName,
        'experienceYears': experienceYears,
        'address': address,
        'level': level,
      },
    ).then((onValue) {
      loginModel = LoginModel.fromJson(onValue.data);
      accessToken = loginModel!.accessToken!;
      refreshToken = loginModel!.refreshToken!;
      CacheHelper.saveData(key: 'access_token', value: accessToken);
      CacheHelper.saveData(key: 'refresh_token', value: refreshToken);
      CacheHelper.saveData(key: '_id', value: loginModel!.sId);
      emit(SignUpSuccessState());
    }).catchError((onError) {
      emit(SignUpFailureState(onError.toString()));
    });
  }

  String? selectedLevel;
  List experienceLevels = ['fresh', 'junior', 'midLevel', 'senior'];

  void selectLevel(value) {
    selectedLevel = value;
    emit(ChangeSelectedLevelState());
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
