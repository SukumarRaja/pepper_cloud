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
    on<ToggleTaskActive>(_onToggle);
  }

  Future<void> _onFetchTasks(FetchTask event, Emitter<TaskState> emit) async {
    try {
      if (event.page == 1) {
        emit(TaskLoading());
      }

      final res = await service.getTask(
        page: event.page,
        limit: event.limit,
        isCompleted: event.isCompleted,
        dueDate: event.dueDate?.toIso8601String(),
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
        body: {
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
      await service.updateTask(
        id: event.id,
        body: {
          'title': event.title,
          'description': event.description,
          'due_date': event.dueDate,
          'is_completed': event.isActive,
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

  Future<void> _onToggle(
    ToggleTaskActive event,
    Emitter<TaskState> emit,
  ) async {
    try {
      final res = await service.patchTask(
        id: event.id,
        body: {'is_active': event.isActive},
      );
      if (res.status == 'success') {
        emit(TaskOperationSuccess(res.message));
        add(FetchTask(page: 1, limit: 10));
      } else {
        emit(TaskError(res.message));
      }
    } catch (e) {
      emit(TaskError("An unexpected error occurred"));
    }
  }
}
