import '../../../feature/auth/domain/models/login_response.dart';

class LoginResponseDto extends LoginResponse {
  LoginResponseDto({super.id, super.username, super.mobile, super.roles, super.token});

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(
      id: json['id'],
      username: json['username'],
      mobile: json['mobile'],
      roles: json['roles'] != null ? (json['roles'] as List).map((i) => RolesDto.fromJson(i)).toList() : null,
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'mobile': mobile,
      'roles': roles?.map((e) => e.toJson()).toList(),
      'token': token,
    };
  }

}

class RolesDto extends Roles {

  RolesDto({super.name, super.accessRights});

  factory RolesDto.fromJson(Map<String, dynamic> json) {
    return RolesDto(
      name: json['name'],
      accessRights: json['accessRights'] != null ? (json['accessRights'] as List).map((i) => AccessRightsDto.fromJson(i)).toList() : null,
    );
  }



}

class AccessRightsDto extends AccessRights {

  AccessRightsDto({super.name, super.accessRights});
  factory AccessRightsDto.fromJson(Map<String, dynamic> json) {
    return AccessRightsDto(
      name: json['name'],
      accessRights: json['accessRights'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'accessRights': accessRights,
    };
  }

}