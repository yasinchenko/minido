// lib/presentation/screens/task_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/task_model.dart';
import '../providers/task_provider.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(taskListProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Задачи'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Активные'),
              Tab(text: 'Архив'),
            ],
          ),
        ),
        body: tasksAsync.when(
          data: (tasks) => TabBarView(
            children: [
              _buildListView(context, ref, tasks.where((t) => !t.isArchived).toList()),
              _buildListView(context, ref, tasks.where((t) => t.isArchived).toList(), enableDismiss: false),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Ошибка: $e')),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final controller = TextEditingController();
            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Новая задача'),
                content: TextField(
                  controller: controller,
                  decoration: const InputDecoration(labelText: 'Название'),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Отмена'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final title = controller.text.trim();
                      if (title.isNotEmpty) {
                        await ref.read(taskServiceProvider).createTask(title);
                        ref.invalidate(taskListProvider);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Создать'),
                  ),
                ],
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildListView(BuildContext context, WidgetRef ref, List<TaskModel> tasks, {bool enableDismiss = true}) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final tile = ListTile(
          title: Text(task.title),
          onTap: () => context.go('/tasks/${task.id}'),
        );

        if (!enableDismiss) return tile;

        return Dismissible(
          key: ValueKey(task.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.red,
            child: const Icon(Icons.archive, color: Colors.white),
          ),
          onDismissed: (_) async {
            await ref.read(taskServiceProvider).archiveTask(task.id);
            ref.invalidate(taskListProvider);
          },
          child: tile,
        );
      },
    );
  }
}
