import 'dart:ui';
import '../models/common/login.dart';
import 'package:todo_admin/models/primary/task.dart';

const Color _primary = Color(0xff0272E7);


class GlobalColors {

Color taskPriority(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.red:
        return const Color.fromARGB(225, 219, 24, 24);
      case TaskPriority.orange:
        return const Color.fromARGB(224, 217, 112, 70);
      case TaskPriority.yellow:
        return const Color.fromARGB(224, 255, 247, 101);
        case TaskPriority.green:
        return const Color.fromARGB(224, 131, 197, 38);
    }
    return null;
  }
  
  Color loginState(LoginState state) {
    switch (state) {
      case LoginState.active:
        return _primary;
      case LoginState.inactive:
        return const Color(0xff777777);
      case LoginState.unconfirmed:
        return const Color(0xff777777);
      case LoginState.removed:
        return const Color(0xff777777);
    }
    return null;
  }
}