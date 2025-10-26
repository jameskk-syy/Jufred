import 'package:equatable/equatable.dart';

class MilkTotalsAccumulationDto extends Equatable {
  int? amount;
  String? collectionDate;
  int? collectorId;
  String? createdAt;
  String? deletedFlag;
  String? deletedOn;
  int? id;
  int? milkQuantity;
  int? routeFk;
  String session;
  int accumulatorId;

  MilkTotalsAccumulationDto(
      {this.amount,
      this.collectionDate,
      this.collectorId,
      this.createdAt,
      this.deletedFlag,
      this.deletedOn,
      this.id,
      required this.session,
        required this.accumulatorId,
      this.milkQuantity,
      this.routeFk});

  factory MilkTotalsAccumulationDto.fromJson(Map<String, dynamic> json) {
    return MilkTotalsAccumulationDto(
      amount: json['amount'],
      collectionDate: json['collectionDate'],
      collectorId: json['collectorId'],
      createdAt: json['createdAt'],
      deletedFlag: json['deletedFlag'],
      deletedOn: json['deletedOn'],
      id: json['id'],
      milkQuantity: json['milkQuantity'],
      routeFk: json['routeFk'],
      session: json['session'],
      accumulatorId: json['accumulatorId']
    );
    /*amount = json['amount'];
    collectionDate = json['collectionDate'];
    collectorId = json['collectorId'];
    createdAt = json['createdAt'];
    deletedFlag = json['deletedFlag'];
    deletedOn = json['deletedOn'];
    id = json['id'];
    milkQuantity = json['milkQuantity'];
    routeFk = json['routeFk'];
    session = json['session'];*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['collectionDate'] = collectionDate;
    data['collectorId'] = collectorId;
    data['createdAt'] = createdAt;
    data['deletedFlag'] = deletedFlag;
    data['deletedOn'] = deletedOn;
    data['id'] = id;
    data['milkQuantity'] = milkQuantity;
    data['routeFk'] = routeFk;
    data['session'] = session;
    data['accumulatorId'] = accumulatorId;
    return data;
  }

  @override
  List<Object?> get props => [
        amount,
        collectionDate,
        collectorId,
        createdAt,
        deletedFlag,
        deletedOn,
        id,
        milkQuantity,
        routeFk,
        session,
    accumulatorId
      ];
}
