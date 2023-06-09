import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/middleware/application.dart';
import 'package:todo_admin/middleware/global.dart';
import 'package:todo_admin/middleware/page_meta.dart';
import 'package:todo_admin/pages/private/home.dart';
import 'package:todo_admin/pages/private/options/index.dart';
import 'package:todo_admin/pages/private/options/profile.dart';
import 'package:todo_admin/pages/private/users/list.dart';
import 'package:todo_admin/pages/private/tasks/tasks_page.dart';
import 'package:todo_admin/widgets/blocks/build.dart';
import 'package:todo_admin/widgets/components/header.dart';
import 'package:todo_admin/widgets/components/menu.dart';

class PrivateContainer extends anxeb.PageContainer<Application, PageMeta> {
  @override
  List<anxeb.PageWidget<Application, PageMeta> Function()> pages() {
    return [
      () => HomePage(),
      () => UsersPage(),
      () => TasksPage(),
      () => OptionsPage(),
      () => ProfilePage(),
    ];
  }

  @override
  Future setup() async {}

  @override
  Widget build(BuildContext context, anxeb.GoRouterState state, Widget child) {
    return Column(
      children: [
        HeaderComponent(
          application: application,
        ),
        Expanded(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: 120,
                      child: anxeb.PageNavigator(
                        application: application,
                        backgroundColor: Global.settings.menuFillColor,
                        isActive: (item) => info.name.endsWith(item.key) == true,
                        isVisible: () => application.session.authenticated,
                        roles: () => application.session.roles != null
                            ? application.session.roles.map((e) => e.toString().split('.')[1]).toList()
                            : ['any'],
                        groups: () => [
                          anxeb.MenuGroup(
                            caption: () => 'Inicio',
                            key: 'home',
                            icon: Global.icons.home,
                            onTab: () async => go('/home'),
                          ),
                          anxeb.MenuGroup(
                            caption: () => 'Usuarios',
                            key: 'users',
                            icon: Global.icons.users,
                            onTab: () async => go('/users'),
                          ),
                           anxeb.MenuGroup(
                            caption: () => 'Tareas',
                            key: 'tasks',
                            icon: Global.icons.tasks,
                            onTab: () async => go('/tasks'),
                          ),
                          anxeb.MenuGroup(
                            caption: () => 'Acerca',
                            key: 'home_about',
                            icon: Global.icons.about,
                            onTab: () async => go('/home/about'),
                          ),
                          anxeb.MenuGroup(
                            caption: () => 'Cambiar\nUsuario',
                            key: 'login',
                            icon: Global.icons.user,
                            onTab: () async => go('/login'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                    child: Material(
                      color: Global.settings.headerFillColor,
                      borderRadius: const BorderRadius.all(Radius.circular(0)),
                      child: InkWell(
                        onTap: () {
                          application.session.logout();
                        },
                        enableFeedback: true,
                        borderRadius: const BorderRadius.all(Radius.circular(0)),
                        child: Container(
                          padding: const EdgeInsets.only(left: 6, right: 12, top: 6, bottom: 6),
                          width: 120,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 6),
                                child: const Icon(
                                  Icons.phonelink_erase_sharp,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                'SALIR',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: Global.settings.menuFillColor.withOpacity(0.1),
                            child: MenuComponent(
                              application: application,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: child,
                    ),
                    Container(
                      color: Global.settings.headerFillColor.withOpacity(0.8),
                      child: BuildBlock(
                        application: application,
                        fill: Global.settings.headerFillColor,
                        aboutPath: '/home/about',
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
