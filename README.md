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

Las historias 1 y 2 ya están implementadas. La 3 tiene el formulario validado (sesión 9) y se completará al conectar el `POST` en la sesión 10; la 4 y la 5 se implementarán en sesiones posteriores.

### Modelo de datos

`Task` (definido en `lib/features/tasks/domain/task.dart`):

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

## API de tareas

Desde la sesión 7, TaskFlow lee sus tareas de la API pública de práctica
[JSONPlaceholder](https://jsonplaceholder.typicode.com/) usando Dio.

- **URL exacta:** `GET https://jsonplaceholder.typicode.com/todos?userId=2`
- **Parámetro `userId`:** filtra las tareas por usuario. TaskFlow usa el
  usuario `2` (constante `TaskApiService.userId`), que devuelve 20 tareas
  (ids 21 a 40).
- **Campos recibidos:** `userId` (`int`), `id` (`int`), `title` (`String`) y
  `completed` (`bool`, se convierte en `isCompleted`).
- **Valores que completa TaskFlow:** la API no envía `description` ni
  `priority`, así que `Task.fromJson` usa los valores de ejemplo
  `"Tarea de ejemplo obtenida de la API (API)"` y `"Media (API)"`.
- **Marcar como completada es solo local:** el cambio se guarda en una copia en
  memoria de `RemoteTaskRepository`; no se envía a la API y se pierde al
  reiniciar la app.

Flujo: `main` → `TasksViewModel` → `RemoteTaskRepository` → `TaskApiService`
→ Dio `GET` → `Task.fromJson` → `notifyListeners` → lista y detalle.

## Estados de la lista de tareas

Desde la sesión 8, `TaskListScreen` muestra un estado explícito para cada
resultado de `TasksViewModel.loadTasks()`:

| Estado    | Qué ve el usuario                                                                 | Cómo se provocó para la evidencia                                                                 |
|-----------|-----------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------|
| Cargando  | `CircularProgressIndicator` centrado; el botón de actualizar queda deshabilitado | Red del emulador limitada (Extended controls → Cellular → Network type: GPRS) al abrir la app     |
| Datos     | Tarjetas con título y prioridad; se puede actualizar deslizando hacia abajo      | Ejecución normal con `userId = 2` (20 tareas)                                                     |
| Vacío     | "Todavía no hay tareas para mostrar." y botón **Actualizar**                      | `TaskApiService.userId` cambiado temporalmente a `9999` (la API responde `200` con `[]`), restaurado a `2` después |
| Error     | Mensaje de conexión y botón **Reintentar**                                        | Modo avión en el emulador y luego tocar el botón de actualizar de la barra                       |

- **Vacío y error son distintos:** una respuesta válida sin tareas no lanza
  excepción, así que muestra **Actualizar**; solo un fallo de red, servidor o
  formato muestra **Reintentar**.
- **Recuperación sin reiniciar:** con el error visible se desactiva el modo
  avión y se toca **Reintentar**; la lista vuelve a aparecer.
- **Sin peticiones repetidas:** `loadTasks()` no hace nada si ya hay una carga
  en curso.
- **Pruebas:** `test/task_list_states_test.dart` usa un repositorio falso para
  comprobar los estados vacío, error → reintento → lista, y carga.

## Formulario de nueva tarea

Desde la sesión 9, el botón **Nueva tarea** de la lista abre `/new`
(`TaskFormScreen`). Al guardar, el formulario devuelve un `TaskDraft` a la
lista, que muestra el mensaje "Formulario válido: …". **Todavía no se envía
nada a la API**; el `POST` se conectará en la sesión 10.

| Campo           | Regla                                   | Mensaje si no se cumple                                            |
|-----------------|-----------------------------------------|--------------------------------------------------------------------|
| Título          | Obligatorio, de 3 a 60 caracteres       | "El título es obligatorio: describe la tarea en pocas palabras." / "El título es muy corto: usa al menos 3 caracteres." / "El título es muy largo: usa máximo 60 caracteres." |
| Descripción     | Opcional, máximo 200 caracteres         | "La descripción no puede superar 200 caracteres."                  |
| Prioridad       | Alta, Media o Baja (por defecto Media)  | "Elige una prioridad para la tarea."                               |
| Fecha límite    | **Opcional**, desde hoy hasta 2 años    | Ninguno: se puede guardar sin fecha y quitarla con la ✕            |

- Los errores se muestran al tocar **Guardar** y, después, mientras se escribe
  (`AutovalidateMode.onUserInteraction`).
- El título y la descripción se guardan sin espacios al inicio ni al final.
- La fecha se elige con `showDatePicker` y se muestra como `dd/mm/aaaa`; si se
  eligió, también aparece en el mensaje de vuelta.
- Volver con la flecha atrás descarta el formulario sin mostrar mensaje.
- **Pruebas:** `test/task_form_test.dart` comprueba título vacío, título de 2
  caracteres, formulario válido, fecha opcional y volver sin guardar.
