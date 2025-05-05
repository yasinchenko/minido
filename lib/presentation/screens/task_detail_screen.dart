// TaskDetailScreen отключён
import 'package:flutter/material.dart';

class TaskDetailScreen extends StatelessWidget {
  final int taskId;
  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Задача #$taskId")),
      body: const Center(
        child: Text('Редактирование этапов отключено в v1'),
      ),
    );
  }
}
