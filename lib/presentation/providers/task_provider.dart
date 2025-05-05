// UPDATED task_provider.dart - uses /tasks/all instead of /tasks/
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minido/data/models/task_model.dart';
import 'package:minido/data/models/stage_model.dart';
import 'package:minido/data/services/task_service.dart';

final taskServiceProvider = Provider<TaskService>((ref) => TaskService());

final taskListProvider = FutureProvider<List<TaskModel>>((ref) async {
  final service = ref.watch(taskServiceProvider);
  return service.getAllTasks(); // use /tasks/all
});

final taskStagesProvider = FutureProvider.family<List<StageModel>, int>((ref, taskId) async {
  final service = ref.watch(taskServiceProvider);
  return service.getTaskStages(taskId);
});
