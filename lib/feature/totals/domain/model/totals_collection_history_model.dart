

import 'package:equatable/equatable.dart';

class TotalsCollectionHistoryModel extends Equatable {
  String? message;
  int? statusCode;
  List<TotalsCollectionHistoryEntity>? entity;

  TotalsCollectionHistoryModel({this.message, this.statusCode, this.entity});

  @override
  List<Object?> get props => [message, statusCode, entity];
}

class TotalsCollectionHistoryEntity extends Equatable {
  int? id;
  double? milkQuantity;
  double? amount;
  int? routeFk;
  String? route;
  int? collectorId;
  String? session;
  String? collectionDate;
  String? createdAt;
  String? deletedFlag;
  String? deletedOn;

  TotalsCollectionHistoryEntity(
      {this.id,
      this.milkQuantity,
      this.amount,
      this.routeFk,
      this.route,
      this.collectorId,
      this.session,
      this.collectionDate,
      this.createdAt,
      this.deletedFlag,
      this.deletedOn});
  @override
  List<Object?> get props => [
        id,
        milkQuantity,
        amount,
        routeFk,
        route,
        collectorId,
        session,
        collectionDate,
        createdAt,
        deletedFlag,
        deletedOn
      ];
}