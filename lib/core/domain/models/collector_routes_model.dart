import 'package:equatable/equatable.dart';

class CollectorRoutesModel extends Equatable {
  String? message;
  int? statusCode;
  List<CollectorRoutesEntityResponse>? entity;

  CollectorRoutesModel({this.entity, this.statusCode, this.message});

  @override
  List<Object?> get props => [message, statusCode, entity];
}

class CollectorRoutesEntityResponse extends Equatable {
  int? id;
  String? route;
  String? routeCode;
  String? collectors;

  CollectorRoutesEntityResponse({this.id, this.route, this.routeCode, this.collectors});

  @override
  List<Object?> get props => [id, route, routeCode, collectors];
}