import 'package:flutter/material.dart';
import 'package:pepper_cloud/features/task/data/models/task_model.dart';
import 'package:pepper_cloud/features/task/presentation/pages/task_form_page.dart';
import 'package:pepper_cloud/features/task/presentation/pages/task_list_page.dart';

class AppRoutes {
  static const String taskList = '/';
  static const String taskForm = '/task_form';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case taskList:
        return MaterialPageRoute(
          builder: (_) => const TaskListPage(),
          settings: settings,
        );
      case taskForm:
        final task = settings.arguments as TaskModel?;
        return MaterialPageRoute(
          builder: (_) => TaskFormPage(task: task),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
