import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/features/home/cubit/category_state.dart';
import 'package:shop/features/home/data/models/category_model.dart';
import 'package:shop/features/home/data/repo/home_repo.dart';


class CategoriesCubit extends Cubit<CategoriesState>{

  CategoriesCubit(this.repo) : super(CategoriesInitial());
  final HomeRepo repo;
  static CategoriesCubit get(context) => BlocProvider.of(context);
  List<CategoryModel>? categories;

  int currentIndex = 0;
  void onCategoryTapped(int newIndex){
    currentIndex = newIndex;
    emit(CategoriesIndexChanged());
  }
  void getCategories()async{
    emit(CategoriesLoading());
    var result = await repo.getCategories();
    result.fold(
      (error) => emit(CategoriesError(error: error)),
      (categories) {
        this.categories = categories;
        emit(CategoriesSuccess());
      }
    );
  }
}