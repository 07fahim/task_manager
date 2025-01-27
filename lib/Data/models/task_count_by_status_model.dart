import 'package:task_manager/Data/models/task_count_model.dart';

class TaskCountByStatusModel {
  String? status;
  List<TaskCountModel>? taskStatusList;

  TaskCountByStatusModel({this.status, this.taskStatusList});

  TaskCountByStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      taskStatusList = <TaskCountModel>[];
      json['data'].forEach((v) {
        taskStatusList!.add(TaskCountModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.taskStatusList != null) {
      data['data'] = this.taskStatusList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

