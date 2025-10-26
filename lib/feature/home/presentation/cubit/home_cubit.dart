import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../../core/utils/utils.dart';
import '../../../collections/domain/repository/collections_repository.dart';
import '../../../farmers/domain/repository/farmers_repository.dart';
import '../../../collections/domain/model/monthly_totals_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final FarmersRepository farmersRepository;
  final CollectionsRepository collectionsRepository;

  HomeCubit(this.farmersRepository, this.collectionsRepository)
      : super(const HomeState());

  Future<void> getTotalFarmers(int collectorId) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await farmersRepository.getRouteFarmers(collectorId);
      result.fold(
          (failure) => emit(state.copyWith(
              uiState: UIState.error, exception: mapFailureToMessage(failure))),
          (data) => emit(state.copyWith(
              uiState: UIState.success, totalFarmers: data.length)));
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  Future<void> getTotalCollections(int collectorId, String date) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result =
          await collectionsRepository.getCollectionsByDate(collectorId, date);
      result.fold(
          (failure) => emit(state.copyWith(
              uiState: UIState.error, exception: mapFailureToMessage(failure))),
          (data) => emit(state.copyWith(
              uiState: UIState.success,
              totalCollections: data.entity!.length)));
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  Future<void> getTotalLitres(int collectorId, String date) async {
    final log = Logger();
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result =
          await collectionsRepository.getCollectionsByDate(collectorId, date);
      result.fold(
          (failure) => emit(state.copyWith(
              uiState: UIState.error,
              exception: mapFailureToMessage(failure))), (data) {
        double totalLitres = 0.0;
        for (var element in data.entity!) {
          totalLitres += element.quantity!;
          // log.i('Total Litres: $totalLitres');
          debugPrint('total: $totalLitres');
        }
        emit(
            state.copyWith(uiState: UIState.success, totalLitres: totalLitres));
      });
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  Future<void> getTotalSubCollections(String date) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await collectionsRepository.getCollectionsByDate(42, date);
      result.fold(
          (failure) => emit(state.copyWith(
              uiState: UIState.error, exception: mapFailureToMessage(failure))),
          (data) => emit(state.copyWith(
              uiState: UIState.success, totalSubColl: data.entity!.length)));
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  Future<void> getSubCollectorsTotals(String date) async {
    Logger logger = Logger();
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final response =
          await collectionsRepository.getCollectionsByDate(51, date);
      response.fold(
          (failure) => emit(state.copyWith(
              uiState: UIState.error,
              exception: mapFailureToMessage(failure))), (data) {
        double totalSubLitres = 0.0;
        for (var element in data.entity!) {
          totalSubLitres += element.quantity!;
          logger.i("total sub litres: $totalSubLitres");
        }
        emit(state.copyWith(
          uiState: UIState.success,
          totalSubLitres: totalSubLitres,
        ));
      });
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  Future<void> getMonthlyTotals(int month, int collectorId) async {
    emit(state.copyWith(uiState: UIState.loading));

    try {
      final response =
          await collectionsRepository.getMonthlyTotals(collectorId, month);
      debugPrint("$collectorId $month");
      response.fold(
          (failure) => emit(state.copyWith(
              uiState: UIState.error,
              exception: mapFailureToMessage(failure))), (data) {
        emit(state.copyWith(
            uiState: UIState.success,
            monthlyTotalsModelEntity: data.entity!.first,
            monthlyTotalsModel: data));
      });
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }
}
