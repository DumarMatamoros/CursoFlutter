import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:taskflow/main.dart';

void main() {
  Finder completeButton() =>
      find.widgetWithText(OutlinedButton, 'Completar una tarea');

  testWidgets('Estado inicial: contador 3 y botones activos', (tester) async {
    await tester.pumpWidget(const TaskFlowApp());

    expect(find.text('¡Hola, Dumar Matamoros!'), findsOneWidget);
    expect(find.text('Tareas pendientes: 3'), findsOneWidget);
    expect(find.text('Aún tienes tareas por organizar.'), findsOneWidget);
    expect(
      tester.widget<OutlinedButton>(completeButton()).onPressed,
      isNotNull,
    );
  });

  testWidgets('Flujo completo: agregar, completar hasta 0 y volver a 1', (
    tester,
  ) async {
    await tester.pumpWidget(const TaskFlowApp());

    // Agrega dos tareas: 5
    await tester.tap(find.text('Agregar tarea'));
    await tester.tap(find.text('Agregar tarea'));
    await tester.pump();
    expect(find.text('Tareas pendientes: 5'), findsOneWidget);

    // Completa cinco tareas: 0, sin negativos
    for (var i = 0; i < 5; i++) {
      await tester.tap(completeButton());
      await tester.pump();
    }
    expect(find.text('Tareas pendientes: 0'), findsOneWidget);
    expect(
      find.text('¡Excelente! No tienes tareas pendientes.'),
      findsOneWidget,
    );
    expect(tester.widget<OutlinedButton>(completeButton()).onPressed, isNull);

    // Agrega una tarea: 1 y botón habilitado
    await tester.tap(find.text('Agregar tarea'));
    await tester.pump();
    expect(find.text('Tareas pendientes: 1'), findsOneWidget);
    expect(find.text('Aún tienes tareas por organizar.'), findsOneWidget);
    expect(
      tester.widget<OutlinedButton>(completeButton()).onPressed,
      isNotNull,
    );
  });
}
