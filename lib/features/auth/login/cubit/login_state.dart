import 'package:shop/features/auth/login/data/model/user_model.dart';

abstract class LoginState{}

class LoginInitial extends LoginState{}

class LoginLoading extends LoginState{}

class LoginSuccess extends LoginState{
  UserModel userModel;
  LoginSuccess({required this.userModel});

}

class LoginError extends LoginState{
  String error;
  LoginError({required this.error});
}

class ChangePasswordVisibility extends LoginState{}