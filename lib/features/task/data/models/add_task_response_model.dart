import 'package:json_annotation/json_annotation.dart';

part 'add_task_response_model.g.dart';

@JsonSerializable()
class AddTaskResponseModel {
  final String status;
  final String message;
  final Task data;

  AddTaskResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AddTaskResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AddTaskResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddTaskResponseModelToJson(this);
}

@JsonSerializable()
class Task {
  final int id;
  final String title;
  final String description;

  @JsonKey(name: 'is_completed', required: true)
  final bool isCompleted;

  @JsonKey(name: 'due_date')
  final DateTime? dueDate;
  @JsonKey(name: 'created_at', required: true)
  final DateTime createdAt;
  @JsonKey(name: 'updated_at', required: true)
  final DateTime updatedAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
