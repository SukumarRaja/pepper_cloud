import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../data/models/task_model.dart';
import 'package:retrofit/error_logger.dart';

part 'task_service.g.dart';

@RestApi()
abstract class TaskService {
  factory TaskService(Dio dio, {String baseUrl}) = _TaskService;

  @GET('/tasks')
  Future<TaskResponse> getTask({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('search') String? search,
  });

  @POST('/tasks')
  Future<dynamic> createTask({@Body() Map<String, dynamic>? taskData});

  @PUT('/tasks/{id}')
  Future<dynamic> updateTask({
    @Path('id') int? id,
    @Body() Map<String, dynamic>? taskData,
  });

  @DELETE('/tasks/{id}')
  Future<dynamic> deleteTask({@Path('id') int? id});
}
