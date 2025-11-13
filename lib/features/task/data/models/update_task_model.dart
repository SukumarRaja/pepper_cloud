class UpdateTaskModel {
  final String title;
  final String description;
  final String dueDate;
  final bool isCompleted;

  UpdateTaskModel({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'isCompleted': isCompleted,
    };
  }
}
