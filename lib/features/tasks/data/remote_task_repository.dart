import '../domain/task.dart';
import 'task_api_service.dart';
import 'task_repository.dart';

class RemoteTaskRepository implements TaskRepository {
  RemoteTaskRepository(this._service);

  final TaskApiService _service;
  List<Task> _cache = [];

  @override
  Future<List<Task>> getTasks() async {
    _cache = await _service.getTasks();
    return List.unmodifiable(_cache);
  }

  @override
  void save(Task task) {
    // JSONPlaceholder no guarda cambios: solo actualizamos la copia en memoria.
    final index = _cache.indexWhere((item) => item.id == task.id);
    if (index == -1) return;
    _cache[index] = task;
  }
}
