import 'package:e_store/data/models/app_start_model.dart';
import 'package:e_store/handlers/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartAppService {
  static Future<AppStartModel> introState() async {
    AppStartModel appStartModel = AppStartModel();
    SharedPreferences sp = await SharedPreferences.getInstance();
    SharedPreferencesController.setSp = sp;
    appStartModel.setIntroState =
        SharedPreferencesController.sp.getBool("intro") != null
            ? SharedPreferencesController.sp.getBool("intro")
            : false;
    return appStartModel;
  }
}
