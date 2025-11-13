import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pepper_cloud/features/task/domain/task_service.dart';
import 'package:pepper_cloud/features/task/presentation/bloc/task_event.dart';
import 'package:pepper_cloud/features/task/presentation/bloc/task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskService service;

  TaskBloc(this.service) : super(TaskInitial()) {
    on<FetchTask>(_onFetchTasks);
    on<CreateTask>(_onCreateTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
  }

  Future<void> _onFetchTasks(FetchTask event, Emitter<TaskState> emit) async {
    try {
      if (event.page == 1) {
        emit(TaskLoading());
      }

      final res = await service.getTask(
        page: event.page,
        limit: event.limit,
        search: event.search,
      );

      if (event.page == 1) {
        emit(TaskLoaded(tasks: res.data, pagination: res.meta));
      } else if (state is TaskLoaded) {
        final currentState = state as TaskLoaded;
        emit(
          TaskLoaded(
            tasks: [...currentState.tasks, ...res.data],
            pagination: res.meta,
          ),
        );
      }
    } on DioException catch (e) {
      emit(TaskError(e.response?.data?['message'] ?? 'Failed to load tasks'));
    } catch (e) {
      emit(TaskError('An unexpected error occurred'));
    }
  }

  Future<void> _onCreateTask(CreateTask event, Emitter<TaskState> emit) async {
    try {
      await service.createTask(
        taskData: {
          'title': event.title,
          'description': event.description,
          'is_completed': event.isActive,
          'due_date': event.dueDate,
        },
      );
      emit(TaskOperationSuccess('Task created successfully'));
      // Refresh the task list
      if (state is TaskLoaded) {
        final currentState = state as TaskLoaded;
        add(FetchTask(page: 1, limit: currentState.pagination?.perPage ?? 10));
      }
    } on DioException catch (e) {
      emit(TaskError(e.response?.data?['message'] ?? 'Failed to create task'));
      rethrow;
    } catch (e) {
      emit(TaskError('An unexpected error occurred'));
      rethrow;
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    try {
      print("kljklj ${event.id}");
      await service.updateTask(
        id: event.id,
        taskData: {
          'title': event.title,
          'description': event.description,
          'due_date': event.dueDate,
          'is_active': event.isActive,
        },
      );
      emit(TaskOperationSuccess('Task updated successfully'));
      // Refresh the task list
      if (state is TaskLoaded) {
        final currentState = state as TaskLoaded;
        add(FetchTask(page: 1, limit: currentState.pagination?.perPage ?? 10));
      }
    } on DioException catch (e) {
      emit(TaskError(e.response?.data?['message'] ?? 'Failed to update task'));
      rethrow;
    } catch (e) {
      emit(TaskError('An unexpected error occurred'));
      rethrow;
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try {
      await service.deleteTask(id: event.id);
      emit(TaskOperationSuccess('Task deleted successfully'));
      // Refresh the task list
      if (state is TaskLoaded) {
        final currentState = state as TaskLoaded;
        add(FetchTask(page: 1, limit: currentState.pagination?.perPage ?? 10));
      }
    } on DioException catch (e) {
      emit(TaskError(e.response?.data?['message'] ?? 'Failed to delete task'));
      rethrow;
    } catch (e) {
      emit(TaskError('An unexpected error occurred'));
      rethrow;
    }
  }

  // Future<void> _onCreateStop(CreateStop event, Emitter<RouteStopState> emit) async {
  //   try {
  //     final payload = m.CreateStopPayload(
  //       stop_name: event.stopName,
  //       latitude: event.latitude,
  //       longitude: event.longitude,
  //       is_pickup: event.isPickup,
  //       pickup_time: event.pickupTime,
  //       drop_time: event.dropTime,
  //     );
  //     final res = await service.createStop(payload: payload);
  //     if (res.success) {
  //       emit(RouteStopOperationSuccess(res.message ?? 'Stop created'));
  //       final list = await service.list(page: 1, limit: 10, search: null);
  //       emit(RouteStopLoaded(stops: list.data, pagination: list.pagination));
  //     } else {
  //       emit(RouteStopError(res.message ?? 'Failed to create stop'));
  //     }
  //   } catch (e) {
  //     emit(RouteStopError(ErrorHandler.handleError(e)));
  //     final list = await service.list(page: 1, limit: 10, search: null);
  //     emit(RouteStopLoaded(stops: list.data, pagination: list.pagination));
  //   }
  // }
  //
  // Future<void> _onUpdateStop(UpdateStop event, Emitter<RouteStopState> emit) async {
  //   try {
  //     final payload = m.UpdateStopPayload(
  //       stop_name: event.stopName,
  //       latitude: event.latitude,
  //       longitude: event.longitude,
  //       is_pickup: event.isPickup,
  //       pickup_time: event.pickupTime,
  //       drop_time: event.dropTime,
  //     );
  //     final resp = await service.updateStop(stopId: event.stopId, payload: payload);
  //     if (resp.success) {
  //       emit(RouteStopOperationSuccess('Stop updated'));
  //       final list = await service.list(page: 1, limit: 10, search: null);
  //       emit(RouteStopLoaded(stops: list.data, pagination: list.pagination));
  //     } else {
  //       emit(RouteStopError(resp.message ?? 'Failed to update stop'));
  //     }
  //   } catch (e) {
  //     emit(RouteStopError(ErrorHandler.handleError(e)));
  //     final list = await service.list(page: 1, limit: 10, search: null);
  //     emit(RouteStopLoaded(stops: list.data, pagination: list.pagination));
  //   }
  // }
  //
  // Future<void> _onToggleStopActive(ToggleStopActive event, Emitter<RouteStopState> emit) async {
  //   try {
  //     final resp = await service.toggleActive(stopId: event.stopId, body: {'is_active': event.isActive});
  //     if (resp.success) {
  //       emit(RouteStopOperationSuccess(resp.message ?? 'Stop status updated'));
  //       final list = await service.list(page: 1, limit: 10, search: null);
  //       emit(RouteStopLoaded(stops: list.data, pagination: list.pagination));
  //     } else {
  //       emit(RouteStopError(resp.message ?? 'Failed to update stop status'));
  //     }
  //   } catch (e) {
  //     emit(RouteStopError(ErrorHandler.handleError(e)));
  //   }
  // }
  //
  // Future<void> _onDeleteStop(DeleteStop event, Emitter<RouteStopState> emit) async {
  //   try {
  //     final resp = await service.deleteStop(stopId: event.stopId);
  //     if (resp.success) {
  //       emit(RouteStopOperationSuccess('Stop deleted'));
  //       final list = await service.list(page: 1, limit: 10, search: null);
  //       emit(RouteStopLoaded(stops: list.data, pagination: list.pagination));
  //     } else {
  //       emit(RouteStopError(resp.message ?? 'Failed to delete stop'));
  //     }
  //   } catch (e) {
  //     emit(RouteStopError(ErrorHandler.handleError(e)));
  //   }
  // }
}
