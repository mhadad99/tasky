import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_task/modules/cubit/cubit.dart';
import 'package:todo_app_task/shared/components/bloc_observer.dart';
import 'package:todo_app_task/shared/components/constants.dart';
import 'package:todo_app_task/shared/network/local/cache.dart';
import 'package:todo_app_task/shared/network/remote/dio_help.dart';
import 'package:todo_app_task/shared/network/remote/dio_helper.dart';

import 'modules/screens/start_page/start_page_screen.dart';
import 'modules/screens/tasks/tasks_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelp.dioInit();
  DioHelper.init();
  await CacheHelper.init();
  refreshToken = CacheHelper.getData(key: 'refresh_token') ?? '';
  Widget widget;
  if (refreshToken.isNotEmpty) {
    widget = TasksScreen();
  } else {
    widget = const StartPageScreen();
  }

  runApp(MyApp(startWidget: widget));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.startWidget});

  final Widget startWidget;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            color: Colors.white,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
            ),
          ),
          scaffoldBackgroundColor: Colors.white,
        ),
        debugShowCheckedModeBanner: false,
        home: startWidget,
      ),
    );
  }
}
