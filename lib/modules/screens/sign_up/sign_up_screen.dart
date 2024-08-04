import 'package:country_phone_validator/country_phone_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_task/modules/screens/sign_up/sign_up/sign_up_cubit.dart';

import '../../../models/login_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/network/local/cache.dart';
import '../../../shared/styles/colors.dart';
import '../../cubit/cubit.dart';
import '../login/login_screen.dart';
import '../tasks/tasks_screen.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  var formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController yearsOfExperienceController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dialController = TextEditingController();
  bool isLoading = false;
  LoginModel? loginModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: BlocConsumer<SignUpCubit, SignUpState>(
        builder: (context, state) {
          var cubit = SignUpCubit.get(context);

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
                      const Center(
                        child: Image(
                          image: AssetImage(
                            "assets/images/login_image.png",
                          ),
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Sign Up",
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      defaultFormField(
                        controller: nameController,
                        type: TextInputType.name,
                        validate: (onValue) {
                          if (onValue.isEmpty) {
                            return "Please Enter Your Name.";
                          }
                        },
                        hint: 'Name...',
                        onChanged: (String value) {
                          value = nameController.value.toString();
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      defaultNumberField(
                          controller: phoneController,
                          dialController: dialController),
                      const SizedBox(
                        height: 15,
                      ),
                      defaultFormField(
                        controller: yearsOfExperienceController,
                        type: TextInputType.number,
                        validate: (onValue) {
                          if (onValue.isEmpty) {
                            return "Please Enter Your Years Of Experience.";
                          }
                        },
                        hint: 'Years of experience...',
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          underline: Container(
                            width: 0,
                          ),
                          value: cubit.selectedLevel,
                          hint: const Text("Choose Experience Level"),
                          items: cubit.experienceLevels
                              .map((level) => DropdownMenuItem<String>(
                                    value: level,
                                    child: Text(level),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            cubit.selectLevel(value);
                          },
                          icon: const Icon(Icons.keyboard_arrow_down_outlined),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      defaultFormField(
                        controller: addressController,
                        type: TextInputType.streetAddress,
                        validate: (onValue) {
                          if (onValue.isEmpty) {
                            return "Please Enter Your Address.";
                          }
                        },
                        hint: 'Address...',
                      ),
                      const SizedBox(
                        height: 15,
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
                          isPassword: cubit.isPassword,
                          suffix: cubit.isPassword
                              ? const ImageIcon(
                                  AssetImage(
                                    'assets/icons/eye.png',
                                  ),
                                  size: 20,
                                  color: Colors.grey,
                                )
                              // ignore: prefer_const_constructors
                              : ImageIcon(
                                  const AssetImage(
                                    'assets/icons/eye_off.png',
                                  ),
                                  size: 20,
                                  color: Colors.grey,
                                ),
                          suffixPressed: () {
                            cubit.changePasswordVisibility();
                          }),
                      const SizedBox(height: 20),
                      if (isLoading)
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                      if (!isLoading)
                        defaultToDoButton(context, text: 'Sign Up',
                            function: () {
                          if (formKey.currentState!.validate() &&
                              cubit.selectedLevel != null) {
                            if (CountryUtils.validatePhoneNumber(
                                phoneController.text
                                    .replaceAll(dialController.text, ''),
                                dialController.text)) {
                              cubit.userRegister(
                                phone: phoneController.text,
                                password: passwordController.text,
                                displayName: nameController.text,
                                experienceYears:
                                    yearsOfExperienceController.text,
                                address: addressController.text,
                                level: cubit.selectedLevel,
                              );
                            } else {
                              showToast(
                                  text: 'Invalid Phone Number',
                                  state: ToastState.ERROR);
                            }
                          } else if (cubit.selectedLevel != null) {
                            showToast(
                                text: 'Please Select Your Level',
                                state: ToastState.ERROR);
                          } else {
                            showToast(
                                text: 'Invalid Input', state: ToastState.ERROR);
                          }
                        }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have any account?"),
                          TextButton(
                            onPressed: () {
                              navigateAndFinish(context, LoginScreen());
                            },
                            child: Text(
                              "Sign In",
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
          if (state is SignUpSuccessState) {
            CacheHelper.saveData(
                key: 'access_token',
                value: SignUpCubit.get(context).loginModel!.accessToken);
            CacheHelper.saveData(
                    key: 'refresh_token',
                    value: SignUpCubit.get(context).loginModel!.refreshToken)
                .then((onValue) {
              navigateAndFinish(context, TasksScreen());
              showToast(
                  text: 'You Logged in Successfully',
                  state: ToastState.SUCCESS);
              HomeCubit.get(context).getTasks();
              isLoading = false;
            });
          } else if (state is SignUpFailureState) {
            isLoading = false;
            showToast(text: state.error, state: ToastState.ERROR);
          }
          if (state is SignUpLoadingState) {
            isLoading = true;
          }
        },
      ),
    );
  }
}
