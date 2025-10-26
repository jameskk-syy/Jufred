import 'package:dairy_app/config/theme/colors.dart';
import 'package:dairy_app/core/presentation/navigation/navigation_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injector_container.dart';
import '../../../../core/utils/utils.dart';
import '../bloc/login_cubit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';


class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final resetPasswordController = TextEditingController();
  static bool _isLoading = false;
  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodePassword = FocusNode();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(
          create: (context) => sl<LoginCubit>(),
        ),
        /*BlocProvider<TogglePasswordCubit>(
          create: (context) => sl<TogglePasswordCubit>(),
        ),*/
      ],
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.uiState == UIState.success) {
            // Login successful, close the progress dialog
            // Navigator.pop(context);
            _toggleLoadingState();
            // Show success message
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const BottomNavigationContainer()));
          } else if (state.uiState == UIState.error) {
            // Login failed, close the progress dialog

            _toggleLoadingState();
            final exception = state.exception;
            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.scale,
              title: 'Error',
              desc: exception,
              btnOkOnPress: () {},
            ).show();
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.lightColorScheme.primaryContainer,
                    AppColors.lightColorScheme.secondaryContainer,
                    AppColors.lightColorScheme.tertiaryContainer,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/milk_logo.png',
                      height: 100,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Card(
                          elevation: 2.0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: SizedBox(
                            width: 300.0,
                            height: 160.0,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0,
                                      bottom: 10.0,
                                      left: 25.0,
                                      right: 25.0),
                                  child: TextField(
                                    focusNode: focusNodeEmail,
                                    controller: userNameController,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(fontSize: 14.0),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(
                                        Icons.account_circle_sharp,
                                        color:
                                            AppColors.lightColorScheme.primary,
                                        size: 18.0,
                                      ),
                                      hintText: 'User Name',
                                      hintStyle:
                                          const TextStyle(fontSize: 14.0),
                                    ),
                                    onSubmitted: (_) {
                                      focusNodePassword.requestFocus();
                                    },
                                  ),
                                ),
                                Container(
                                  width: 250.0,
                                  height: 1.0,
                                  color: Colors.grey[400],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 10.0,
                                      left: 25.0,
                                      right: 25.0),
                                  child: TextField(
                                    focusNode: focusNodePassword,
                                    controller: passwordController,
                                    obscureText: !state.isPasswordVisible,
                                    style: const TextStyle(fontSize: 14.0),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(
                                        Icons.lock,
                                        size: 18.0,
                                        color:
                                            AppColors.lightColorScheme.primary,
                                      ),
                                      hintText: 'Password',
                                      hintStyle:
                                          const TextStyle(fontSize: 14.0),
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          BlocProvider.of<LoginCubit>(context)
                                              .obscurePassword(
                                            !BlocProvider.of<LoginCubit>(
                                                    context)
                                                .state
                                                .isPasswordVisible,
                                          );
                                        },
                                        child: Icon(
                                          BlocProvider.of<LoginCubit>(context)
                                                  .state
                                                  .isPasswordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: isDarkMode
                                              ? AppColors
                                                  .darkColorScheme.primary
                                              : AppColors
                                                  .lightColorScheme.primary,
                                          size: 18.0,
                                        ),
                                      ),
                                    ),
                                    textInputAction: TextInputAction.go,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: RawMaterialButton(
                        shape: const CircleBorder(),
                        onPressed: () {
                          _isLoading ? null : login(context);
                        },
                        elevation: 2.0,
                        fillColor: AppColors.lightColorScheme.primary,
                        padding: const EdgeInsets.all(15.0),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 20.0,
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Forgot Password'),
                                  content: TextFormField(
                                    controller: resetPasswordController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: const TextStyle(
                                        fontSize: 14.0, color: Colors.black),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(
                                        Icons.email,
                                        color: Colors.black,
                                        size: 18.0,
                                      ),
                                      hintText: 'Email Address',
                                      hintStyle: TextStyle(fontSize: 14.0),
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Send code'),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.black,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void login(BuildContext context) {
    final email = userNameController.text.trim();
    final password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username and password cannot be empty'),
        ),
      );
      //hideKeyboard(context);
      _toggleLoadingState();
      return;
    }
    hideKeyboard(context);
    _toggleLoadingState();
    /*showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );*/
    context.read<LoginCubit>().login(email, password);
  }

  void _toggleLoadingState() {
    _isLoading = !_isLoading;
  }

  void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
