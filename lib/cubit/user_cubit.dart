import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/user_repo.dart';
import '../states/user_state.dart';


class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;

  UserCubit(this.userRepository) : super(UserInitial());

  Future<void> fetchUserData() async {
    emit(UserLoading());
    try {
      final data = await userRepository.getUserData();
      emit(UserDataLoaded(data));
    } catch (e) {
      emit(UserError('Failed to load user data: ${e.toString()}'));
    }
  }
}
