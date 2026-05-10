import 'package:shop/features/home/data/models/search_model.dart';

abstract class SearchState {}

// حالات SearchState
class SearchInitial extends SearchState {}
class SearchLoading extends SearchState {}
class SearchSuccess extends SearchState {
  final List<ProductsSearch> products;
  final String query; // مهم لمعرفة إذا كان البحث نشط
  SearchSuccess(this.products, {required this.query});
}
class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}