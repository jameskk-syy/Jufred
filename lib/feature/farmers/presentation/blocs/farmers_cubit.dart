import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/utils.dart';
import '../../domain/model/farmers_response_model.dart';
import '../../domain/repository/farmers_repository.dart';

part 'farmers_state.dart';

class FarmersCubit extends Cubit<FarmersState> {
  final FarmersRepository farmersRepository;
  FarmersCubit(this.farmersRepository) : super(const FarmersState());

  Future<void> getFarmers(int collectorId) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await farmersRepository.getFarmers(collectorId);
      result.fold(
          (failure) => emit(state.copyWith(
              uiState: UIState.error, exception: mapFailureToMessage(failure))),
          (data) {
            emit(state.copyWith(uiState: UIState.success, farmersResponseModel: data));
          });
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

}
