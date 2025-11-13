// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteTaskResponseModel _$DeleteTaskResponseModelFromJson(
        Map<String, dynamic> json) =>
    DeleteTaskResponseModel(
      status: json['status'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$DeleteTaskResponseModelToJson(
        DeleteTaskResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
    };
