import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  static String valueSharedPreferences = '';

  //clear the data shared preferences//
  clearPref() async{
    var sharePref = await SharedPreferences.getInstance();
    sharePref.clear();
  }

// Write the DATA  shared preferences //
  static Future<bool> saveUserData(value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setInt(valueSharedPreferences, value);
  }

// Read the Data from shared  preferences //
  static Future getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(valueSharedPreferences);
  }
}
