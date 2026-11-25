import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:taskflow/app/taskflow_app.dart';
import 'package:taskflow/features/tasks/data/task_repository.dart';
import 'package:taskflow/features/tasks/domain/task.dart';
import 'package:taskflow/features/tasks/presentation/tasks_view_model.dart';

/// Repositorio falso: devuelve en orden las respuestas programadas.
/// Una respuesta `null` simula un fallo de red.
class FakeTaskRepository implements TaskRepository {
  FakeTaskRepository(this._responses);

  final List<List<Task>?> _responses;
  int calls = 0;

  @override
  Future<List<Task>> getTasks() async {
    final response =
        _responses[calls < _responses.length ? calls : _responses.length - 1];
    calls++;
    if (response == null) throw Exception('Sin conexión');
    return response;
  }

  @override
  void save(Task task) {}
}

const sampleTask = Task(
  id: 21,
  title: 'Tarea remota de prueba',
  description: 'Descripción',
  priority: 'Media (API)',
  isCompleted: false,
  userId: 2,
);

Widget buildApp(TaskRepository repository) {
  return ChangeNotifierProvider<TasksViewModel>(
    create: (_) => TasksViewModel(repository)..loadTasks(),
    child: const TaskFlowApp(),
  );
}

void main() {
  testWidgets('Respuesta vacía muestra el estado vacío con Actualizar', (
    tester,
  ) async {
    await tester.pumpWidget(buildApp(FakeTaskRepository([[]])));
    await tester.pumpAndSettle();

    expect(find.text('Todavía no hay tareas para mostrar.'), findsOneWidget);
    expect(find.text('Actualizar'), findsOneWidget);
    expect(find.text('Reintentar'), findsNothing);
  });

  testWidgets('Un error muestra Reintentar y al reintentar vuelve la lista', (
    tester,
  ) async {
    final repository = FakeTaskRepository([
      null,
      [sampleTask],
    ]);
    await tester.pumpWidget(buildApp(repository));
    await tester.pumpAndSettle();

    expect(find.text('Reintentar'), findsOneWidget);
    expect(find.text('Actualizar'), findsNothing);
    expect(find.byIcon(Icons.cloud_off), findsOneWidget);

    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();

    expect(repository.calls, 2);
    expect(find.text('Tarea remota de prueba'), findsOneWidget);
    expect(find.text('Reintentar'), findsNothing);
  });

  testWidgets('Mientras carga se ve el indicador de progreso', (tester) async {
    await tester.pumpWidget(
      buildApp(
        FakeTaskRepository([
          [sampleTask],
        ]),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Tarea remota de prueba'), findsOneWidget);
  });
}
