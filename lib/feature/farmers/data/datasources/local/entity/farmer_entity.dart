import 'package:dairy_app/core/utils/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@Entity(tableName: Constants.kFarmersTable)
class FarmerEntity extends Equatable {
  @primaryKey
  int id;
  String username;
  String firstName;
  String lastName;
  String idNumber;
  int farmerNo;
  String mobileNo;
  String alternativeMobileNo;
  String memberType;

  //BankDetailsModel? bankDetails;
  String address;
  String paymentFreequency;
  String paymentDate;
  String paymentMode;
  String createdAt;
  String deletedFlag;
  String deletedOn;
  String location;
  String subLocation;
  String village;
  int countyFk;
  int subcountyFk;
  int wardFk;
  String noOfCows;
  int routeFk;
  String transportMeans;
  String gender;
  String routeName;

  FarmerEntity(
      {required this.gender,
      required this.transportMeans,
      required this.farmerNo,
      required this.username,
      required this.subLocation,
      required this.location,
      required this.createdAt,
      required this.idNumber,
      required this.mobileNo,
      required this.lastName,
      required this.address,
      required this.memberType,
      required this.paymentFreequency,
      required this.firstName,
      required this.village,
      required this.subcountyFk,
      required this.routeFk,
      required this.paymentDate,
      required this.deletedOn,
      required this.countyFk,
      required this.id,
      required this.noOfCows,
      required this.alternativeMobileNo,
      required this.deletedFlag,
      required this.paymentMode,
        required this.routeName,
      required this.wardFk});

  @override
  List<Object?> get props => [
        id,
        username,
        firstName,
        lastName,
        idNumber,
        farmerNo,
        mobileNo,
        alternativeMobileNo,
        memberType,
        address,
        paymentFreequency,
        paymentDate,
        paymentMode,
        createdAt,
        deletedFlag,
        deletedOn,
        location,
        subLocation,
        village,
        countyFk,
        subcountyFk,
        wardFk,
        noOfCows,
        routeFk,
        transportMeans,
        gender,
        routeName
      ];
}
