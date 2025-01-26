import 'package:task_manager/Data/models/task_count_model.dart';

class TaskCountByStatusModel {
  String? status;
  List<TaskCountModel>? data;

  TaskCountByStatusModel({this.status, this.data});

  TaskCountByStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <TaskCountModel>[];
      json['data'].forEach((v) {
        data!.add(TaskCountModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

