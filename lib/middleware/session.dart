import 'dart:io';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/middleware/application.dart';
import 'package:todo_admin/models/local/credentials.dart';
import 'package:todo_admin/models/local/auth.dart';
import 'package:todo_admin/models/primary/user.dart';

class Session {
  Application _application;
  SessionAuth _auth;
  int _tick;
  bool _performSesionCleanup;

  Session(Application application) {
    _application = application;
    _tick = DateTime.now().toUtc().millisecondsSinceEpoch;
    _performSesionCleanup = false;
  }

  Future check() async {
    if (_performSesionCleanup == true) {
      _performSesionCleanup = false;

      await close();
    } else if (application.configuration.tokenized == true && authenticated != true) {
      try {
        await application.session.renew();
      } catch (err) {
        scope.alerts.error(err).show();
      }
    }
  }

  Future<SessionAuth> open([CredentialsModel credentials]) async {
    if (credentials == null) {
      return await renew();
    } else {
      final data = await application.api.post('/auth/user?type=email', credentials.toObjects());
      await _buildSessionAuth(data);
      return _auth;
    }
  }

  Future<SessionAuth> refresh({anxeb.Scope scope}) async {
    return await renew(scope: scope);
  }

  Future<SessionAuth> renew({anxeb.Scope scope}) async {
    anxeb.Data data;
    if (application.configuration.isAuthSaved) {
      api.token = application.configuration?.auth?.token;

      try {
        data = await application.api.post('/auth', {});
      } catch (err) {
        if (err.code == 6013 || err.code == 911 && scope != null) {
          scope.alerts.error(err).show();
          await close();
          Future.delayed(const Duration(milliseconds: 1000), () {
            logout(direct: true);
          });
        } else {
          rethrow;
        }
      }
    }
    return await _buildSessionAuth(data);
  }

  Future logout({bool direct}) async {
    if (direct == true || await scope.dialogs.confirm('¿Estás seguro de que quieres terminar la sesión?').show()) {
      api.token = null;
      _performSesionCleanup = true;
      scope.go('/login');
    }
  }

  Future close() async {
    application.configuration.auth = null;
    api.token = null;
    _auth = null;

    try {
      if (application.auths != null) {
        await application.auths?.google?.logout();
        if (Platform.isIOS) {
          await application.auths?.apple?.logout();
        }
        await application.auths?.facebook?.logout();
      }
    } catch (err) {
      //ignore
    } finally {
      await application.configuration.persist();
    }
  }

  Future<SessionAuth> _buildSessionAuth(data) async {
    final auth = SessionAuth(data);
    _auth = auth;
    api.token = _auth.token;
    application.configuration.auth = _auth;
    try {
      await application.configuration.persist();
    } catch (err) {
      //ignore
    }

    _tick = DateTime.now().toUtc().millisecondsSinceEpoch;
    return _auth;
  }

  bool get closed => _auth == null || _auth.user == null || api.token != null;

  Application get application => _application;

  anxeb.Api get api => _application.api;

  UserModel get user => _auth?.user;

  int get tick => _tick;

  bool get authenticated => _auth?.user?.id != null;

  List<AuthRoles> get roles => _auth?.roles ?? [];

  SessionAuthFlagsModel get flags => _auth?.flags;

  SessionAuth get auth => _auth;

  anxeb.PageScope<Application> get scope => application.middleware.scope;

  bool get canAddReferences => user?.role == UserRole.admin;
}
