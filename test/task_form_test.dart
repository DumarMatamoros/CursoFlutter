import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:taskflow/app/taskflow_app.dart';
import 'package:taskflow/features/tasks/data/task_repository.dart';
import 'package:taskflow/features/tasks/domain/task.dart';
import 'package:taskflow/features/tasks/presentation/tasks_view_model.dart';

/// Repositorio falso sin red: siempre responde una lista vacía.
class EmptyTaskRepository implements TaskRepository {
  @override
  Future<List<Task>> getTasks() async => [];

  @override
  void save(Task task) {}
}

Future<void> openForm(WidgetTester tester) async {
  await tester.pumpWidget(
    ChangeNotifierProvider<TasksViewModel>(
      create: (_) => TasksViewModel(EmptyTaskRepository())..loadTasks(),
      child: const TaskFlowApp(),
    ),
  );
  // appRouter es global: se vuelve a '/' para que cada test empiece limpio.
  appRouter.go('/');
  await tester.pumpAndSettle();
  await tester.tap(find.text('Nueva tarea'));
  await tester.pumpAndSettle();
}

Finder get titleField => find.widgetWithText(TextFormField, 'Título');

void main() {
  testWidgets('Título vacío muestra el mensaje de campo obligatorio', (
    tester,
  ) async {
    await openForm(tester);
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'El título es obligatorio: describe la tarea en pocas palabras.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('Título de 2 caracteres muestra el mensaje de título corto', (
    tester,
  ) async {
    await openForm(tester);
    await tester.enterText(titleField, 'ab');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(
      find.text('El título es muy corto: usa al menos 3 caracteres.'),
      findsOneWidget,
    );
  });

  testWidgets('Formulario válido sin fecha vuelve y muestra el mensaje', (
    tester,
  ) async {
    await openForm(tester);
    await tester.enterText(titleField, '  Estudiar Dart  ');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Formulario válido: Estudiar Dart'), findsOneWidget);
    expect(find.text('Nueva tarea'), findsOneWidget); // solo el FAB
  });

  testWidgets('La fecha opcional elegida viaja en el borrador', (tester) async {
    await openForm(tester);
    await tester.enterText(titleField, 'Entregar informe');
    await tester.tap(find.text('Sin fecha límite'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Elegir'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Fecha límite: '), findsOneWidget);

    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Formulario válido: Entregar informe (fecha límite:'),
      findsOneWidget,
    );
  });

  testWidgets('Volver sin guardar no muestra ningún mensaje', (tester) async {
    await openForm(tester);
    await tester.enterText(titleField, 'Tarea descartada');
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.textContaining('Formulario válido'), findsNothing);
    expect(find.text('Todavía no hay tareas para mostrar.'), findsOneWidget);
  });
}
