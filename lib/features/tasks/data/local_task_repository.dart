import '../domain/task.dart';
import 'task_repository.dart';

class LocalTaskRepository implements TaskRepository {
  final List<Task> _tasks = [
    const Task(
      id: 1,
      title: 'Crear la pantalla de bienvenida',
      description: 'Diseñar WelcomeScreen con saludos y tarjeta',
      priority: 'Baja',
      isCompleted: true,
      userId: 1,
    ),
    const Task(
      id: 2,
      title: 'Configurar el entorno Flutter',
      description: 'Instalar y configurar el entorno de desarrollo (flutter doctor y flutter run)',
      priority: 'Alta',
      isCompleted: true,
      userId: 1,
    ),
    const Task(
      id: 3,
      title: 'Agregar estado de tareas',
      description: 'Contador de pendientes y completadas',
      priority: 'Media',
      isCompleted: true,
      userId: 1,
    ),
    const Task(
      id: 4,
      title: 'Mostrar listado local de tareas',
      description: 'Mostrar las tareas en una lista local',
      priority: 'Media',
      isCompleted: true,
      userId: 1,
    ),
    const Task(
      id: 5,
      title: 'Navegar al detalle de la tarea',
      description:
          'Implementar navegación a la pantalla de detalle de la tarea',
      priority: 'Alta',
      isCompleted: false,
      userId: 1,
    ),
  ];

  @override
  Future<List<Task>> getTasks() async => List.unmodifiable(_tasks);

  @override
  void save(Task task) {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) return;
    _tasks[index] = task;
  }
}
