import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/user_model.dart';
import '../../../../shared/network/remote/dio_help.dart';
import '../../../../shared/network/remote/end_points.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit() : super(ProfileInitialState());

  static ProfileCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;
  void getUserData() {
    emit(ProfileLoadingState());
    DioHelp.getData(url: GET_PROFILE).then((onValue) {
      userModel = UserModel.fromJson(onValue.data);
      emit(ProfileSuccessState());
    }).catchError((onError) {
      emit(ProfileFailureState());
    });
  }
}
