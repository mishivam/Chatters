import 'package:shared_preferences/shared_preferences.dart';

//storing data to local devices....
class SharedPreferenceFunction{

  static String sharedPreferenceUserLoggedInKey = 'ISLOGGEDIN';
  static String sharedPreferenceUserNameKey = 'USERNAMEKEY';
  static String sharedPreferenceUserEmailKey = 'USEREMAILKEY';

  //saving data to sharedPreferences...
  static Future<bool> saveUserLoggedInSharedPref([bool isUserLoggedIn = false ])async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return await _prefs.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameInSharedPref(String userName) async{
    print('from sharedpreference saveUserName:'+ userName);
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return await _prefs.setString(sharedPreferenceUserNameKey, userName);
  }

  static Future<bool> saveUserEmailInSharedPref(String userEmail) async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return await _prefs.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  //Get data from sharedPref...
  static Future<bool> getUserLoggedInSharedPref() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return  _prefs.getBool(sharedPreferenceUserLoggedInKey);
  }
  static Future<String> getUserNameInSharedPref() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return  _prefs.getString(sharedPreferenceUserNameKey);
  }
  static Future<String> getUserEmailInSharedPref() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return  _prefs.getString(sharedPreferenceUserEmailKey);
  }
}