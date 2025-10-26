import 'package:equatable/equatable.dart';

class FarmersResponseModel extends Equatable {
  String? message;
  int? statusCode;
  List<FarmersEntityModel>? entity;

  FarmersResponseModel({this.message, this.statusCode, this.entity});

  @override
  List<Object?> get props => [message, statusCode, entity];
}

class FarmersEntityModel extends Equatable {
  String? routeName;
  int? id;
  String? username;
  String? firstName;
  String? lastName;
  String? idNumber;
  int? farmerNo;
  String? mobileNo;
  String? alternativeMobileNo;
  String? memberType;
  BankDetailsModel? bankDetails;
  String? address;
  String? paymentFreequency;
  String? paymentDate;
  String? paymentMode;
  String? createdAt;
  String? deletedFlag;
  String? deletedOn;
  String? location;
  String? subLocation;
  String? village;
  int? countyFk;
  int? subcountyFk;
  int? wardFk;
  String? noOfCows;
  int? routeFk;
  String? transportMeans;
  String? gender;

  FarmersEntityModel({
    this.paymentMode,
    this.paymentFreequency,
    this.mobileNo,
    this.memberType,
    this.lastName,
    this.farmerNo,
    this.deletedFlag,
    this.createdAt,
    this.alternativeMobileNo,
    this.username,
    this.noOfCows,
    this.idNumber,
    this.id,
    this.routeName,
    this.address,
    this.bankDetails,
    this.countyFk,
    this.deletedOn,
    this.firstName,
    this.gender,
    this.location,
    this.paymentDate,
    this.routeFk,
    this.subcountyFk,
    this.subLocation,
    this.transportMeans,
    this.village,
    this.wardFk,
  });

  @override
  List<Object?> get props => [
    paymentMode,
    paymentFreequency,
   mobileNo,
    memberType,
    lastName,
    farmerNo,
    deletedFlag,
    createdAt,
    alternativeMobileNo,
    username,
    noOfCows,
    idNumber,
    id,
    routeName,
    address,
    bankDetails,
    countyFk,
    deletedOn,
    firstName,
    gender,
    location,
    paymentDate,
    routeFk,
    subcountyFk,
    subLocation,
    transportMeans,
    village,
    wardFk,
  ];
}

class BankDetailsModel extends Equatable {
  int? id;
  String? bankName;
  String? accountName;
  String? accountNumber;
  String? branch;
  String? otherMeans;
  String? otherMeansDetails;

  BankDetailsModel(
      {this.id,
      this.bankName,
      this.accountName,
      this.accountNumber,
      this.branch,
      this.otherMeans,
      this.otherMeansDetails});

  @override
  List<Object?> get props {
    return [
      id,
      bankName,
      accountName,
      accountNumber,
      branch,
      otherMeans,
      otherMeansDetails
    ];
  }
}
