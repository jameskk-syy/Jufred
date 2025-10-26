part of 'today_collection_cubit.dart';

class TodayCollectionState extends Equatable {
  final String? exception;
  final UIState uiState;
  final CollectionHistoryModel? collectionHistoryModel;
  const TodayCollectionState({this.uiState = UIState.initial, this.collectionHistoryModel, this.exception});

  @override
  List<Object?> get props => [uiState, collectionHistoryModel, exception];

  TodayCollectionState copyWith({
    String? exception,
    UIState? uiState,
    CollectionHistoryModel? collectionHistoryModel,
  }) {
    return TodayCollectionState(
      exception: exception ?? this.exception,
      uiState: uiState ?? this.uiState,
      collectionHistoryModel: collectionHistoryModel ?? this.collectionHistoryModel,
    );
  }
}


