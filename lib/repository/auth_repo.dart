class AuthRepository {
  Future<bool> login(String email, String password) async {
    // API mili to call hogi 
    await Future.delayed(const Duration(seconds: 2));

    if (email == 'abc@gmail.com' && password == 'password') {
      return true;  
    }
    return false;  
  }
}
