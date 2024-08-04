import 'package:flutter/material.dart';
import 'package:todo_app_task/shared/components/components.dart';

import '../../../shared/styles/colors.dart';
import '../login/login_screen.dart';

class StartPageScreen extends StatelessWidget {
  const StartPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
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
                "Task Management &\n To-Do List",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "This productive tool is designed to help \n "
                "you better manage your task \n "
                "project-wise conveniently!",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 2.0,
                      color: Colors.black45,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              defaultToDoButton(
                context,
                text: "Let's Start",
                icon: const ImageIcon(
                  AssetImage(
                    'assets/icons/arrow_right.png',
                  ),
                  size: 24,
                  color: textInWidgetsColor,
                ),
                function: () {
                  navigateAndFinish(context, LoginScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
