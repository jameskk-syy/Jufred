import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/utils/utils.dart';
import '../../../../farmers/domain/model/farmer_details_model.dart';
import '../../../../farmers/domain/repository/farmers_repository.dart';

part 'farmer_details_cubit_state.dart';

class FarmerDetailsCubit extends Cubit<FarmerDetailsCubitState> {
  final FarmersRepository farmersRepository;
  FarmerDetailsCubit(this.farmersRepository) : super(const FarmerDetailsCubitState());

  Future<void> getFarmerDetails(/*int collectorId,*/ int farmerNumber) async {
    emit(state.copyWith(uiState: UIState.loading));
    try{
      final results = await farmersRepository.getFarmerDetails(farmerNumber, /*collectorId*/);
      results.fold((failure) =>  emit(state.copyWith(uiState: UIState.error, exception: mapFailureToMessage(failure))),
       (data) => emit(state.copyWith(uiState: UIState.success, farmerDetailsModel: data)));
    } on Exception catch (e){
            emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }
}
