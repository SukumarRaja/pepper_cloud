import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../data/models/add_task_response_model.dart';
import '../data/models/delete_task_model.dart';
import '../data/models/task_model.dart';
import '../data/models/toggle_response_model.dart';

part 'task_service.g.dart';

@RestApi()
abstract class TaskService {
  factory TaskService(Dio dio, {String baseUrl}) = _TaskService;

  @GET('/tasks')
  Future<TaskResponse> getTask({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('is_completed') bool? isCompleted,
    @Query('due_date') String? dueDate,
    @Query('search') String? search,
  });

  @POST('/tasks')
  Future<AddTaskResponseModel> createTask({
    @Body() required Map<String, dynamic> body,
  });

  @PUT('/tasks/{id}')
  Future<AddTaskResponseModel> updateTask({
    @Path('id') required int id,
    @Body() required Map<String, dynamic> body,
  });

  @PATCH('/tasks/{id}/toggle')
  Future<ToggleTaskResponseModel> patchTask({
    @Path('id') required int id,
    @Body() required Map<String, dynamic> body,
  });

  @DELETE('/tasks/{id}')
  Future<DeleteTaskResponseModel> deleteTask({@Path('id') required int id});
}
