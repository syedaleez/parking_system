 class UserState {}

class UserInitial extends UserState {}
class UserLoading extends UserState {}
// class UserDataLoaded extends UserState {
//   final dynamic data;
//   UserDataLoaded(this.data);
// }

class UserDataLoaded extends UserState {
  final Map<String, dynamic> userData;

  UserDataLoaded(this.userData);
}

class UserError extends UserState {
  final String error;
  UserError(this.error);
}
