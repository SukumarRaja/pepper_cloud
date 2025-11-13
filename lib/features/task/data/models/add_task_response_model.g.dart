// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_task_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddTaskResponseModel _$AddTaskResponseModelFromJson(
        Map<String, dynamic> json) =>
    AddTaskResponseModel(
      status: json['status'] as String,
      message: json['message'] as String,
      data: Task.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AddTaskResponseModelToJson(
        AddTaskResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data.toJson(),
    };

Task _$TaskFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['is_completed', 'created_at', 'updated_at'],
  );
  return Task(
    id: (json['id'] as num).toInt(),
    title: json['title'] as String,
    description: json['description'] as String,
    isCompleted: json['is_completed'] as bool,
    dueDate: json['due_date'] == null
        ? null
        : DateTime.parse(json['due_date'] as String),
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );
}

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'is_completed': instance.isCompleted,
      'due_date': instance.dueDate?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
