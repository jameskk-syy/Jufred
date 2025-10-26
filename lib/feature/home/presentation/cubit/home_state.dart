part of 'home_cubit.dart';

class HomeState extends Equatable {
  final String? exception;
  final UIState uiState;
  final int totalFarmers;
  final int totalCollections;
  final double totalLitres;
  final double totalSubLitres;
  final int totalSubColl;
  final MonthlyTotalsModelEntity? monthlyTotalsModelEntity;
  final MonthlyTotalsModel? monthlyTotalsModel;

  const HomeState(
      {this.uiState = UIState.initial,
      this.exception,
      this.totalLitres = 0.0,
      this.totalSubLitres = 0.0,
      this.totalSubColl = 0,
      this.monthlyTotalsModelEntity,
      this.monthlyTotalsModel,
      /*this.farmersResponseModel*/ this.totalFarmers = 0,
      this.totalCollections = 0});

  @override
  List<Object?> get props => [
        exception,
        uiState,
        totalFarmers,
        totalCollections,
        totalLitres,
        totalSubLitres,
        totalSubColl,
        monthlyTotalsModelEntity,
        monthlyTotalsModel
      ];

  HomeState copyWith(
      {String? exception,
      UIState? uiState,
      int? totalFarmers,
      int? totalCollections,
      double? totalLitres,
      double? totalSubLitres,
      int? totalSubColl,
      MonthlyTotalsModelEntity? monthlyTotalsModelEntity,
      MonthlyTotalsModel? monthlyTotalsModel
      // FarmersResponseModel? farmersResponseModel,
      }) {
    return HomeState(
        exception: exception ?? this.exception,
        uiState: uiState ?? this.uiState,
        totalFarmers: totalFarmers ?? this.totalFarmers,
        totalCollections: totalCollections ?? this.totalCollections,
        totalLitres: totalLitres ?? this.totalLitres,
        totalSubLitres: totalSubLitres ?? this.totalSubLitres,
        totalSubColl: totalSubColl ?? this.totalSubColl,
        monthlyTotalsModelEntity:
            monthlyTotalsModelEntity ?? this.monthlyTotalsModelEntity,
        monthlyTotalsModel: monthlyTotalsModel ?? this.monthlyTotalsModel
            );
  }
}
