import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static String sharedPreferencesUserLoggedInKey = 'ISLOGGEDIN';
  static String sharedPreferencesUserNameKey = 'USERNAMEKEY';
  static String sharedPreferencesUserEmailKey = 'USEREMAIL';

  static Future<bool> savedUserLogInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool(
        sharedPreferencesUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> getUserLogInSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.get(Constants.sharedPreferencesUserLoggedInKey) as bool;
  }
}
