import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/helpers/task.dart';
// import 'package:todo_admin/models/common/identity.dart';
// import 'package:todo_admin/models/common/login.dart';

class TaskModel extends anxeb.HelpedModel<TaskModel, TaskHelper> {
  TaskModel([data]) : super(data);

  @override
  void init() {
    field(() => id, (v) => id = v, 'id', primary: true);
    field(() => title, (v) => title = v, 'title');
    field(() => taskDescription, (v) => taskDescription = v, 'taskDescription');
    field(() => priority, (v) => priority = v, 'priority', enumValues: TaskPriority.values);
    field(() => checks, (v) => checks = v, 'checks');
    // field(() => login, (v) => login = v, 'login', instance: (data) => LoginModel(data), defect: () => LoginModel());
    // field(() => info, (v) => info = v, 'info', instance: (data) => TaskInfoModel(data), defect: () => TaskInfoModel());
    // field(() => meta, (v) => meta = v, 'meta', instance: (data) => UserMetaModel(data), defect: () => UserMetaModel());
  }

  @override
  TaskHelper helper() => TaskHelper();


  String id;
  String title;
  String taskDescription;
  DateTime created;
  TaskPriority priority;
  bool checks;
  // LoginModel login;
  // TaskInfoModel info;
  // UserMetaModel meta;

   bool filter({String lookup}) =>
       lookup == null ||
       lookup?.toUpperCase()?.split(' ')?.any(
               ($key) => [title].any(($item) => $item != null && $item.toUpperCase().contains($key))) ==
           true;
}

// class TaskInfoModel extends anxeb.Model<TaskInfoModel> {
//   TaskInfoModel([data]) : super(data);

//   @override
//   void init() {
//     field(() => code, (v) => code = v, 'code');
//     field(() => language, (v) => language = v, 'language');
//     field(() => identity, (v) => identity = v, 'identity',
//         instance: (data) => IdentityModel(data), defect: () => IdentityModel());
//     field(() => employeeCode, (v) => employeeCode = v, 'employee_code');
//   }

//   String code;
//   String language;
//   IdentityModel identity;
//   String employeeCode;
// }

// class UserMetaModel extends anxeb.Model<UserMetaModel> {
//   UserMetaModel([data]) : super(data);

//   @override
//   void init() {
//     field(() => contactId, (v) => contactId = v, 'contact_id');
//   }

//   String contactId;
// }

enum TaskPriority { red, orange, yellow, green }
