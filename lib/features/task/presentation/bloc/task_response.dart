import 'package:equatable/equatable.dart';
import 'package:pepper_cloud/features/task/data/models/task_model.dart';

class TaskResponse extends Equatable {
  final List<TaskModel> data;
  final MetaData meta;

  const TaskResponse({
    required this.data,
    required this.meta,
  });

  factory TaskResponse.fromJson(Map<String, dynamic> json) {
    return TaskResponse(
      data: (json['data'] as List)
          .map((taskJson) => TaskModel.fromJson(taskJson))
          .toList(),
      meta: MetaData.fromJson(json['meta']),
    );
  }

  @override
  List<Object?> get props => [data, meta];
}

class MetaData extends Equatable {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const MetaData({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      currentPage: json['current_page'] as int,
      lastPage: json['last_page'] as int,
      perPage: json['per_page'] as int,
      total: json['total'] as int,
    );
  }

  @override
  List<Object?> get props => [currentPage, lastPage, perPage, total];
}
