import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/forms/task.dart';
import 'package:todo_admin/middleware/global.dart';
import 'package:todo_admin/middleware/page_meta.dart';
import 'package:todo_admin/middleware/session.dart';
import 'package:todo_admin/models/primary/task.dart';
import 'package:todo_admin/widgets/rows/task.dart';
import 'package:todo_admin/middleware/application.dart';

class TasksPage extends anxeb.PageWidget<Application, PageMeta> {
  TasksPage({Key key}) : super('tasks', key: key, path: 'tasks');

  @override
  PageMeta meta() => PageMeta(icon: Global.icons.tasks);

  @override
  createState() => _TasksState();

  @override
  String title({anxeb.GoRouterState state}) => 'Tareas Existentes';
}

class _TasksState extends anxeb.PageView<TasksPage, Application, PageMeta> {
  List<TaskModel> _tasks;
  ScrollController _scrollController;
  bool _refreshing;
  String _lookup;

  @override
  Future init() async {
    _scrollController = ScrollController();
    _refresh();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void setup() async {
    meta.menu = _getMenu;
    meta.onSearch = (text) {
      rasterize(() {
        _lookup = text;
      });
    };

    if (info?.state?.queryParams != null && info?.state?.queryParams['refresh'] == 'true') {
      _refresh();
    }
  }

  @override
  void prebuild() {}

  @override
  Widget content() {
    return _getList();
  }

  Widget _getMenu() {
    return Row(
      children: [
        anxeb.MenuButton(
          scope: scope,
          caption: 'Refrescar',
          icon: Icons.refresh,
          margin: const EdgeInsets.only(right: 4),
          onTap: _refresh,
        ),
        anxeb.MenuButton(
          scope: scope,
          caption: 'Agregar',
          icon: Icons.add,
          onTap: _add,
        ),
      ],
    );
  }

  Future _refresh({bool uncatched, bool jump, bool silent}) async {
    if (silent != true) {
      rasterize(() {
        _refreshing = true;
      });
    }
    try {
      if (uncatched != true && silent != true) {
        await scope.busy();
      }
      scope.retick();
      final data = await session.api.get('/tasks');
      _tasks = data.list((data) => TaskModel(data));

      if (_tasks.isEmpty) {
        meta.subtitle = 'Registro de tareas del sistema';
      } else if (_tasks.length == 1) {
        meta.subtitle = 'Existe una tarea registrada';
      } else {
        meta.subtitle = 'Existen ${_tasks.length} tareas registradas';
      }

      if (jump == true && _scrollController.hasClients) {
        _scrollController.position.jumpTo(0);
      }
    } catch (err) {
      if (uncatched != true) {
        if (silent != true) {
          scope.alerts.error(err).show();
        }
      } else {
        rethrow;
      }
    } finally {
      if (uncatched != true && silent != true) {
        await scope.idle();
      }
    }

    rasterize(() {
      _refreshing = false;
    });
  }

  Widget _getList() {
    if (tasks == null && _refreshing == true) {
      return anxeb.EmptyBlock(
        scope: scope,
        message: 'Cargando tareas...',
        icon: Icons.sync,
      );
    }

    if (tasks == null) {
      return anxeb.EmptyBlock(
        scope: scope,
        message: 'Error cargando tareas',
        icon: Icons.cloud_off,
        actionText: 'Refrescar',
        actionCallback: () async => _refresh(),
      );
    }

    if (tasks.isEmpty) {
      return anxeb.EmptyBlock(
        scope: scope,
        message: 'No existen tareas registradas',
        icon: anxeb.Octicons.info,
        actionText: 'Refrescar',
        actionCallback: () async => _refresh(),
      );
    }

    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      children: tasks
          .map((item) =>
              TaskListRow(scope: scope, task: item, onTap: () => _select(item), onDeleteTap: () => _delete(item)))
          .toList(),
    );
  }

  void _select(TaskModel task) async {
    task.using(scope).fetch(success: (helper) async {
      final form = TaskForm(scope: scope, task: task);
      final result = await form.show();
      if (result != null && result.$deleted == true) {
        rasterize(() {
          _tasks.remove(task);
        });
      }
    });
  }

  void _delete(TaskModel task) async {
    final result = await task.using(scope).delete(success: (helper) async {
      scope.alerts.success('Tarea eliminada exitosamente').show();
    });
    if (result != null) {
      rasterize(() {
        _tasks.remove(task);
      });
    }
  }

  void _add() async {
    final form = TaskForm(scope: scope);
    final result = await form.show();
    if (result != null) {
      rasterize(() {
        _tasks.add(result);
      });
      await Future.delayed(const Duration(milliseconds: 10));
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
      }
    }
  }

  List<TaskModel> get tasks =>
      _tasks != null ? _tasks.where(($item) => $item.filter(lookup: _lookup)).toList() : _tasks;

  Session get session => application.session;
}
