import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/features/profile/userdata/cubit/user_state.dart';
import 'package:shop/features/profile/userdata/data/user_repo.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepo userRepo;                              // ✅
  UserCubit(this.userRepo) : super(UserInitial());      // ✅
  
  static UserCubit get(context) => BlocProvider.of(context);

  void getUserData() async {
    emit(UserLoading());
    var result = await userRepo.getUserData();
    result.fold(
      (error) => emit(UserError(error: error)),
      (user) => emit(UserSuccess(user: user)),
    );
  }
}