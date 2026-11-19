import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:taskflow/app/taskflow_app.dart';
import 'package:taskflow/features/tasks/data/local_task_repository.dart';
import 'package:taskflow/features/tasks/presentation/tasks_view_model.dart';

Widget buildApp() {
  return ChangeNotifierProvider<TasksViewModel>(
    create: (_) => TasksViewModel(LocalTaskRepository()),
    child: const TaskFlowApp(),
  );
}

void main() {
  testWidgets('TaskFlow abre el listado con tres tareas', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Mis tareas'), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(3));
  });

  testWidgets('Cambiar el estado en el detalle actualiza la lista', (
    tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Leer documentación'));
    await tester.pumpAndSettle();
    expect(find.text('Estado: pendiente'), findsOneWidget);

    await tester.tap(find.text('Marcar como completada'));
    await tester.pump();
    expect(find.text('Estado: completada'), findsOneWidget);
    expect(find.text('Marcar como pendiente'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check_circle), findsNWidgets(2));
  });
}
