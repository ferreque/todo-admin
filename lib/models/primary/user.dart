import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/helpers/user.dart';
import 'package:todo_admin/models/common/identity.dart';
import 'package:todo_admin/models/common/login.dart';

class UserModel extends anxeb.HelpedModel<UserModel, UserHelper> {
  UserModel([data]) : super(data);

  @override
  void init() {
  
    field(() => id, (v) => id = v, 'id', primary: true);
    field(() => firstNames, (v) => firstNames = v, 'first_names');
    field(() => lastNames, (v) => lastNames = v, 'last_names');
    field(() => role, (v) => role = v, 'role', enumValues: UserRole.values);
    field(() => login, (v) => login = v, 'login', instance: (data) => LoginModel(data), defect: () => LoginModel());
    field(() => info, (v) => info = v, 'info', instance: (data) => UserInfoModel(data), defect: () => UserInfoModel());
    field(() => meta, (v) => meta = v, 'meta', instance: (data) => UserMetaModel(data), defect: () => UserMetaModel());
  }

  @override
  UserHelper helper() => UserHelper();

  @override
  String toString() => fullName;

  String id;
  String firstNames;
  String lastNames;
  DateTime created;
  UserRole role;
  LoginModel login;
  UserInfoModel info;
  UserMetaModel meta;

  String get fullName => ('$firstNames $lastNames'.trim());

  String get lightName => anxeb.Utils.convert.fromNamesToFullName(firstNames, lastNames);

  bool filter({String lookup}) =>
      lookup == null ||
      lookup?.toUpperCase()?.split(' ')?.any(
              ($key) => [fullName, login.email].any(($item) => $item != null && $item.toUpperCase().contains($key))) ==
          true;
}

class UserInfoModel extends anxeb.Model<UserInfoModel> {
  UserInfoModel([data]) : super(data);

  @override
  void init() {
    field(() => code, (v) => code = v, 'code');
    field(() => language, (v) => language = v, 'language');
    field(() => identity, (v) => identity = v, 'identity',
        instance: (data) => IdentityModel(data), defect: () => IdentityModel());
    field(() => employeeCode, (v) => employeeCode = v, 'employee_code');
  }

  String code;
  String language;
  IdentityModel identity;
  String employeeCode;
}

class UserMetaModel extends anxeb.Model<UserMetaModel> {
  UserMetaModel([data]) : super(data);

  @override
  void init() {
    field(() => contactId, (v) => contactId = v, 'contact_id');
  }

  String contactId;
}
enum UserRole { admin, client, broker }
