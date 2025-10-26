part of 'add_accumulative_collection_cubit.dart';

class AddAccumulativeCollectionState extends Equatable {
  String? message;
  UIState uiState;
  String? exception;
  AddAccumulativeCollectionState({this.message, this.uiState = UIState.initial, this.exception});

  @override
  List<Object?> get props => [message, uiState, exception];

  AddAccumulativeCollectionState copyWith({
    String? message,
    UIState? uiState,
    String? exception,
  }) {
    return AddAccumulativeCollectionState(
      message: message ?? this.message,
      uiState: uiState ?? this.uiState,
      exception: exception ?? this.exception,
    );
  }
}


