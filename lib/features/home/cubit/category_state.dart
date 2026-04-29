
abstract class CategoriesState {}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesIndexChanged extends CategoriesState {}

class CategoriesSuccess extends CategoriesState {}

class CategoriesError extends CategoriesState {
  String error;
  CategoriesError({required this.error});
}