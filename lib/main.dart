import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/network/api_client.dart';
import 'features/initial/bloc/initial_bloc.dart';
import 'features/initial/bloc/initial_event.dart';
import 'features/task/domain/task_service.dart';
import 'features/task/presentation/bloc/task_bloc.dart';
import 'features/task/presentation/bloc/task_event.dart';
import 'features/task/presentation/pages/task_list_page.dart';
import 'routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final TaskBloc _taskBloc;
  late final InitialBloc _initAppBloc;
  late final TaskService _taskService;

  @override
  void initState() {
    super.initState();
    _initAppBloc = InitialBloc()..add(StartInitial());
    final dio = ApiClient.createDio(_initAppBloc);
    _taskService = TaskService(dio, baseUrl: baseUrl);
    _taskBloc = TaskBloc(_taskService);
  }

  @override
  void dispose() {
    _taskBloc.close();
    _initAppBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InitialBloc>(create: (_) => _initAppBloc),
        BlocProvider<TaskBloc>(
          create: (context) => _taskBloc..add(FetchTask(page: 1, limit: 10)),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Manager',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        onGenerateRoute: AppRoutes.generateRoute,
        home: const TaskListPage(),
      ),
    );
  }
}
