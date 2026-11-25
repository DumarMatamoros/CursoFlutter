import 'package:flutter/foundation.dart';

import '../data/task_repository.dart';
import '../domain/task.dart';

class TasksViewModel extends ChangeNotifier {
  TasksViewModel(this._repository);

  final TaskRepository _repository;

  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Task> get tasks => List.unmodifiable(_tasks);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => _tasks.isEmpty;

  Future<void> loadTasks() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tasks = await _repository.getTasks();
    } catch (error) {
      _tasks = [];
      _errorMessage = 'No se pudieron cargar las tareas. Revisa tu conexión e inténtalo de nuevo.';
      debugPrint('Error al cargar tareas: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Task? findTask(int? id) {
    if (id == null) return null;
    for (final task in _tasks) {
      if (task.id == id) return task;
    }
    return null;
  }

  void toggleCompleted(int id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) return;

    final updated = _tasks[index].copyWith(
      isCompleted: !_tasks[index].isCompleted,
    );
    _tasks = [..._tasks]..[index] = updated;
    _repository.save(updated);
    notifyListeners();
  }
}
