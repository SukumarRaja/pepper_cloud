import 'package:json_annotation/json_annotation.dart';

part 'delete_task_model.g.dart';

@JsonSerializable()
class DeleteTaskResponseModel {
  final String status;
  final String message;

  DeleteTaskResponseModel({required this.status, required this.message});

  factory DeleteTaskResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DeleteTaskResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteTaskResponseModelToJson(this);
}
