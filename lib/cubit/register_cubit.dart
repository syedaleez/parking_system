import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/auth_repo.dart';

// States
class RegisterState {}
class RegisterInitial extends RegisterState {}
class RegisterLoading extends RegisterState {}
class RegisterSuccess extends RegisterState {}
class RegisterFailure extends RegisterState {
  final String errorMessage;
  RegisterFailure(this.errorMessage);
}

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository authRepository;

  RegisterCubit(this.authRepository) : super(RegisterInitial());

  Future<void> register(String fullName, String email, String password, String phoneNumber, String state, bool acceptedTerms) async {
    if (fullName.isEmpty || email.isEmpty || password.isEmpty || phoneNumber.isEmpty || state.isEmpty) {
      emit(RegisterFailure('All fields are required.'));
      return;
    }
    if (password.length < 6) {
      emit(RegisterFailure('Password must be at least 6 characters.'));
      return;
    }
    if (!acceptedTerms) {
      emit(RegisterFailure('You must accept the terms and conditions to register.'));
      return;
    } 
    emit(RegisterLoading());
    try {
      await authRepository.register(fullName, email, password, phoneNumber, state);
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure('Registration failed: ${e.toString()}'));
    }
  }
}
