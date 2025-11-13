import 'package:dio/dio.dart';

import '../../features/initial/bloc/initial_bloc.dart';

class ApiClient {
  static Dio createDio(InitialBloc bloc) {
    final dio = Dio(
      BaseOptions(
        baseUrl: "https://hyprcabs.com/task_mock/public/api",
        connectTimeout: const Duration(seconds: 5000),
        receiveTimeout: const Duration(seconds: 3000),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    return dio;
  }
}

const baseUrl = "https://hyprcabs.com/task_mock/public/api";
