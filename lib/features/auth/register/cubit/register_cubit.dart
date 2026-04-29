import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/features/auth/register/cubit/register_state.dart';
import 'package:shop/features/auth/register/data/repo/register_repo.dart';

class RegisterCubit extends Cubit<RegisterState> {
    RegisterCubit() : super(RegisterInitial());
    RegisterRepo registerRepo = RegisterRepo();
    static RegisterCubit get(context)=> BlocProvider.of(context);
    final formKey = GlobalKey<FormState>();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final emailController = TextEditingController();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    bool passwordSecure = true;
    void changePasswordVisibility(){
      passwordSecure = !passwordSecure;
      emit(ChangePasswordVisibility());
    }
    void register() async{
      if(formKey.currentState?.validate() == false) return;
      emit(RegisterLoading());  
      var result = await registerRepo.register(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
        phone: phoneController.text
      );
    result.fold(
      (error) => emit(RegisterError(error: error)),
      (success) => emit(RegisterSuccess(message: success)),
    );
  }
} 
