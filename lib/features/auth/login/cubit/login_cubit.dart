import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/features/auth/login/cubit/login_state.dart';
import 'package:shop/features/auth/login/data/repo/login_repo.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  static LoginCubit get(context)=> BlocProvider.of(context);
  LoginRepo loginRepo = LoginRepo();
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  bool passwordSecure = true;
  void changePasswordVisibility(){
    passwordSecure = !passwordSecure;
    emit(ChangePasswordVisibility());
  }

  void login() async{
    if(formKey.currentState?.validate() == false) return;

    emit(LoginLoading());
    var result = await loginRepo.login(
      email: emailController.text,
      password: passwordController.text
    );
    result.fold(
      (error) => emit(LoginError(error: error)),
      (userModel) => emit(LoginSuccess(userModel: userModel)),
    );
  }
}