import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/middleware/application.dart';
import 'package:todo_admin/middleware/global.dart';
import 'package:todo_admin/middleware/session.dart';
import 'package:todo_admin/models/primary/task.dart';

class TaskListRow extends StatefulWidget {
  final anxeb.Scope scope;
  final TaskModel task;
  final GestureTapCallback onTap;
  final GestureTapCallback onDeleteTap;
  final int tick;

  const TaskListRow({
    Key key,
    @required this.scope,
    @required this.task,
    this.onTap,
    this.tick,
    this.onDeleteTap,
  }) : super(key: key);

  @override
  createState() => _TaskListRowState();
}

class _TaskListRowState extends State<TaskListRow> {
  @override
  Widget build(BuildContext context) {
    return anxeb.ListTitleBlock(
      padding: const EdgeInsets.only(
        right: 12,
        left: 2,
        top: 3,
        bottom: 4,
      ),
      margin: const EdgeInsets.only(top: 1, bottom: 8),
      scope: widget.scope,
      icon: Icons.task_outlined,
      iconPadding: const EdgeInsets.only(top: 3, right: 2, left: 8),
      iconScale: 1,
      iconColor: Global.colors.taskPriority(task.priority),
      title: task.title,
      titleStyle: TextStyle(
        fontSize: 16,
        height: 1.30,
        fontWeight: FontWeight.w500,
        letterSpacing: -.3,
        color: settings.colors.primary,
      ),
      subtitle: task.taskDescription,
      titleTrailBody: anxeb.TextButton(
        caption: 'Eliminar',
        size: anxeb.ButtonSize.chip,
        enabled: task.id != session?.user?.id,
        icon: Icons.delete,
        fontSize: 11,
        margin: const EdgeInsets.only(bottom: 0, top: 2),
        iconSize: 11,
        color: application.settings.colors.danger,
        onPressed: widget.onDeleteTap,
        padding: const EdgeInsets.only(left: 8, right: 11, bottom: 2),
      ),
      
      subtitleTrailBody: Container(
        padding: const EdgeInsets.only(top: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            anxeb.ListStatsBlock(
              scope: widget.scope,
              text: Global.captions.taskPriority(task.priority).toUpperCase(),
              fontSize: 13,
              icon: Icons.priority_high,
              iconPadding: const EdgeInsets.only(right: 2),
              scale: 1.6,
              color: Global.colors.taskPriority(task.priority),
            ),
            anxeb.ListStatsBlock(
              scope: widget.scope,
              text: task.title.toUpperCase(),
              fontSize: 13,
              icon: Icons.task,
              iconPadding: const EdgeInsets.only(right: 2),
              scale: 1.6,
              color: settings.colors.primary,
            ),
          ],
        ),
      ),

      subtitleTrailStyle: const TextStyle(
        fontSize: 14,
        height: 1.5,
        fontWeight: FontWeight.w400,
      ),
      chipColor: Colors.black,
      subtitleStyle: const TextStyle(
        fontSize: 12,
        height: 1.1,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      divisor: true,
      iconTrailScale: 0.6,
      onTap: widget.onTap,
      borderRadius: Global.settings.generalRadius,
    );
  }

  TaskModel get task => widget.task;

  anxeb.Settings get settings => widget.scope.application.settings;

  Application get application => widget.scope.application;

  Session get session => application.session;
}
