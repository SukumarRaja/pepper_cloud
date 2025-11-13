// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toggle_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ToggleTaskResponseModel _$ToggleTaskResponseModelFromJson(
        Map<String, dynamic> json) =>
    ToggleTaskResponseModel(
      status: json['status'] as String,
      message: json['message'] as String,
      data: Task.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ToggleTaskResponseModelToJson(
        ToggleTaskResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data.toJson(),
    };

Task _$TaskFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['is_completed'],
  );
  return Task(
    id: (json['id'] as num).toInt(),
    isCompleted: json['is_completed'] as bool,
  );
}

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'is_completed': instance.isCompleted,
    };
