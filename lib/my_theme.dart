// import 'package:shared_preferences/shared_preferences.dart';

// class MyTheme{

//   SharedPreferences? prefs;

//   bool isDarkMode = false;
//   String themeColor = "Colors.white";

//   SettingsProvider() {
//     getSettings();
//   }

//   /// SharedPreferences - 테마 변경 저장된 값 있으면 가져오기 (없으면 기본값)
//   Future<void> getSettings() async {
//     final prefs = await SharedPreferences.getInstance();
//     isDarkMode = prefs.getBool('isDarkMode') ?? false;
//     themeColor = prefs.getString('themeColor') ?? 'Colors.white';
//   }


//   Future<void> setDarkMode(bool value) async {
//     isDarkMode = value;
//     await prefs!.setBool('isDarkMode', value);
//   }

//   Future<void> setThemeColor(String color) async {
//     themeColor = color;
//     await prefs!.setString('themeColor', color);
//   }
// }