# taskflow

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
# CursoFlutter

## Alcance de TaskFlow

**Problema:** necesito organizar mis actividades académicas y saber cuáles faltan.

**Usuario objetivo:** estudiante que planifica sus entregas semanales.

### Historias de usuario y criterios de aceptación

1. Como estudiante, quiero listar mis tareas para ver qué debo hacer.
   - Criterio: la lista muestra el título, la prioridad y el estado de cada tarea.
2. Como estudiante, quiero abrir una tarea para leer su descripción.
   - Criterio: al tocar una tarjeta aparece el detalle de la tarea elegida.
3. Como estudiante, quiero crear una tarea para registrar un pendiente.
   - Criterio: el formulario guarda una tarea válida y la lista la muestra.
4. Como estudiante, quiero editar una tarea para corregir sus datos.
   - Criterio: los cambios guardados aparecen en la lista y en el detalle.
5. Como estudiante, quiero eliminar una tarea terminada para limpiar la lista.
   - Criterio: después de confirmar, la tarea desaparece de la lista.

Las historias 1 y 2 ya están implementadas; la 3, la 4 y la 5 se implementarán en sesiones posteriores.

### Modelo de datos

`Task` (definido en `lib/task.dart`):

| Campo         | Tipo     | Descripción                                   |
|---------------|----------|-----------------------------------------------|
| `id`          | `int`    | Identificador único de la tarea               |
| `title`       | `String` | Texto corto que se muestra en la lista        |
| `description` | `String` | Información completa para el detalle          |
| `priority`    | `String` | Alta, Media o Baja                            |
| `isCompleted` | `bool`   | `true` = completada, `false` = pendiente      |
| `userId`      | `int`    | Propietario (usuario de prueba `1`)           |

### Datos de prueba actuales

| id | Tarea                            | Prioridad | Estado     |
|----|----------------------------------|-----------|------------|
| 1  | Crear la pantalla de bienvenida  | Baja      | Completada |
| 2  | Configurar el entorno Flutter    | Alta      | Completada |
| 3  | Agregar estado de tareas         | Media     | Completada |
| 4  | Mostrar listado local de tareas  | Media     | Completada |
| 5  | Navegar al detalle de la tarea   | Alta      | Pendiente  |

### Pantallas previstas

- **Lista:** tarjetas de tareas y acción para crear.
- **Detalle:** información completa y futuras acciones de editar o eliminar.
- **Formulario:** campos de título, descripción y prioridad.

### Requisitos no funcionales

- La navegación debe tener textos comprensibles.
- Un id inexistente debe mostrar un mensaje en vez de cerrar la app.

### Contrato de API que necesitaremos

| Método   | Ruta         | Operación          |
|----------|--------------|--------------------|
| `GET`    | `/tasks`     | Listar tareas      |
| `GET`    | `/tasks/:id` | Consultar detalle  |
| `POST`   | `/tasks`     | Crear tarea        |
| `PATCH`  | `/tasks/:id` | Actualizar tarea   |
| `DELETE` | `/tasks/:id` | Eliminar tarea     |

La API concreta se elegirá después. Estas rutas son requisitos, no
direcciones de un servidor ya conectado.
