part of 'farmers_cubit.dart';

class FarmersState extends Equatable {
  final String? exception;
  final UIState uiState;
  final List<FarmersEntityModel>? farmersResponseModel;
  const FarmersState({this.exception, this.uiState = UIState.initial, this.farmersResponseModel});

  @override
  List<Object?> get props => [uiState, farmersResponseModel, exception];

  FarmersState copyWith({
    String? exception,
    UIState? uiState,
    List<FarmersEntityModel>? farmersResponseModel,
  }) {
    return FarmersState(
      exception: exception ?? this.exception,
      uiState: uiState ?? this.uiState,
      farmersResponseModel: farmersResponseModel ?? this.farmersResponseModel,
    );
  }

}


