import '../../data/models/task_model.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskModel> tasks;
  final MetaData? pagination;

  TaskLoaded({required this.tasks, this.pagination});
}

class TaskError extends TaskState {
  final String message;

  TaskError(this.message);
}

class TaskOperationSuccess extends TaskState {
  final String message;

  TaskOperationSuccess(this.message);
}
