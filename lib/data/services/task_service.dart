// lib/data/services/task_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';
import '../models/stage_model.dart';

class TaskService {
  static const _baseUrl = 'http://194.87.145.25';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<TaskModel>> getTasks() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/tasks/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => TaskModel.fromJson(json)).toList();
    } else {
      throw Exception('Не удалось загрузить задачи');
    }
  }

  Future<List<TaskModel>> getAllTasks() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/tasks/all'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => TaskModel.fromJson(json)).toList();
    } else {
      throw Exception('Не удалось загрузить все задачи');
    }
  }

  Future<List<StageModel>> getTaskStages(int taskId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/tasks/$taskId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final stages = data['stages'] as List;
      return stages.map((json) => StageModel.fromJson(json)).toList();
    } else {
      throw Exception('Не удалось загрузить этапы');
    }
  }

  Future<void> addStage(int taskId, String title) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/tasks/$taskId/stages/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'title': title}),
    );
    if (response.statusCode != 200) {
      throw Exception('Не удалось добавить этап');
    }
  }

  Future<void> archiveTask(int id) async {
    final token = await _getToken();
    final response = await http.patch(
      Uri.parse('$_baseUrl/tasks/$id/archive'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('Не удалось архивировать задачу');
    }
  }

  Future<void> createTask(String title) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/tasks/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'title': title}),
    );
    if (response.statusCode != 200) {
      throw Exception('Не удалось создать задачу');
    }
  }
}
