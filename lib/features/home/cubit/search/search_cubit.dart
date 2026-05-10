import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/features/home/cubit/search/search_state.dart';
import 'package:shop/features/home/data/repo/home_repo.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepo searchRepo;
  
  SearchCubit(this.searchRepo) : super(SearchInitial());
  static SearchCubit get(context) => BlocProvider.of(context);
  void search(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial()); // الرجوع للحالة الطبيعية
      return;
    }
    
    emit(SearchLoading());
    final result = await searchRepo.search(query);
    result.fold(
      (failure) => emit(SearchError(failure)),
      (products) => emit(SearchSuccess(products, query: query)),
    );
  }
  


  void clearSearch() {
    emit(SearchInitial()); // مسح نتائج البحث
  }
}