// lib/presentation/providers/task_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minido/data/models/task_model.dart';
import 'package:minido/data/models/stage_model.dart';
import 'package:minido/data/services/task_service.dart';

final taskServiceProvider = Provider<TaskService>((ref) => TaskService());

final taskListProvider = FutureProvider<List<TaskModel>>((ref) async {
  final service = ref.watch(taskServiceProvider);
  return service.getTasks();
});

final taskStagesProvider = FutureProvider.family<List<StageModel>, int>((ref, taskId) async {
  final service = ref.watch(taskServiceProvider);
  return service.getTaskStages(taskId);
});
