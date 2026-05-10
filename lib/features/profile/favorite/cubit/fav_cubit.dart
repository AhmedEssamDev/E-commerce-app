import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/features/profile/favorite/cubit/fav_state.dart';
import 'package:shop/features/profile/favorite/data/fav_repo.dart';

class FavCubit extends Cubit<FavState> {
  final FavRepo favRepo;
  FavCubit(this.favRepo) : super(FavInitial());

  static FavCubit get(context) => BlocProvider.of(context);

  Future<void> toggleFavorite(int productId) async {
    emit(FavLoading());
    var result = await favRepo.addToFavorite(productId);
    result.fold(
      (error) => emit(FavError(error)),
      (success) => emit(FavSuccess()),
    );
  }
}
