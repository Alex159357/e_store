import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesController {
  static SharedPreferences _sp;

  static SharedPreferences get sp => _sp;

  static set setSp(SharedPreferences sp) {
    print("SP has bean seted");
    _sp = sp;
  }
}
