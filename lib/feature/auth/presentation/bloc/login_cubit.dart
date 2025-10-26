import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/models/login_response.dart';
import '../../domain/repository/login_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository loginRepository;
  LoginCubit(this.loginRepository) : super(const LoginState());

  Future<void> login(String username, String password) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await loginRepository.login(username, password);
      result.fold(
          (failure) => emit(state.copyWith(
              uiState: UIState.error, exception: mapFailureToMessage(failure))),
          (data) => emit(state.copyWith(uiState: UIState.success, loginResponse: data)));
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  void obscurePassword(bool obscure) {
    emit(state.copyWith(isPasswordVisible: obscure, uiState: UIState.initial));
  }

}
