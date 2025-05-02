// lib/presentation/screens/task_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';

class TaskDetailScreen extends ConsumerWidget {
  final int taskId;
  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stagesAsync = ref.watch(taskStagesProvider(taskId));
    final stageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Задача #$taskId')),
      body: stagesAsync.when(
        data: (stages) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final stage in stages)
              ListTile(
                title: Text(stage.title),
              ),
            const Divider(),
            TextField(
              controller: stageController,
              decoration: const InputDecoration(labelText: 'Новый этап'),
              onSubmitted: (value) async {
                await ref.read(taskServiceProvider).addStage(taskId, value);
                ref.invalidate(taskStagesProvider(taskId));
                stageController.clear();
              },
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Ошибка: $e')),
      ),
    );
  }
}
