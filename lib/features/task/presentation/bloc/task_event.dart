abstract class TaskEvent {}

class FetchTask extends TaskEvent {
  final int page;
  final int limit;
  final String? search;
  final bool? isCompleted;
  final DateTime? dueDate;

  FetchTask({
    this.page = 1,
    this.limit = 10,
    this.search,
    this.dueDate,
    this.isCompleted,
  });
}

class CreateTask extends TaskEvent {
  final String title;
  final String? description;
  final bool isActive;
  final String dueDate;

  CreateTask({
    required this.title,
    required this.description,
    required this.isActive,
    required this.dueDate,
  });
}

class UpdateTask extends TaskEvent {
  final int id;
  final String title;
  final String? description;
  final bool isActive;
  final String dueDate;

  UpdateTask({
    required this.id,
    required this.title,
    required this.description,
    required this.isActive,
    required this.dueDate,
  });
}

class ToggleTaskActive extends TaskEvent {
  final int id;
  final bool isActive;

  ToggleTaskActive({required this.id, required this.isActive});
}

class DeleteTask extends TaskEvent {
  final int id;

  DeleteTask({required this.id});
}
