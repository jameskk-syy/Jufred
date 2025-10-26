part of 'add_farmer_cubit.dart';

class AddFarmerState extends Equatable {
  final String? exception;
  final UIState uiState;
  final CountiesResponseModel? countiesResponseModel;
  final SubCountiesResponseModel? subCountiesResponseModel;
  final PickupLocationModel? pickupLocationModel;
  final RoutesResponseModel? routesResponseModel;
  final OnBoardFarmerResponseModel? onBoardFarmerResponseModel;
  OnBoardFarmerResponseDto? onBoardFarmerResponseDto;

  AddFarmerState(
      {this.uiState = UIState.initial,
      this.exception,
      this.countiesResponseModel,
      this.subCountiesResponseModel,
      this.pickupLocationModel,
      this.routesResponseModel,
      this.onBoardFarmerResponseModel,
      this.onBoardFarmerResponseDto
      });

  @override
  List<Object?> get props => [
        uiState,
        exception,
        countiesResponseModel,
        subCountiesResponseModel,
        pickupLocationModel,
        routesResponseModel,
        onBoardFarmerResponseModel,
        onBoardFarmerResponseDto
      ];

  AddFarmerState copyWith(
      {String? exception,
      UIState? uiState,
      CountiesResponseModel? countiesResponseModel,
      SubCountiesResponseModel? subCountiesResponseModel,
      PickupLocationModel? pickupLocationModel,
      RoutesResponseModel? routesResponseModel,
      OnBoardFarmerResponseModel? onBoardFarmerResponseModel,
      OnBoardFarmerResponseDto? onBoardFarmerResponseDto}) {
    return AddFarmerState(
        exception: exception ?? this.exception,
        uiState: uiState ?? this.uiState,
        countiesResponseModel:
            countiesResponseModel ?? this.countiesResponseModel,
        subCountiesResponseModel:
            subCountiesResponseModel ?? this.subCountiesResponseModel,
        pickupLocationModel: pickupLocationModel ?? this.pickupLocationModel,
        routesResponseModel: routesResponseModel ?? this.routesResponseModel,
        onBoardFarmerResponseModel:
            onBoardFarmerResponseModel ?? this.onBoardFarmerResponseModel,
        onBoardFarmerResponseDto: onBoardFarmerResponseDto ?? this.onBoardFarmerResponseDto);
  }
}
