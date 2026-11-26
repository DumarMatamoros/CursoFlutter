import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TaskDraft {
  const TaskDraft(this.title, this.description, this.priority, {this.dueDate});

  final String title;
  final String description;
  final String priority;

  /// Fecha límite opcional; `null` si el usuario no eligió ninguna.
  final DateTime? dueDate;
}

/// Formatea una fecha como dd/mm/aaaa sin depender de paquetes externos.
String formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  static const int titleMinLength = 3;
  static const int titleMaxLength = 60;
  static const int descriptionMaxLength = 200;

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  String _priority = 'Media';
  DateTime? _dueDate;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  String? _validateTitle(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'El título es obligatorio: describe la tarea en pocas palabras.';
    }
    if (text.length < TaskFormScreen.titleMinLength) {
      return 'El título es muy corto: usa al menos '
          '${TaskFormScreen.titleMinLength} caracteres.';
    }
    if (text.length > TaskFormScreen.titleMaxLength) {
      return 'El título es muy largo: usa máximo '
          '${TaskFormScreen.titleMaxLength} caracteres.';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    final text = value?.trim() ?? '';
    if (text.length > TaskFormScreen.descriptionMaxLength) {
      return 'La descripción no puede superar '
          '${TaskFormScreen.descriptionMaxLength} caracteres.';
    }
    return null;
  }

  Future<void> _pickDueDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? today,
      firstDate: today,
      lastDate: DateTime(today.year + 2, 12, 31),
      helpText: 'Fecha límite (opcional)',
      cancelText: 'Cancelar',
      confirmText: 'Elegir',
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final draft = TaskDraft(
      _title.text.trim(),
      _description.text.trim(),
      _priority,
      dueDate: _dueDate,
    );
    context.pop(draft);
  }

  @override
  Widget build(BuildContext context) {
    final dueDate = _dueDate;

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva tarea')),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(
                labelText: 'Título',
                hintText: 'Ej.: Entregar informe de laboratorio',
              ),
              maxLength: TaskFormScreen.titleMaxLength,
              textInputAction: TextInputAction.next,
              validator: _validateTitle,
            ),
            TextFormField(
              controller: _description,
              decoration: const InputDecoration(
                labelText: 'Descripción (opcional)',
              ),
              maxLines: 3,
              maxLength: TaskFormScreen.descriptionMaxLength,
              validator: _validateDescription,
            ),
            DropdownButtonFormField<String>(
              initialValue: _priority,
              decoration: const InputDecoration(labelText: 'Prioridad'),
              items: const [
                DropdownMenuItem(value: 'Alta', child: Text('Alta')),
                DropdownMenuItem(value: 'Media', child: Text('Media')),
                DropdownMenuItem(value: 'Baja', child: Text('Baja')),
              ],
              validator: (value) =>
                  value == null ? 'Elige una prioridad para la tarea.' : null,
              onChanged: (value) =>
                  setState(() => _priority = value ?? 'Media'),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event),
              title: Text(
                dueDate == null
                    ? 'Sin fecha límite'
                    : 'Fecha límite: ${formatDate(dueDate)}',
              ),
              subtitle: const Text('Opcional'),
              trailing: dueDate == null
                  ? null
                  : IconButton(
                      tooltip: 'Quitar fecha',
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _dueDate = null),
                    ),
              onTap: _pickDueDate,
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _submit, child: const Text('Guardar')),
          ],
        ),
      ),
    );
  }
}
