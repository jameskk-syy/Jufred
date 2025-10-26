import 'package:equatable/equatable.dart';

class FarmerDetailsModel extends Equatable {
  String? message;
  int? statusCode;
  FarmerDetailsEntityModel? entity;

  FarmerDetailsModel({this.entity, this.message, this.statusCode});


  @override
  List<Object?> get props => [message, statusCode, entity];
}

class FarmerDetailsEntityModel extends Equatable {
  int? id;
  String? county;
  int? farmerNo;
  String? mobileNo;
  String? createdAt;
  String? subcounty;
  String? route;
  String? pickUpLocation;
  String? username;
  String? alternativeMobileNo;
  String? lastName;
  String? accountNumber;
  String? noOfCows;
  String? memberType;
  int? routeId;
  String? deletedFlag;
  String? paymentFreequency;
  String? idNumber;
  String? accountName;
  String? paymentMode;
  String? location;
  String? subLocation;

  FarmerDetailsEntityModel({this.id, this.idNumber, this.county, this.noOfCows, this.route, this.pickUpLocation, this.username, this.accountName, this.accountNumber, this.alternativeMobileNo, this.createdAt, this.deletedFlag, this.farmerNo, this.lastName, this.memberType, this.mobileNo, this.location, this.subLocation, this.paymentFreequency, this.paymentMode, this.routeId, this.subcounty});

  @override
  List<Object?> get props => [
    id,
    idNumber,
    county,
    noOfCows,
    route,
    pickUpLocation,
    username,
    accountName,
    accountNumber,
    alternativeMobileNo,
    createdAt,
    deletedFlag,
    farmerNo,
    lastName,
    memberType,
    mobileNo,
    paymentFreequency,
    paymentMode,
    routeId,
    subcounty,
    location,
    subLocation
  ];
}