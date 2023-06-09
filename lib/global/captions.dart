import 'package:todo_admin/models/common/identity.dart';
import 'package:todo_admin/models/common/login.dart';
import 'package:todo_admin/models/primary/reference.dart';
import 'package:todo_admin/models/primary/task.dart';
import 'package:todo_admin/models/primary/user.dart';

class GlobalCaptions {
  String languageLabels(String code) {
    final languageLabels = {
      'es': 'Español',
      'en': 'English',
    };

    return languageLabels[code];
  }

  String userRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Administrador';
      case UserRole.client:
        return 'Cliente';
      case UserRole.broker:
        return 'Agente';
    }
    return null;
  }

  String taskPriority(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.red:
        return 'RED';
      case TaskPriority.orange:
        return 'ORANGE';
      case TaskPriority.yellow:
        return 'YELLOW';
        case TaskPriority.green:
        return 'GREEN';
    }
    return null;
  }

  String identityType(IdentityType type) {
    switch (type) {
      case IdentityType.passport:
        return 'Pasaporte';
      case IdentityType.license:
        return 'Licencia';
      case IdentityType.personal:
        return 'Cédula';
      case IdentityType.company:
        return 'Mercantil';
    }
    return null;
  }

  String loginState(LoginState state) {
    switch (state) {
      case LoginState.active:
        return 'Activo';
      case LoginState.inactive:
        return 'Inactivo';
      case LoginState.unconfirmed:
        return 'Sin Confirmar';
      case LoginState.removed:
        return 'Desvinculado';
    }
    return null;
  }

  String referenceType(ReferenceType type, {bool plural}) {
    if (plural == true) {
      switch (type) {
        case ReferenceType.country:
          return 'Países';
        case ReferenceType.country_state:
          return 'Provincias';
        case ReferenceType.state_city:
          return 'Ciudades';
      }
    } else {
      switch (type) {
        case ReferenceType.country:
          return 'País';
        case ReferenceType.country_state:
          return 'Provincia';
        case ReferenceType.state_city:
          return 'Ciudad';
      }
    }
    return null;
  }
}

enum ArticleCaptionType { label, extended, title }
