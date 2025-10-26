import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/data/dto/login_response_dto.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/constants.dart';

abstract class LoginRemoteDataSource {
  Future<LoginResponseDto> login(String username, String password);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final Dio dio;
  LoginRemoteDataSourceImpl(this.dio);

  @override
  Future<LoginResponseDto> login(String username, String password) async {
    final log = Logger();
    try {
      final response = await dio.post(
          '${Constants.kBaserUrl}authentication/login',
          data: {'username': username, 'password': password});
      log.i(("GOT HEREEEEEEEEE"));
      var resp = LoginResponseDto.fromJson(response.data['entity']);
      log.i(resp);
      return resp;
    } catch (exception) {
      log.e(exception.toString());
      throw const ServerException(
          message: "Wrong credentials. Check your username and password");
    }
  }
}
