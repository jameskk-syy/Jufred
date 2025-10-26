
import 'package:equatable/equatable.dart';

class AddMilkAccumulationResponse extends Equatable {
  final String message;
  final int statusCode;

  const AddMilkAccumulationResponse({
    required this.message,
    required this.statusCode,
  });

  @override
  List<Object?> get props => [
    message,
    statusCode,
  ];


}