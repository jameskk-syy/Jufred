import 'package:dairy_app/core/network/network.dart';
import 'package:dairy_app/feature/farmers/data/mappers/mappers.dart';
import 'package:dairy_app/feature/farmers/domain/model/farmer_details_model.dart';
import 'package:dairy_app/feature/farmers/domain/model/onboard_farmer_response.dart';
import 'package:dairy_app/feature/farmers/domain/repository/farmers_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/model/farmers_response_model.dart';
import '../../domain/model/onboard_farmer_details.dart';
import '../datasources/local/farmers_local_data_source.dart';
import '../datasources/remote/farmers_remote_data_source.dart';

class FarmersRepositoryImpl implements FarmersRepository {
  final FarmersRemoteDataSource remoteDataSource;
  final FarmersLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  FarmersRepositoryImpl(
      this.remoteDataSource, this.networkInfo, this.localDataSource);

  @override
  Future<Either<Failure, List<FarmersEntityModel>>> getFarmers(
      int collectorId) async {
    if (await networkInfo.isConnected()) {
      try {
        var logger = Logger();

        logger.e("GOT HEREEEEEEEEEEEEEEEE   111111111");
        final farmers = await remoteDataSource.getFarmers(collectorId);
        //final sortedFarmers = farmers.entity!..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
        farmers.entity!.sort((a, b) => b.farmerNo!.compareTo(a.farmerNo!));
        final farmersResponseModel = FarmersResponseModel(
            entity: farmers.entity!, message: farmers.message);
        final results = farmersResponseModel.entity!
            .map((e) => fromEntityToDomain(e))
            .toList();
        localDataSource.deleteAllFarmers();
        await localDataSource.insertFarmer(results);
        return Right(farmersResponseModel.entity!);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        var logger = Logger();

        logger.e("GOT HEREEEEEEEEEEEEEEEE 2222222222");

        final localData = await localDataSource.getAllFarmers();
        final farmers = localData.map((e) => toEntity(e)).toList();
        return Right(farmers);
      } on DatabaseException catch (exception) {
        return Left(DatabaseFailure(exception.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<FarmersEntityModel>>> getRouteFarmers(
      int collectorId) async {
    // final farmerss = await remoteDataSource.getFarmers(collectorId);
    try {
      print("were hereeeeeeee");
      final localData = await localDataSource.getRouteFarmers(collectorId);
      final farmers = localData.map((e) => toEntity(e)).toList();
      print(farmers);
      return Right(farmers);
    } on DatabaseException catch (exception) {
      return Left(DatabaseFailure(exception.message));
    }
  }

  @override
  Future<Either<Failure, FarmerDetailsEntityModel>> getFarmerDetails(
    int farmerNumber,
    /*int collectorId*/
  ) async {
    if (await networkInfo.isConnected()) {
      try {
        var logger = Logger();

        logger.e("GOT HEREEEEEEEEEEEEEEEE   111111111");

        final farmer = await remoteDataSource
            .getFarmerDetails(farmerNumber /* collectorId*/);
        return Right(farmer.entity!);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        var logger = Logger();
        logger.e("GOT HEREEEEEEEEEEEEEEEE 2222222222");
        final localData =
            await localDataSource.getFarmerByFarmerNo(farmerNumber);
        if (localData != null) {
          final farmer = toFarmerDetailsModel(localData);
          return Right(farmer);
        } else {
          return const Left(DatabaseFailure(
              'Farmer not found. Connect to internet and try again'));
        }
      } on DatabaseException catch (exception) {
        return Left(DatabaseFailure(exception.message));
      }
    }
  }

  @override
  Future<Either<Failure, OnBoardFarmerResponseModel>> addFarmer(
      FarmerOnboardRequestModel farmer) async {
    final log = Logger();
    if (await networkInfo.isConnected()) {
      try {
        final response = await remoteDataSource.addFarmer(farmer);
        if (response.statusCode == 201) {
          log.i(response.message!);
          log.i(response.entity!.farmerNo);
          log.i(response);
          final onBoardFarmerResponseModel = OnBoardFarmerResponseModel(
              message: response.message!,
              statusCode: response.statusCode,
              entity: response.entity!);
          print("$onBoardFarmerResponseModel");
          return Right(onBoardFarmerResponseModel);
        } else {
          return Left(ServerFailure(response.message!));
        }
      } on ServerException catch (e) {
        log.e(e.message);
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure('No internet connection'));
    }
  }
}
