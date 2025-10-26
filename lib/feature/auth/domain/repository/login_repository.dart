import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../models/login_response.dart';

abstract class LoginRepository {
  Future<Either<Failure, LoginResponse>> login(String username, String password);
}