// update_profile_state.dart
abstract class UpdateProfileState {}

class UpdateProfileInitial extends UpdateProfileState {}

class UpdateProfileLoading extends UpdateProfileState {}

class UpdateProfileSuccess extends UpdateProfileState {
  final String message;
  UpdateProfileSuccess({required this.message});
}

class UpdateProfileError extends UpdateProfileState {
  final String error;
  UpdateProfileError({required this.error});
}