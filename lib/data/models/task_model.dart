class TaskModel {
  final int id;
  final String title;
  final bool isArchived;

  TaskModel({
    required this.id,
    required this.title,
    required this.isArchived,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      isArchived: json['is_archived'] ?? false,
    );
  }
}
