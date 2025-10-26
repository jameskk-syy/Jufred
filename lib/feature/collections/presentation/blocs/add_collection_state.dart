part of 'add_collection_cubit.dart';

 class AddCollectionState extends Equatable {
  final String? exception;
  final UIState uiState;
  final CollectionResponse? collectionResponse;
 const  AddCollectionState({this.exception, this.uiState = UIState.initial, this.collectionResponse});

  @override
  List<Object?> get props => [exception, uiState, collectionResponse];

  AddCollectionState copyWith({
    String? exception,
    UIState? uiState,
    CollectionResponse? collectionResponse,
  }) {
    return AddCollectionState(
      exception : exception ?? this.exception,
      uiState: uiState ?? this.uiState,
      collectionResponse: collectionResponse ?? this.collectionResponse,
    );
  }
}


