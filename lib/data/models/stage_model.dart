// lib/data/models/stage_model.dart
class StageModel {
  final int id;
  final String title;

  StageModel({required this.id, required this.title});

  factory StageModel.fromJson(Map<String, dynamic> json) => StageModel(
    id: json['id'],
    title: json['title'],
  );
}