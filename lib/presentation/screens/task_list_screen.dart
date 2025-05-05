// UPDATED task_list_screen.dart - now uses /tasks/all to filter client-side archived

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  bool showArchived = false;
  final controller = TextEditingController();
  List<int> dismissedTaskIds = [];

  @override
  Widget build(BuildContext context) {
    final taskService = ref.read(taskServiceProvider);
    final tasksAsync = ref.watch(taskListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(showArchived ? 'Архив' : 'Список задач'),
        actions: [
          IconButton(
            icon: Icon(showArchived ? Icons.inbox : Icons.archive),
            tooltip: showArchived ? 'Активные' : 'Архив',
            onPressed: () => setState(() => showArchived = !showArchived),
          )
        ],
      ),
      body: tasksAsync.when(
        data: (tasks) {
          final visibleTasks = tasks.where((t) {
            if (showArchived) return t.isArchived;
            return !t.isArchived && !dismissedTaskIds.contains(t.id);
          }).toList();

          if (visibleTasks.isEmpty) {
            return const Center(child: Text('Нет задач'));
          }

          return ListView.builder(
            itemCount: visibleTasks.length,
            itemBuilder: (context, index) {
              final task = visibleTasks[index];
              return showArchived
                  ? ListTile(
                title: Text(task.title, style: const TextStyle(color: Colors.grey)),
              )
                  : Dismissible(
                key: Key(task.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.archive, color: Colors.white),
                ),
                onDismissed: (_) async {
                  setState(() => dismissedTaskIds.add(task.id));
                  await taskService.archiveTask(task.id);
                  ref.invalidate(taskListProvider);
                },
                child: ListTile(title: Text(task.title)),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Ошибка: $e")),
      ),
      floatingActionButton: showArchived
          ? null
          : FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Новая задача'),
              content: TextField(controller: controller, autofocus: true),
              actions: [
                TextButton(
                  onPressed: () async {
                    final title = controller.text.trim();
                    if (title.isNotEmpty) {
                      await taskService.createTask(title);
                      ref.invalidate(taskListProvider);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Создать'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}