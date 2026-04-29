import 'package:shop/features/auth/login/data/model/user_model.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserSuccess extends UserState {
  final UserModel user;
  UserSuccess({required this.user});
}

class UserError extends UserState {
  final String error;
  UserError({required this.error});
}


