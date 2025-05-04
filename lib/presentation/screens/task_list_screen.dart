// lib/presentation/screens/task_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(taskListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Список задач')),
      body: tasksAsync.when(
        data: (tasks) => ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return ListTile(
              title: Text(task.title),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskDetailScreen(taskId: task.id),
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Ошибка: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Открытие формы создания задачи
          // Пример: Navigator.pushNamed(context, '/tasks/create');
          // Или показать диалог:
          showDialog(
            context: context,
            builder: (_) => const AlertDialog(
              title: Text('Добавить задачу'),
              content: Text('Здесь должна быть форма добавления'),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
