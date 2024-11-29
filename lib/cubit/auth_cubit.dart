import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/auth_repo.dart';
// import '../repository/auth_repository.dart';

 class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {}
class AuthFailure extends AuthState {
  final String errorMessage;
  AuthFailure(this.errorMessage);
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit(this.authRepository) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      bool isAuthenticated = await authRepository.login(email, password);
      if (isAuthenticated) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure('Invalid email or password'));
      }
    } catch (e) {
      emit(AuthFailure('Login failed: ${e.toString()}'));
    }
  }
}
