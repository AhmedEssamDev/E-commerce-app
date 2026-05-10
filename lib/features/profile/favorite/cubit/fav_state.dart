abstract class FavState {}

class FavInitial extends FavState {}
class FavLoading extends FavState {}
class FavSuccess extends FavState {}
class FavError extends FavState {
  final String message;
  FavError(this.message);
}