import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_task/modules/screens/profile/profile_cubit/profile_cubit.dart';
import 'package:todo_app_task/modules/screens/tasks/tasks_screen.dart';
import 'package:todo_app_task/shared/components/components.dart';
import 'package:todo_app_task/shared/styles/colors.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  Widget? widget;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ProfileCubit()..getUserData(),
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            leading: IconButton(
              icon: leadingIcon(),
              onPressed: () {
                navigateAndFinish(context, TasksScreen());
              },
            ),
            title: const Text("Profile"),
          ),
          body: BlocBuilder<ProfileCubit, ProfileStates>(
            builder: (context, state) {
              if (state is ProfileSuccessState) {
                return profileDataSuccess(context);
              } else if (state is ProfileFailureState) {
                return profileDataFailure(context);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ));
  }

  Widget profileDataSuccess(context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              dataPreviewFiled(
                  title: 'Name',
                  value: ProfileCubit.get(context).userModel!.displayName!),
              dataPreviewFiled(
                title: 'phone',
                value: ProfileCubit.get(context).userModel!.username!,
                icon: IconButton(
                    padding: EdgeInsets.zero,
                    color: defaultColor,
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                          text:
                              ProfileCubit.get(context).userModel!.username!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard')),
                      );
                    },
                    icon: ImageIcon(
                      const AssetImage(
                        'assets/icons/copy.png',
                      ),
                      size: 24,
                      color: defaultColor,
                    )),
              ),
              dataPreviewFiled(
                  title: 'Level',
                  value: ProfileCubit.get(context).userModel!.level!),
              dataPreviewFiled(
                  title: 'Years Of Experience',
                  value: ProfileCubit.get(context).userModel!.experienceYears!),
              dataPreviewFiled(
                  title: 'Location',
                  value: ProfileCubit.get(context).userModel!.address!),
            ],
          ),
        ),
      );
  Widget profileDataFailure(context) => Center(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Something Went Wrong'),
            TextButton(
                onPressed: () {
                  ProfileCubit.get(context).getUserData();
                },
                child: const Text('Try Again'))
          ],
        ),
      );
}
