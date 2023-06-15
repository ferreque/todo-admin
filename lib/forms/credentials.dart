import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/middleware/application.dart';
import 'package:todo_admin/middleware/global.dart';
import 'package:todo_admin/middleware/session.dart';
import 'package:todo_admin/models/primary/user.dart';

class CredentialsForm extends anxeb.FormDialog<UserModel, Application> {
  UserModel _user;

  CredentialsForm({@required anxeb.Scope scope, @required UserModel user})
      : super(
          scope,
          model: user,
          dismissable: true,
          title: 'Cambio de Contraseña',
          subtitle: user?.login?.email,
          icon: anxeb.CommunityMaterialIcons.key,
          buttonAlignment: MainAxisAlignment.spaceBetween,
          width: Global.settings.smallFormWidth,
        );

  @override
  void init(anxeb.FormScope scope) {
    _user = UserModel();
    _user.update(model);
  }

  @override
  Widget body(anxeb.FormScope scope) {
    return Column(
      children: [
        anxeb.FormRowContainer(
          scope: scope,
          title: 'Ingrese su contraseña actual',
          fields: [
            Expanded(
              child: anxeb.TextInputField(
                scope: scope,
                name: 'password_old',
                group: 'credentials',
                icon: Icons.key,
                label: 'Contraseña Actual',
                validator: anxeb.Utils.validators.password,
                autofocus: true,
                type: anxeb.TextInputFieldType.password,
              ),
            )
          ],
        ),
        anxeb.FormRowContainer(
          scope: scope,
          title: 'Ingrese su nueva contraseña',
          fields: [
            Expanded(
              child: anxeb.TextInputField(
                scope: scope,
                name: 'password_new',
                group: 'credentials',
                icon: Icons.key,
                label: 'Nueva Contraseña',
                validator: anxeb.Utils.validators.password,
                type: anxeb.TextInputFieldType.password,
              ),
            )
          ],
        ),
        anxeb.FormRowContainer(
          scope: scope,
          fields: [
            Expanded(
              child: anxeb.TextInputField(
                scope: scope,
                name: 'password_rep',
                group: 'credentials',
                icon: Icons.key,
                label: 'Repetir Contraseña',
                validator: (value) {
                  final validPass = anxeb.Utils.validators.password(value);
                  if (validPass != null) {
                    return validPass;
                  }
                  if (value != scope.forms['credentials'].fields['password_new'].value) {
                    return 'Igual a la contraseña nueva';
                  } else {
                    return null;
                  }
                },
                type: anxeb.TextInputFieldType.password,
                action: TextInputAction.go,
                onActionSubmit: (val) => _persist(scope),
                focusNext: false,
              ),
            )
          ],
        ),
      ],
    );
  }

  @override
  List<anxeb.FormButton> buttons(anxeb.FormScope scope) {
    return [
      anxeb.FormButton(
        caption: 'Actualizar',
        onTap: (anxeb.FormScope scope) => _persist(scope),
        fillColor: scope.application.settings.colors.success,
        icon: Icons.check,
      ),
      anxeb.FormButton(
        caption: 'Cancelar',
        onTap: (anxeb.Scope scope) async => true,
        icon: Icons.close,
      )
    ];
  }

  Future _persist(anxeb.FormScope scope) async {
    final form = scope.forms['credentials'];
    if (form.valid(autoFocus: true)) {
      final params = form.data();
      try {
        return await _user.using(scope).confirmPassword(params['password_old'], throwError: true, next: (helper) async {
          return await _user.using(scope).setPassword(
              newPassword: params['password_new'],
              oldPassword: params['password_old'],
              success: (helper) async {
                scope.parent.alerts.success('Contraseña actualizada exitosamente').show();
                scope.parent.rasterize(() {
                  model.update(_user);
                  pop();
                });
              });
        });
      } catch (err) {
        form.focus('password_old', warning: err.toString(), force: true);
        form.select('password_old');
      }
    }
  }

  anxeb.Settings get settings => scope.application.settings;

  Application get application => scope.application;

  Session get session => application.session;
}
