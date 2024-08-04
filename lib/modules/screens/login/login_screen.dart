import 'package:country_phone_validator/country_phone_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_task/modules/cubit/cubit.dart';
import 'package:todo_app_task/modules/screens/tasks/tasks_screen.dart';
import 'package:todo_app_task/shared/components/components.dart';
import 'package:todo_app_task/shared/network/local/cache.dart';

import '../../../shared/styles/colors.dart';
import '../sign_up/sign_up_screen.dart';
import 'cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dialController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Image(
                        image: AssetImage(
                          "assets/images/login_image.png",
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Login",
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      defaultNumberField(
                          controller: phoneController,
                          dialController: dialController),
                      const SizedBox(
                        height: 10,
                      ),
                      defaultFormField(
                        controller: passwordController,
                        type: TextInputType.visiblePassword,
                        validate: (onValue) {
                          if (onValue.isEmpty) {
                            return "Please Enter Your Password.";
                          }
                        },
                        hint: 'Password...',
                        suffix: cubit.isPassword
                            ? ImageIcon(
                                const AssetImage(
                                  'assets/icons/eye.png',
                                ),
                                size: 20,
                                color: defaultColor,
                              )
                            : ImageIcon(
                                const AssetImage(
                                  'assets/icons/eye_off.png',
                                ),
                                size: 20,
                                color: defaultColor,
                              ),
                        suffixPressed: () {
                          cubit.changePasswordVisibility();
                        },
                        isPassword: cubit.isPassword,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (!isLoading)
                        defaultToDoButton(
                          context,
                          isButtonLoading: isLoading,
                          text: 'Sign In',
                          function: () {
                            if (formKey.currentState!.validate()) {
                              if (CountryUtils.validatePhoneNumber(
                                  phoneController.text
                                      .replaceAll(dialController.text, ''),
                                  dialController.text)) {
                                cubit.userLogin(
                                    phone: phoneController.text,
                                    password: passwordController.text);
                              } else {
                                showToast(
                                    text: 'Invalid Phone Number',
                                    state: ToastState.ERROR);
                              }
                            } else {
                              showToast(
                                  text: 'Invalid Input',
                                  state: ToastState.ERROR);
                            }
                          },
                        ),
                      if (isLoading)
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Didn't have any account?"),
                          TextButton(
                            onPressed: () {
                              navigateAndFinish(context, SignUpScreen());
                            },
                            child: Text(
                              "Sing Up here",
                              style: TextStyle(color: defaultColor),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is LoginSuccessState) {
            CacheHelper.saveData(
                key: 'access_token',
                value: LoginCubit.get(context).loginModel!.accessToken);
            CacheHelper.saveData(
                    key: 'refresh_token',
                    value: LoginCubit.get(context).loginModel!.refreshToken)
                .then((onValue) {
              navigateAndFinish(context, TasksScreen());
              showToast(
                  text: 'You Logged in Successfully',
                  state: ToastState.SUCCESS);
              HomeCubit.get(context).getTasks();
              isLoading = false;
            });
          } else if (state is LoginFailureState) {
            isLoading = false;
            showToast(text: state.error, state: ToastState.ERROR);
          }
          if (state is LoginLoadingState) {
            isLoading = true;
          }
        },
      ),
    );
  }
}
