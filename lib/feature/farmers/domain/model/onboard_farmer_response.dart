
import 'package:equatable/equatable.dart';

class OnBoardFarmerResponseModel extends Equatable {
  String? message;
  int? statusCode;
  OnBoardFarmerEntityModel? entity;

  OnBoardFarmerResponseModel({this.message, this.statusCode, this.entity});

  @override
  List<Object?> get props => [message, statusCode, entity];


}

class OnBoardFarmerEntityModel extends Equatable {
  int? farmerNo;
  String? userName;

  OnBoardFarmerEntityModel({this.farmerNo, this.userName});

  @override
  List<Object?> get props {
    return [farmerNo, userName];
  }
}