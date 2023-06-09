import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/middleware/application.dart';
import 'package:todo_admin/middleware/global.dart';
 import 'package:todo_admin/models/common/identity.dart';
// import 'package:todo_admin/models/common/login.dart';
import 'package:todo_admin/models/primary/task.dart';

class TaskForm extends anxeb.FormDialog<TaskModel, Application> {
  TaskModel _task;
  TaskPriority _priority;

  TaskForm({@required anxeb.Scope scope, TaskModel task, TaskPriority priority})
      : super(
          scope,
          model: task,
          dismissable: true,
          title: task == null ? 'Nueva Tarea' : 'Editar Tarea',
          subtitle: task?.title,
          icon: task == null ? Icons.task : anxeb.CommunityMaterialIcons.account_edit,
          width: Global.settings.mediumFormWidth,
        ) {
    _priority = priority;
  }

  @override
  void init(anxeb.FormScope scope) {
    _task = TaskModel();
    _task.update(model);
  }

  @override
  Widget body(anxeb.FormScope scope) {
    return Column(
      children: [
        anxeb.FormRowContainer(
          scope: scope,
          fields: [
            Expanded(
              child: anxeb.TextInputField(
                scope: scope,
                name: 'title',
                group: 'task',
                icon: Icons.text_fields,
                fetcher: () => _task.title,
                label: 'Titulo',
                type: anxeb.TextInputFieldType.text,
                validator: anxeb.Utils.validators.firstNames,
                applier: (value) => _task.title = value,
                autofocus: true,
              ),
            ),
            anxeb.FormSpacer(),
          ],
        ),
         anxeb.FormRowContainer(
           scope: scope,
           title: 'Información Administrativa',
           fields: [
             anxeb.FormSpacer(),
             Expanded(
               child: anxeb.OptionsInputField<TaskPriority>(
                 scope: scope,
                 name: 'priority',
                 group: 'task',
                 icon: Icons.shield_rounded,
                 fetcher: () => _task.priority,
                 label: 'Rol',
                 options: () async => TaskPriority.values,
                 displayText: (value) => Global.captions.taskPriority(value),
                 onValidSubmit: (value) => scope.rasterize(() => _task.priority = value),
                 applier: (value) => _task.priority = value,
               ),
             ),
           ],
         ),
       ],
     );
  }

  @override
  List<anxeb.FormButton> buttons(anxeb.FormScope<Application> scope) {
    return [
      anxeb.FormButton(
        caption: 'Eliminar',
        visible: true,
        onTap: (anxeb.FormScope scope) => _delete(scope),
        fillColor: scope.application.settings.colors.danger,
        icon: Icons.delete,
        rightDivisor: true,
      ),
      anxeb.FormButton(
        caption: 'Guardar',
        onTap: (anxeb.FormScope scope) => _persist(scope),
        icon: Icons.check,
      ),
      anxeb.FormButton(
        caption: exists ? 'Cerrar' : 'Cancelar',
        onTap: (anxeb.Scope scope) async => true,
        icon: Icons.close,
      )
    ];
  }

  Future _delete(anxeb.FormScope scope) async {
    return await _task.using(scope).delete(success: (helper) async {
      scope.parent.alerts.success('Tarea eliminada exitosamente').show();
    });
  }

  Future _persist(anxeb.FormScope scope) async {
    final form = scope.forms['task'];
    if (form.valid(autoFocus: true)) {
      if (_priority != null) {
        _task.priority = _priority;
      }

      return await _task.using(scope).update(success: (helper) async {
        if (exists) {
          scope.parent.alerts.success('Tarea actualizada exitosamente').show();
          scope.parent.rasterize(() {
            model.update(_task);
          });
        } else {
          scope.parent.alerts.success('Tarea creada exitosamente').show();
        }
      });
    }
  }

  @override
  Future Function(anxeb.FormScope scope) get close => (scope) async => true;
}
