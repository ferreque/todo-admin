import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/models/primary/task.dart';

class TaskHelper extends anxeb.ModelHelper<TaskModel> {
  Future showQR() async {
    await scope.dialogs.qr(model.id, icon: Icons.person, title: model.title, size: 300, buttons: [
      anxeb.DialogButton('Cerrar', false),
    ]).show();
  }

  @override
  Future<TaskModel> delete({Future Function(TaskHelper) success}) async {
    if (model.id != null) {
      var result = await scope.dialogs
          .confirm(
              'Está apunto de eliminar la tarea:\n\n  📝 ${model.title} \n\n¿Está seguro que quiere continuar?')
          .show();
      if (result == true) {
        try {
          await scope.busy();
          await scope.api.delete('/tasks/${model.id}');
          scope.rasterize(() {
            model.$deleted = true;
          });
          return await success?.call(this) != false ? model : null;
        } catch (err) {
          scope.alerts.error(err).show();
        } finally {
          await scope.idle();
        }
      }
    }
    return null;
  }

  Future<TaskModel> update({Future Function(TaskHelper) success, Future Function(TaskHelper) next, bool silent}) async {
    if (silent != true) {
      await scope.busy(text: '${model.$exists ? 'Actualizando' : 'Creando'} Tarea...');
    }

    try {
      final data = await scope.api.post('/tasks', {'task': model.toObjects()});
      scope.rasterize(() {
        model.update(data);
      });
      await next?.call(this);
      if (silent != true) {
        await scope.idle();
      }
      return await success?.call(this) != false ? model : null;
    } catch (err) {
      scope.alerts.error(err).show();
    } finally {
      if (silent != true) {
        await scope.idle();
      }
    }
    return null;
  }

  Future<TaskModel> fetch(
      {String id, Future Function(TaskHelper) success, Future Function(TaskHelper) next, bool silent}) async {
    if (silent != true) {
      await scope.busy(text: 'Cargando Tarea...');
    }

    try {
      final data = await scope.api.get('/tasks/${id ?? model.id}');
      scope.rasterize(() {
        model.update(data);
      });
      await next?.call(this);
      if (silent != true) {
        await scope.idle();
      }
      return await success?.call(this) != false ? model : null;
    } catch (err) {
      scope.alerts.error(err).show();
    } finally {
      if (silent != true) {
        await scope.idle();
      }
    }
    return null;
  }

}
