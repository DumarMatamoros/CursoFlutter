class Task {
  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.isCompleted,
    required this.userId,
  });

  final int id;
  final String title;
  final String description;
  final String priority;
  final bool isCompleted;
  final int userId;

  Task copyWith({bool? isCompleted}) {
    return Task(
      id: id,
      title: title,
      description: description,
      priority: priority,
      isCompleted: isCompleted ?? this.isCompleted,
      userId: userId,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int,
      title: json['title'] as String,
      description:
          json['description'] as String? ??
          'Tarea de ejemplo obtenida de la API (API)',
      priority: json['priority'] as String? ?? 'Media (API)',
      isCompleted: (json['isCompleted'] ?? json['completed']) as bool? ?? false,
      userId: json['userId'] as int,
    );
  }
}
