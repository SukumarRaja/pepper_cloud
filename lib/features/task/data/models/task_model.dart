import 'package:json_annotation/json_annotation.dart';

part 'task_model.g.dart';

@JsonSerializable()
class TaskModel {
  final int id;
  final String title;
  final String description;

  @JsonKey(name: 'is_completed', defaultValue: false)
  final bool isCompleted;

  @JsonKey(name: 'due_date')
  final DateTime? dueDate;

  @JsonKey(name: 'created_at', required: true)
  final DateTime createdAt;

  @JsonKey(name: 'updated_at', required: true)
  final DateTime updatedAt;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    bool? isCompleted,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
  }) : isCompleted = isCompleted ?? false;

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);
}

@JsonSerializable()
class TaskResponse {
  final String status;
  final List<TaskModel> data;
  final MetaData meta;

  TaskResponse({required this.status, required this.data, required this.meta});

  factory TaskResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TaskResponseToJson(this);
}

@JsonSerializable()
class MetaData {
  @JsonKey(name: 'current_page', defaultValue: 1)
  final int currentPage;

  @JsonKey(name: 'last_page', defaultValue: 1)
  final int lastPage;

  @JsonKey(name: 'per_page', defaultValue: 15)
  final int perPage;

  @JsonKey(defaultValue: 0)
  final int total;

  MetaData({int? currentPage, int? lastPage, int? perPage, int? total})
    : currentPage = currentPage ?? 1,
      lastPage = lastPage ?? 1,
      perPage = perPage ?? 15,
      total = total ?? 0;

  factory MetaData.fromJson(Map<String, dynamic> json) =>
      _$MetaDataFromJson(json);

  Map<String, dynamic> toJson() => _$MetaDataToJson(this);
}
