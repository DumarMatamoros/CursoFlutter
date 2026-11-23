import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'tasks_view_model.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TasksViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Mis tareas')),
      body: _buildBody(context, viewModel),
    );
  }

  Widget _buildBody(BuildContext context, TasksViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final error = viewModel.errorMessage;
    if (error != null) {
      return Center(child: Text(error));
    }

    final tasks = viewModel.tasks;
    if (tasks.isEmpty) {
      return const Center(child: Text('No hay tareas para mostrar.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          child: ListTile(
            leading: Icon(
              task.isCompleted
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: task.isCompleted ? Colors.green : null,
            ),
            title: Text(task.title),
            subtitle: Text('Prioridad: ${task.priority}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/task/${task.id}'),
          ),
        );
      },
    );
  }
}
