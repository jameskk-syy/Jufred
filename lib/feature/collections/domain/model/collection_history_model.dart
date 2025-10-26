
import 'package:equatable/equatable.dart';

class CollectionHistoryModel extends Equatable {
  final String? message;
  final int? statusCode;
  List<CollectionHistoryEntityModel>? entity;

  CollectionHistoryModel({this.message, this.statusCode, this.entity});

  @override
  List<Object?> get props => [message, statusCode, entity];
}

class CollectionHistoryEntityModel extends Equatable {
  int? id;
  String? date;
  String? session;
  int? farmerNo;
  double? quantity;
  double? originalQuantity;
  double? currentPrice;
  String? canNo;
  String? ward;
  String? farmer;
  String? collectionDate;
  String? route;
  String? pickUpLocation;
  double? amount;
  String? collector;
  String? event;
  String? paymentStatus;
  String? collectionCode;
  String? firstName;
  String? lastName;
  String? productType;
  int? farmerId;
  String? updateStatus;

  CollectionHistoryEntityModel(
      {this.id,
        this.date,
        this.session,
        this.farmerNo,
        this.quantity,
        this.originalQuantity,
        this.currentPrice,
        this.canNo,
        this.ward,
        this.farmer,
        this.collectionDate,
        this.route,
        this.pickUpLocation,
        this.amount,
        this.collector,
        this.event,
        this.paymentStatus,
        this.collectionCode,
        this.firstName,
        this.lastName,
        this.productType,
        this.farmerId,
        this.updateStatus});

  @override
  List<Object?> get props => [
    id,
    date,
    session,
    farmerNo,
    quantity,
    originalQuantity,
    currentPrice,
    canNo,
    ward,
    farmer,
    collectionDate,
    route,
    pickUpLocation,
    amount,
    collector,
    event,
    paymentStatus,
    collectionCode,
    firstName,
    lastName,
    productType,
    farmerId,
    updateStatus
  ];
}