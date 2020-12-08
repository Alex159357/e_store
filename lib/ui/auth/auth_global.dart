import 'package:e_store/data/app_values/app_values.dart';
import 'package:e_store/data/models/user_model.dart';
import 'package:e_store/services/auth.dart';

class AuthGlobal {
  //Values from field
  String email = "";
  String password = "";
  final AuthService _authService = AuthService();

  Future<String> login() async {
    dynamic result = await _authService.signInWithCredentials(
        email: email, password: password);
    if (result is UserModel) {
      print(result.uid);
      return "";
    } else
      return AppValues.text.emailError;
  }

  Future<String> skip() async {
    dynamic result = _authService.signInAnon();
    if (result is UserModel) {
      return "";
    } else
      return AppValues.text.skipError;
  }

  Future<String> signUp() async {
    dynamic result = await _authService.signUpWithCredentials(
        email: email, password: password);
    if (result is UserModel) {
      print(result.uid);
      return "";
    } else
      return AppValues.text.passwordError;
  }

  String validateEmail(String v) {
    if (v.isEmpty) {
      return AppValues.text.enterEmail;
    } else if (!v.contains("@")) {
      return AppValues.text.invalidEmail;
    } else
      return null;
  }

  String validatePassword(String v) {
    if (v.isEmpty) {
      return AppValues.text.enterPassword;
    }
    if (v.length < 6) {
      return AppValues.text.passwordHint;
    } else
      return null;
  }

  void setPass(String passFromField) {
    password = passFromField;
  }

  void setEmail(String emailFromField) {
    email = emailFromField;
  }
}
