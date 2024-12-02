 class UserState {}

class UserInitial extends UserState {}
class UserLoading extends UserState {}
class UserDataLoaded extends UserState {
  final dynamic data;
  UserDataLoaded(this.data);
}

class UserError extends UserState {
  final String error;
  UserError(this.error);
}
