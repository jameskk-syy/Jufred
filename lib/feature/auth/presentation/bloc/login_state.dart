part of 'login_cubit.dart';

class LoginState extends Equatable {
  final String? exception;
  final UIState uiState;
  final LoginResponse? loginResponse;
  final bool isPasswordVisible;
  const LoginState({this.exception, this.uiState = UIState.initial, this.loginResponse, this.isPasswordVisible = false});

  @override
  List<Object?> get props => [uiState, loginResponse, exception, isPasswordVisible];

  LoginState copyWith({
    String? exception,
    UIState? uiState,
    LoginResponse? loginResponse,
    bool? isPasswordVisible,
  }) {
    return LoginState(
      exception: exception ?? this.exception,
      uiState: uiState ?? this.uiState,
      loginResponse: loginResponse ?? this.loginResponse,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }

}


