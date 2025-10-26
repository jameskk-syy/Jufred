import 'package:equatable/equatable.dart';

class LoginResponse extends Equatable{
  int? id;
  String? username;
  String? mobile;
  List<Roles>? roles;
  String? token;

  LoginResponse({this.id, this.username, this.mobile, this.roles, this.token});

  @override
  List<Object?> get props => [id, username, mobile, roles, token];


}

class Roles extends Equatable {
  String? name;
  List<AccessRights>? accessRights;

  Roles({this.name, this.accessRights});

  @override
  List<Object?> get props => [name, accessRights];


  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'accessRights': accessRights?.map((e) => e.toJson()).toList(),
    };
  }


}

class AccessRights extends Equatable{
  String? name;
  String? accessRights;

  AccessRights({this.name, this.accessRights});

  @override
  List<Object?> get props => [name, accessRights];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'accessRights': accessRights,
    };
  }

}