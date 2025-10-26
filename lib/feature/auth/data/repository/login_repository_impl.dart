import 'package:dairy_app/core/data/datasources/local/datasource/core_local_datasource.dart';
import 'package:dairy_app/core/errors/failures.dart';
import 'package:dairy_app/feature/auth/domain/models/login_response.dart';
import 'package:dairy_app/feature/auth/domain/repository/login_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network.dart';
import '../datasources/login_remote_data_source.dart';

class LoginRepositoryImpl implements LoginRepository{
  final NetworkInfo networkInfo;
  final LoginRemoteDataSource remoteDataSource;
  final CoreLocalDataSource localDataSource;

  LoginRepositoryImpl(this.networkInfo, this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<Failure, LoginResponse>> login(String username, String password) async {
    if(await networkInfo.isConnected()){
      try{
        final remoteLogin = await remoteDataSource.login(username, password);
        await localDataSource.saveUserData(remoteLogin);
        await localDataSource.setIsLoggedIn(true);
        return Right(remoteLogin);
      }
      on ServerException catch(e) {
        return Left(ServerFailure(e.message));
      }
    }else {
      return const Left(ServerFailure('No Internet Connection'));
    }
  }

}