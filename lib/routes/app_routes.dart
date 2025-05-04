import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/task_list_screen.dart';
import '../presentation/screens/task_detail_screen.dart' as detail;

class AppRoutes {
  static final router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/tasks',
        builder: (context, state) => TaskListScreen(),
      ),
      GoRoute(
        path: '/tasks/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          return detail.TaskDetailScreen(taskId: id);
        },
      ),
    ],
  );
}
