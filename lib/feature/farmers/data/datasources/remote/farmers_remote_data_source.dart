import 'package:dairy_app/core/data/dto/farmers_response_dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../../../../../core/data/dto/farmer_details_dto.dart';
import '../../../../../core/data/dto/onboard_farmer_request_dto.dart';
import '../../../../../core/data/dto/onboard_farmer_response_dto.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/utils/constants.dart';

abstract class FarmersRemoteDataSource {
  Future<FarmerResponseDto> getFarmers(int collectorId);
  Future<FarmerDetailsDto> getFarmerDetails(
    int farmerNumber,
    /*int collectorId*/
  );
  //Future<Either<Failure, Unit>> addFarmer(Map<String, dynamic> farmer);
  Future<OnBoardFarmerResponseDto> addFarmer(FarmerOnboardRequestDto2 farmer);
}

class FarmersRemoteDataSourceImpl implements FarmersRemoteDataSource {
  final Dio dio;

  FarmersRemoteDataSourceImpl(this.dio);

  @override
  Future<FarmerResponseDto> getFarmers(int collectorId) async {
    final log = Logger();
    try {
      final response = await dio.get(
          '${Constants.kBaserUrl}farmer/farmers/collector',
          queryParameters: {'collectorId': collectorId});
      log.i(response.data.length);
      return FarmerResponseDto.fromJson(response.data);
    } catch (exception) {
      if (kDebugMode) {
        log.e(exception.toString());
      }
      throw ServerException(message: exception.toString());
    }
  }

  @override
  Future<FarmerDetailsDto> getFarmerDetails(
    int farmerNumber,
    /*int collectorId*/
  ) async {
    final log = Logger();
    try {
      final response = await dio
          .get('${Constants.kBaserUrl}farmer/membernumber', queryParameters: {
        'farmer_number': farmerNumber,
        //'collectorId': collectorId
      });
      /*if (response.statusCode == 200) {
        log.i(response.data);
        return FarmerDetailsDto.fromJson(response.data);
      } else {
        throw ServerException(message: response.statusMessage!);
      }*/

      //log.i(response.statusCode);

      log.i(response.data);
      return FarmerDetailsDto.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        log.e(e.toString());
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<OnBoardFarmerResponseDto> addFarmer(
      FarmerOnboardRequestDto2 farmer) async {
    final log = Logger();
    try {
      final response = await dio.post('${Constants.kBaserUrl}farmer/add',
          data: farmer.toJson());
      if (kDebugMode) {
        print(response);
      }
      return OnBoardFarmerResponseDto.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        log.e(e.toString());
      }
      throw ServerException(message: e.toString());
    }
  }
}
