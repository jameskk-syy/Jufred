import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../model/farmer_details_model.dart';
import '../model/farmers_response_model.dart';
import '../model/onboard_farmer_details.dart';
import '../model/onboard_farmer_response.dart';

abstract class FarmersRepository {
  Future<Either<Failure, List<FarmersEntityModel>>> getRouteFarmers(int collectorId);
  Future<Either<Failure, List<FarmersEntityModel>>> getFarmers(int collectorId);
  Future<Either<Failure, FarmerDetailsEntityModel>> getFarmerDetails(
    int farmerNumber,
    /* int collectorId*/
  );
  Future<Either<Failure, OnBoardFarmerResponseModel>> addFarmer(
      FarmerOnboardRequestModel farmer);
}
