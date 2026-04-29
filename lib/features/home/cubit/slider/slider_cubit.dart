// sliders_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/features/home/cubit/slider/slider_state.dart';
import 'package:shop/features/home/data/models/sliders_model.dart';
import 'package:shop/features/home/data/repo/home_repo.dart';

class SlidersCubit extends Cubit<SlidersState> {
  final SlidersRepo slidersRepo;
  SlidersCubit(this.slidersRepo) : super(SlidersInitial());

  static SlidersCubit get(context) => BlocProvider.of(context);

  List<SliderModel>? sliders;

  Future<void> getSliders() async {
    emit(SlidersLoading());
    var result = await slidersRepo.getSliders();
    result.fold(
      (error) => emit(SlidersError(error: error)),
      (data) {
        sliders = data;
        emit(SlidersSuccess(sliders: data));
      },
    );
  }
}