import 'package:json_annotation/json_annotation.dart';

part 'toggle_response_model.g.dart';

@JsonSerializable()
class ToggleTaskResponseModel {
  final String status;
  final String message;
  final Task data;

  ToggleTaskResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ToggleTaskResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ToggleTaskResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ToggleTaskResponseModelToJson(this);
}

@JsonSerializable()
class Task {
  final int id;

  @JsonKey(name: 'is_completed', required: true)
  final bool isCompleted;

  Task({required this.id, required this.isCompleted});

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
